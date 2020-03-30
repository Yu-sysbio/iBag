% model = xls2model('iBag604.xlsx');
load('iBag604.mat');

Unlimited_reactions = {'EX0004' 'EX0005' 'EX0006' 'EX0007' 'EX0008' 'EX0009' 'EX0010' 'EX0011' 'EX0012' 'EX0013'};

model = changeRxnBounds(model,Unlimited_reactions,ones(1,length(Unlimited_reactions))*-1000,'l');
model = changeRxnBounds(model,'EX0001',-1,'l');
model = changeRxnBounds(model,'Biomass',0,'b');
model = changeRxnBounds(model,'Biomass_GAM',1000,'u');

AA_list =  {'L_Alanine[e]'
            'L_Arginine[e]'
            'L_Asparagine[e]'
            'L_Aspartate[e]'
            'L_Cysteine[e]'
            'L_Glutamate[e]'
            'L_Glutamine[e]'
            'Glycine[e]'
            'L_Histidine[e]'
            'L_Isoleucine[e]'
            'L_Leucine[e]'
            'L_Lysine[e]'
            'L_Methionine[e]'
            'L_Phenylalanine[e]'
            'L_Proline[e]'
            'L_Serine[e]'
            'L_Threonine[e]'
            'L_Tryptophan[e]'
            'L_Tyrosine[e]'
            'L_Valine[e]'};
        
ExRxn_idx = contains(model.rxns, 'EX');

%% AA production from glucose
gr1_list = zeros(length(AA_list),1);

for i = 1:length(AA_list)
    aaid = AA_list(i);
    idx_tmp = full(model.S(ismember(model.mets,aaid),:) ~= 0)';
    exrxnid = model.rxns(idx_tmp & ExRxn_idx);
    model_tmp = changeObjective(model,exrxnid);
    sol_tmp = optimizeCbModel(model_tmp,'max','one');
    gr1_list(i) = sol_tmp.f;
end

tf1_list = gr1_list > 0;

%% AA single omission

idx_tmp = sum(full(model.S(ismember(model.mets,AA_list),:) ~= 0))' > 0;
AAExRxn_list = model.rxns(idx_tmp & ExRxn_idx);

model = changeRxnBounds(model,AAExRxn_list,ones(1,length(AAExRxn_list))*-1,'l');

gr2_list = zeros(length(AA_list),1);

model_tmp = changeObjective(model,'Biomass_GAM');
model_tmp = changeRxnBounds(model_tmp,'Biomass_GAM',1000,'u');
% model_tmp = changeRxnBounds(model_tmp,'R0458',0,'b');
sol_ref = optimizeCbModel(model_tmp,'max','one');
gr2_ref = sol_ref.f;

for i = 1:length(AA_list)
    aaid = AA_list(i);
    idx_tmp = full(model_tmp.S(ismember(model_tmp.mets,aaid),:) ~= 0)';
    exrxnid = model_tmp.rxns(idx_tmp & ExRxn_idx);
    model_tmptmp = changeRxnBounds(model_tmp,exrxnid,0,'b');
    sol_tmptmp = optimizeCbModel(model_tmptmp,'max','one');
    gr2_list(i) = sol_tmptmp.f;
end
relative_list = gr2_list/gr2_ref;
tf2_list = relative_list > 0;