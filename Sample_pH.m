options.nStepsPerPoint = 200;
options.nPointsReturned = 10000;

load('iBag597.mat');

model = changeRxnBounds(model,'NGAM',1000,'u');
model = changeRxnBounds(model,'Biomass',1000,'u');
model = changeRxnBounds(model,'GAM',0,'b');
model = changeRxnBounds(model,'R0095',0,'b'); %block PFL reaction for aerobic condition
model = changeRxnBounds(model,'R0219',0,'b');

% import chemostat data
[exchange_data, ~, exchange_raw] = xlsread('Chemostat_data.xlsx','Data4Simulation_pH');

Exchange_reactions = exchange_raw(2:end,1);
header = exchange_raw(1,:);

tmp = exchange_raw(:,ismember(header,'LB_D020A'));
LB_D020A = cell2mat(tmp(2:end));
tmp = exchange_raw(:,ismember(header,'UB_D020A'));
UB_D020A = cell2mat(tmp(2:end));
tmp = exchange_raw(:,ismember(header,'LB_D020B'));
LB_D020B = cell2mat(tmp(2:end));
tmp = exchange_raw(:,ismember(header,'UB_D020B'));
UB_D020B = cell2mat(tmp(2:end));
tmp = exchange_raw(:,ismember(header,'LB_D020Alowph'));
LB_D020Alowph = cell2mat(tmp(2:end));
tmp = exchange_raw(:,ismember(header,'UB_D020Alowph'));
UB_D020Alowph = cell2mat(tmp(2:end));
tmp = exchange_raw(:,ismember(header,'LB_D020Blowph'));
LB_D020Blowph = cell2mat(tmp(2:end));
tmp = exchange_raw(:,ismember(header,'UB_D020Blowph'));
UB_D020Blowph = cell2mat(tmp(2:end));

lb_ph060 = min(LB_D020A,LB_D020B);
ub_ph060 = max(UB_D020A,UB_D020B);
lb_ph055 = min(LB_D020Alowph,LB_D020Blowph);
ub_ph055 = max(UB_D020Alowph,UB_D020Blowph);

model_ph060 = changeRxnBounds(model,Exchange_reactions,lb_ph060,'l');
model_ph060 = changeRxnBounds(model_ph060,Exchange_reactions,ub_ph060,'u');
model_ph055 = changeRxnBounds(model,Exchange_reactions,lb_ph055,'l');
model_ph055 = changeRxnBounds(model_ph055,Exchange_reactions,ub_ph055,'u');

model = changeObjective(model,'EXBiomass');
model_ph060 = changeRxnBounds(model_ph060,'EXBiomass',0.2,'b');
model_ph055 = changeRxnBounds(model_ph055,'EXBiomass',0.2,'b');

[modelSampling_ph060,samples_ph060] = sampleCbModel(model_ph060, [], [], options);
[modelSampling_ph055,samples_ph055] = sampleCbModel(model_ph055, [], [], options);

cd SimResult/;
save('samples_ph060.mat','samples_ph060');
save('samples_ph055.mat','samples_ph055');
cd ../;
