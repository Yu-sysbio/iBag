% model = xls2model('iBag604.xlsx');
load('iBag604.mat');

Unlimited_reactions = {'EX0004' 'EX0005' 'EX0006' 'EX0007' 'EX0008' 'EX0009' 'EX0010' 'EX0011' 'EX0012' 'EX0013'};
AA_reactions = {'EX0014' 'EX0015' 'EX0016' 'EX0017' 'EX0018' 'EX0019' 'EX0020' 'EX0021' 'EX0022' 'EX0023' 'EX0024'};

model = changeRxnBounds(model,Unlimited_reactions,ones(1,length(Unlimited_reactions))*-1000,'l');
% model = changeRxnBounds(model,AA_reactions,ones(1,length(AA_reactions))*-1,'l');
model = changeRxnBounds(model,'Biomass',0,'b');
model = changeRxnBounds(model,'Biomass_GAM',1000,'u');

CS_list =  {'Glucose[e]'
            'D_Fructose[e]'
            'Galactose[e]'
            'Maltose[e]'
            'D_Mannose[e]'
            'Sucrose[e]'
            'Trehalose[e]'
            'Xylose[e]'};
        
ExRxn_idx = contains(model.rxns, 'EX');

%% Main simulations

idx_tmp = sum(full(model.S(ismember(model.mets,CS_list),:) ~= 0))' > 0;
CSExRxn_list = model.rxns(idx_tmp & ExRxn_idx);

gr_list = zeros(length(CS_list),1);

model_tmp = changeObjective(model,'Biomass_GAM');
model_tmp = changeRxnBounds(model_tmp,'Biomass_GAM',1000,'u');

model_ref = changeRxnBounds(model_tmp,CSExRxn_list,zeros(1,length(CSExRxn_list)),'b');
sol_ref = optimizeCbModel(model_ref,'max','one');
gr_ref = sol_ref.f;

for i = 1:length(CS_list)
    csid = CS_list(i);
    idx_tmp = full(model_tmp.S(ismember(model_tmp.mets,csid),:) ~= 0)';
    exrxnid = model_tmp.rxns(idx_tmp & ExRxn_idx);
    model_tmptmp = changeRxnBounds(model_tmp,exrxnid,-1,'l');
    sol_tmptmp = optimizeCbModel(model_tmptmp,'max','one');
    gr_list(i) = sol_tmptmp.f;
end
