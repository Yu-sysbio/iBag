%% Import chemostat data
[~, ~, exchange_raw] = xlsread('Chemostat_data.xlsx','Data4Simulation'); %use mean ± SD as LB and UB

Exchange_reactions = exchange_raw(2:end,1);
header = exchange_raw(1,1:26);

chemostat_idx = find(contains(header,'LB_'));

%% Load model
load('iBag597.mat');

model = changeObjective(model,'NGAM');
model = changeRxnBounds(model,'Biomass',0,'b');
model = changeRxnBounds(model,'GAM',1000,'u');

% block reactions
% ExRxn_idx = contains(model.rxns, 'EX');
% rxn_tmp = model.rxns(ExRxn_idx);
% model = changeRxnBounds(model,rxn_tmp,zeros(length(rxn_tmp),1),'b');

model = changeRxnBounds(model,'R0095',0,'b'); %block PFL reaction for aerobic condition
model = changeRxnBounds(model,'R0219',0,'b');

%% Chemostat
Qatp_list = zeros(1,length(chemostat_idx));
fluxes = zeros(length(model.rxns),length(chemostat_idx));
chemostat_id_list = cell(1,length(chemostat_idx));
FVA_res = zeros(length(model.rxns),length(chemostat_idx)*2);

for i = 1:length(chemostat_idx)
    disp([num2str(i) '/' num2str(length(chemostat_idx))]);
    lb_idx = chemostat_idx(i);
    ub_idx = lb_idx + 1;
    chemostat_id_tmp = header{lb_idx};
    chemostat_id = chemostat_id_tmp(4:end);
    LB = cell2mat(exchange_raw(2:end,lb_idx));
    UB = cell2mat(exchange_raw(2:end,ub_idx));
    model_tmp = model;
	model_tmp = changeRxnBounds(model_tmp,Exchange_reactions,LB,'l');
	model_tmp = changeRxnBounds(model_tmp,Exchange_reactions,UB,'u');
    
	sol_tmp = optimizeCbModel(model_tmp,'max','one');
    Qatp_list(1,i) = sol_tmp.f;
    if sol_tmp.stat == 1
        fluxes(:,i) = sol_tmp.x;
        [minFlux, maxFlux, ~] = fastFVA(model_tmp);
        FVA_res(:,2*i-1) = minFlux;
        FVA_res(:,2*i) = maxFlux;
    end
    chemostat_id_list(1,i) = {chemostat_id};
end

fluxes(abs(fluxes) < 1e-6) = 0;
FVA_res(abs(FVA_res) < 1e-6) = 0;

cd SimResult/;
res_qatp = [fluxes(ismember(model.rxns,'EXBiomass'),1:10);Qatp_list(1:10)];
res_qatp_ph = Qatp_list(contains(chemostat_id_list,'D020')); 
res_chem_fluxes = fluxes(:,1:10);
res_chem_FVA = FVA_res(:,1:end-4);
save('res_qatp.mat','res_qatp');
save('res_qatp_ph.mat','res_qatp_ph');
save('res_chem_fluxes.mat','res_chem_fluxes');
save('res_chem_FVA.mat','res_chem_FVA');
cd ../;

%% Batch
qglc_batch = -13.3;
qlac_batch = 21.5;
mu_batch = 0.263;

model_batch = model;

model_batch = changeRxnBounds(model_batch,'EX0001',qglc_batch,'b');%glc
model_batch = changeRxnBounds(model_batch,'EX0002',qlac_batch,'b');%lac
model_batch = changeRxnBounds(model_batch,'EXBiomass',mu_batch,'b');%lac

Unlimited_reactions = {'EX0004' 'EX0005' 'EX0006' 'EX0007' 'EX0008' 'EX0009' 'EX0010' 'EX0011' 'EX0012' 'EX0013'};
model_batch = changeRxnBounds(model_batch,Unlimited_reactions,ones(1,length(Unlimited_reactions))*-1000,'l');

model_batch = changeRxnBounds(model_batch,'EX0003',1.2542*mu_batch+0.4863,'b');%CO2
model_batch = changeRxnBounds(model_batch,'EX0068',9.9*mu_batch,'b');%acetate
% model_batch = changeRxnBounds(model_batch,'EX0069',1.95*mu_batch,'b');%citrate
% model_batch = changeRxnBounds(model_batch,'EX0070',3.96*mu_batch,'b');%pyruvate

% AA
model_batch = changeRxnBounds(model_batch,'EX0014',0,'l');%ala
model_batch = changeRxnBounds(model_batch,'EX0015',-100,'l');%arg
model_batch = changeRxnBounds(model_batch,'EX0016',-100,'l');%cys
model_batch = changeRxnBounds(model_batch,'EX0017',-1.538*mu_batch,'l');%glu
model_batch = changeRxnBounds(model_batch,'EX0018',-100,'l');%his
model_batch = changeRxnBounds(model_batch,'EX0019',-100,'l');%ile
model_batch = changeRxnBounds(model_batch,'EX0020',-100,'l');%leu
model_batch = changeRxnBounds(model_batch,'EX0021',-100,'l');%met
model_batch = changeRxnBounds(model_batch,'EX0022',-2.3224*mu_batch,'l');%thr
model_batch = changeRxnBounds(model_batch,'EX0023',0.5562*mu_batch,'l');%val
model_batch = changeRxnBounds(model_batch,'EX0024',-1.536*mu_batch,'l');%tyr

sol_batch = optimizeCbModel(model_batch,'max','one');

sol_batch.x(abs(sol_batch.x) < 1e-6) = 0;


