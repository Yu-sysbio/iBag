%% Validation for amino acids and carbon sources

Unlimited_reactions = {'EX0004' 'EX0005' 'EX0006' 'EX0007' 'EX0008' 'EX0009' 'EX0010' 'EX0011' 'EX0012' 'EX0013'};
AA_reactions = {'EX0014' 'EX0015' 'EX0016' 'EX0017' 'EX0018' 'EX0019' 'EX0020' 'EX0021' 'EX0022' 'EX0023' 'EX0024'};

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
CS_list =  {'Glucose[e]'
            'D_Fructose[e]'
            'Galactose[e]'
            'Maltose[e]'
            'D_Mannose[e]'
            'Sucrose[e]'
            'Trehalose[e]'
            'Xylose[e]'};
        
%% iBag597 AA
load('iBag597.mat');
model = changeRxnBounds(model,'R0219',0,'b');
model = changeRxnBounds(model,'EX0001',-1,'l');
model = changeRxnBounds(model,'Biomass',0,'b');
model = changeRxnBounds(model,'GAM',1000,'u');

model = changeRxnBounds(model,Unlimited_reactions,ones(1,length(Unlimited_reactions))*-1000,'l');
  
ExRxn_idx = contains(model.rxns, 'EX');

% AA production from glucose
gr1_list = zeros(length(AA_list),1);

for i = 1:length(AA_list)
    aaid = AA_list(i);
    idx_tmp = full(model.S(ismember(model.mets,aaid),:) ~= 0)';
    exrxnid = model.rxns(idx_tmp & ExRxn_idx);
    model_tmp = changeObjective(model,exrxnid);
    sol_tmp = optimizeCbModel(model_tmp,'max','one');
    gr1_list(i) = sol_tmp.f;
end

AAtf1_list = gr1_list > 0;

% AA single omission
idx_tmp = sum(full(model.S(ismember(model.mets,AA_list),:) ~= 0))' > 0;
AAExRxn_list = model.rxns(idx_tmp & ExRxn_idx);

model = changeRxnBounds(model,AAExRxn_list,ones(1,length(AAExRxn_list))*-1,'l');

gr2_list = zeros(length(AA_list),1);

model_tmp = changeObjective(model,'GAM');
model_tmp = changeRxnBounds(model_tmp,'GAM',1000,'u');
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
AAtf2_list = relative_list > 0;

clear aaid exrxnid gr1_list gr2_list gr2_ref i idx_tmp model model_tmp;
clear model_tmptmp relative_list sol_ref sol_tmp sol_tmptmp ExRxn_idx;
clear AAExRxn_list;

%% iBag597 CS
load('iBag597.mat');
model = changeRxnBounds(model,'R0219',0,'b');

model = changeRxnBounds(model,Unlimited_reactions,ones(1,length(Unlimited_reactions))*-1000,'l');
% model = changeRxnBounds(model,AA_reactions,ones(1,length(AA_reactions))*-1,'l');
model = changeRxnBounds(model,'Biomass',0,'b');
model = changeRxnBounds(model,'GAM',1000,'u');
        
ExRxn_idx = contains(model.rxns, 'EX');

model_tmp = changeObjective(model,'GAM');

% CSExRxn_list = model.rxns(idx_tmp & ExRxn_idx);
% idx_tmp = sum(full(model.S(ismember(model.mets,CS_list),:) ~= 0))' > 0;
% model_ref = changeRxnBounds(model_tmp,CSExRxn_list,zeros(1,length(CSExRxn_list)),'b');
% sol_ref = optimizeCbModel(model_ref,'max','one');
% gr_ref = sol_ref.f;

CSgr_list = zeros(length(CS_list),1);
for i = 1:length(CS_list)
    csid = CS_list(i);
    idx_tmp = full(model_tmp.S(ismember(model_tmp.mets,csid),:) ~= 0)';
    exrxnid = model_tmp.rxns(idx_tmp & ExRxn_idx);
    model_tmptmp = changeRxnBounds(model_tmp,exrxnid,-1,'l');
    sol_tmptmp = optimizeCbModel(model_tmptmp,'max','one');
    CSgr_list(i) = sol_tmptmp.f;
end

clear csid ExRxn_idx exrxnid i idx_tmp model model_tmp model_tmptmp;
clear sol_tmptmp CSExRxn_list;

%% eciBag597 AA
load('eciBag597.mat');
model = ecModel;
model = changeRxnBounds(model,'R0219No1',0,'b');
model = changeRxnBounds(model,'R0219_REVNo1',0,'b');
model = changeRxnBounds(model,'EX0001',-1,'l');
model = changeRxnBounds(model,'Biomass',0,'b');
model = changeRxnBounds(model,'GAM',1000,'u');

model = changeRxnBounds(model,Unlimited_reactions,ones(1,length(Unlimited_reactions))*-1000,'l');
  
ExRxn_idx = contains(model.rxns, 'EX');

% AA production from glucose
AA_list = cellfun(@(x) strrep(x,'[e]','_e'),AA_list,'UniformOutput',false);
ec_gr1_list = zeros(length(AA_list),1);

for i = 1:length(AA_list)
    aaid = AA_list(i);
    idx_tmp = full(model.S(ismember(model.mets,aaid),:) < 0)';
    exrxnid = model.rxns(idx_tmp & ExRxn_idx);
    model_tmp = changeObjective(model,exrxnid);
    sol_tmp = optimizeCbModel(model_tmp,'max','one');
    ec_gr1_list(i) = sol_tmp.f;
end

ec_AAtf1_list = ec_gr1_list > 0;

% AA single omission
idx_tmp = sum(full(model.S(ismember(model.mets,AA_list),:) < 0))' > 0;
AAExRxn_list = model.rxns(idx_tmp & ExRxn_idx);

model = changeRxnBounds(model,AAExRxn_list,ones(1,length(AAExRxn_list))*-1,'l');

ec_gr2_list = zeros(length(AA_list),1);

model_tmp = changeObjective(model,'GAM');
model_tmp = changeRxnBounds(model_tmp,'GAM',1000,'u');
sol_ref = optimizeCbModel(model_tmp,'max','one');
ec_gr2_ref = sol_ref.f;

for i = 1:length(AA_list)
    aaid = AA_list(i);
    idx_tmp = full(model_tmp.S(ismember(model_tmp.mets,aaid),:) < 0)';
    exrxnid = model_tmp.rxns(idx_tmp & ExRxn_idx);
    model_tmptmp = changeRxnBounds(model_tmp,exrxnid,0,'b');
    sol_tmptmp = optimizeCbModel(model_tmptmp,'max','one');
    ec_gr2_list(i) = sol_tmptmp.f;
end
relative_list = ec_gr2_list/ec_gr2_ref;
ec_AAtf2_list = relative_list > 0;

clear aaid exrxnid ec_gr1_list ec_gr2_list ec_gr2_ref i idx_tmp model model_tmp;
clear model_tmptmp relative_list sol_ref sol_tmp sol_tmptmp ExRxn_idx;
clear ecModel;

%% eciBag597 CS
load('eciBag597.mat');
model = ecModel;
model = changeRxnBounds(model,'R0219No1',0,'b');
model = changeRxnBounds(model,'R0219_REVNo1',0,'b');
model = changeRxnBounds(model,'Biomass',0,'b');
model = changeRxnBounds(model,'GAM',1000,'u');

model = changeRxnBounds(model,Unlimited_reactions,ones(1,length(Unlimited_reactions))*-1000,'l');
% model = changeRxnBounds(model,AA_reactions,ones(1,length(AA_reactions))*-1,'l');
        
ExRxn_idx = contains(model.rxns, 'EX');

model_tmp = changeObjective(model,'GAM');

% CSExRxn_list = model.rxns(idx_tmp & ExRxn_idx);
% idx_tmp = sum(full(model.S(ismember(model.mets,CS_list),:) < 0))' > 0;
% model_ref = changeRxnBounds(model_tmp,CSExRxn_list,zeros(1,length(CSExRxn_list)),'b');
% sol_ref = optimizeCbModel(model_ref,'max','one');
% gr_ref = sol_ref.f;

CS_list = cellfun(@(x) strrep(x,'[e]','_e'),CS_list,'UniformOutput',false);

ec_CSgr_list = zeros(length(CS_list),1);
for i = 1:length(CS_list)
    csid = CS_list(i);
    idx_tmp = full(model_tmp.S(ismember(model_tmp.mets,csid),:) < 0)';
    exrxnid = model_tmp.rxns(idx_tmp & ExRxn_idx);
    model_tmptmp = changeRxnBounds(model_tmp,exrxnid,-1,'l');
    sol_tmptmp = optimizeCbModel(model_tmptmp,'max','one');
    ec_CSgr_list(i) = sol_tmptmp.f;
end

clear csid ExRxn_idx exrxnid i idx_tmp model model_tmp model_tmptmp;
clear sol_tmptmp CSExRxn_list;
clear ecModel;
