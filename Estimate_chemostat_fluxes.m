model = xls2model('iBag604.xlsx');
% load('iBag604.mat');
model = changeObjective(model,'NGAM');
model = changeRxnBounds(model,'Biomass',0,'b');
model = changeRxnBounds(model,'Biomass_GAM',1000,'u');

% block reactions
ExRxn_idx = contains(model.rxns, 'EX');
rxn_tmp = model.rxns(ExRxn_idx);
model = changeRxnBounds(model,rxn_tmp,zeros(length(rxn_tmp),1),'b');

model = changeRxnBounds(model,'R0095',0,'b'); %block PFL reaction for aerobic condition

% import chemostat data
% [~, ~, exchange_raw] = xlsread('Chemostat_data.xlsx','Sheet1'); %use 98% mean and 102% mean as LB and UB
[~, ~, exchange_raw] = xlsread('Chemostat_data.xlsx','Sheet2'); %use mean ± SD as LB and UB

Exchange_reactions = exchange_raw(2:end,1);
header = exchange_raw(1,1:26);

chemostat_idx = find(contains(header,'LB_'));

Qatp_list = zeros(1,length(chemostat_idx));
fluxes = zeros(length(model.rxns),length(chemostat_idx));
chemostat_id_list = cell(1,length(chemostat_idx));
FVA_res = zeros(length(model.rxns),length(chemostat_idx)*2);

for i = 1:length(chemostat_idx)
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
%         [minFlux, maxFlux, ~, ~] = fluxVariability(model_tmp);
        FVA_res(:,2*i-1) = minFlux;
        FVA_res(:,2*i) = maxFlux;
    end
    chemostat_id_list(1,i) = {chemostat_id};
end

FVA_res(abs(FVA_res) < 1e-6) = 0;
fluxes(abs(fluxes) < 1e-6) = 0;

clear chemostat_id chemostat_id_tmp chemostat_idx;
clear exchange_raw Exchange_reactions header i LB UB lb_idx ub_idx;
clear model_tmp sol_tmp maxFlux minFlux;




