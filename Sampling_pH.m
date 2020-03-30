options.nStepsPerPoint = 200;
options.nPointsReturned = 10000;

model = xls2model('iBag604.xlsx');
% load('iBag604.mat');
model = changeObjective(model,'Biomass_Out');
model = changeRxnBounds(model,'Biomass_GAM',0,'b');
model = changeRxnBounds(model,'Biomass',1000,'u');

% block reactions
ExRxn_idx = contains(model.rxns, 'EX');
rxn_tmp = model.rxns(ExRxn_idx);
model = changeRxnBounds(model,rxn_tmp,zeros(length(rxn_tmp),1),'b');

model = changeRxnBounds(model,'R0095',0,'b'); %block PFL reaction for aerobic condition

% import chemostat data
% [exchange_data, ~, exchange_raw] = xlsread('Chemostat_data.xlsx','Sheet2'); %use mean ± SD as LB and UB
[exchange_data, ~, exchange_raw] = xlsread('Chemostat_data.xlsx','Sheet3');

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

model_ph060 = changeRxnBounds(model_ph060,'Biomass_Out',0.2,'b');
model_ph055 = changeRxnBounds(model_ph055,'Biomass_Out',0.2,'b');

sol_ph060 = optimizeCbModel(model_ph060,'max','one');
sol_ph055 = optimizeCbModel(model_ph055,'max','one');

[modelSampling_ph060,samples_ph060] = sampleCbModel(model_ph060, [], [], options);
[modelSampling_ph055,samples_ph055] = sampleCbModel(model_ph055, [], [], options);

%% Plot
samples_1 = samples_ph060;
samples_2 = samples_ph055;
samples_1(abs(samples_1)<1e-6)=0;
samples_2(abs(samples_2)<1e-6)=0;
samples_1 = round(samples_1,5);
samples_2 = round(samples_2,5);

sampledRxns = {'R0012'
'R0008'
'R0037'
'R0031'
'R0032'
'R0001'
'R0004'
'R0020'
'R0098'
'R0101'
'R0109'
'R0141'};

RxnIDs = {'PGI'
'FBA'
'TKT'
'RPE'
'XPK'
'PYK'
'LDH'
'PDH'
'PTA'
'ACK'
'CS'
'ETC'};

rxnsIdx = findRxnIDs(model, sampledRxns);

nbins = 100;
ph60_clr = [50,136,189]/255;
ph55_clr = [213,62,79]/255;

pvalues = ones(length(sampledRxns),1);

for i = 1:length(sampledRxns)
    tmp = 1;
    if i == 10
        tmp = -1;
    end
    subplot(2,6,i);
    p = ranksum(samples_1(rxnsIdx(i), :),samples_2(rxnsIdx(i), :));
    pvalues(i,1) = p;
    hold on;
    [y1, x1] = hist(samples_1(rxnsIdx(i), :)*tmp, nbins);
    [y2, x2] = hist(samples_2(rxnsIdx(i), :)*tmp, nbins);
    plot(x1, y1, 'Color', ph60_clr);
    plot(x2, y2, 'Color', ph55_clr);
    f1 = fill([x1,fliplr(x1)],[y1,zeros(1,length(x1))],ph60_clr);
    set(f1,'edgealpha',0,'facealpha',0.5);
    f2 = fill([x2,fliplr(x2)],[y2,zeros(1,length(x2))],ph55_clr);
    set(f2,'edgealpha',0,'facealpha',0.5);
    title(sprintf('%s', strcat(num2str(i),'. ',RxnIDs{i})));
    set(gca,'FontSize',8,'FontName','Helvetica');
%     xlim([-2 2]);
    hold off;
end

