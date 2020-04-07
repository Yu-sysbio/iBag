load('eciBag597.mat');
model = ecModel;
model = changeRxnBounds(model,'R0219No1',0,'b');
model = changeRxnBounds(model,'R0219_REVNo1',0,'b');
model = changeRxnBounds(model,'Biomass',0,'b');
model = changeRxnBounds(model,'GAM',0,'b');
model = changeRxnBounds(model,'R0095No1',0,'b'); %block PFL reaction for aerobic condition

model = changeRxnBounds(model,'prot_pool_exchange',1000,'u');

% block reactions
ExRxn_idx = contains(model.rxns, 'EX');
rxn_tmp = model.rxns(ExRxn_idx);
model = changeRxnBounds(model,rxn_tmp,zeros(length(rxn_tmp),1),'l');

Unlimited_reactions = {'EX0004' 'EX0005' 'EX0006' 'EX0007' 'EX0008' 'EX0009' 'EX0010' 'EX0011' 'EX0012' 'EX0013'};
model = changeRxnBounds(model,Unlimited_reactions,ones(1,length(Unlimited_reactions))*-1000,'l');
model = changeRxnBounds(model,Unlimited_reactions,ones(1,length(Unlimited_reactions))*1000,'u');

model = changeRxnBounds(model,'EX0001',-1,'l');
model = changeRxnBounds(model,'NGAM',1000,'u');

%% pathway 1: glycolysis + lactate fermentation
model_1 = model;
model_1 = changeObjective(model_1,'EX0002');
sol_1 = optimizeCbModel(model_1,'max','one');
model_1 = changeRxnBounds(model_1,'EX0002',sol_1.f,'b');
model_1 = changeObjective(model_1,'prot_pool_exchange');
sol_1 = optimizeCbModel(model_1,'min','one');
protein_cost_1 = sol_1.x(ismember(model.rxns,'prot_pool_exchange'));
Yatp_1 = sol_1.x(ismember(model.rxns,'NGAM'))/-sol_1.x(ismember(model.rxns,'EX0001'));
prot_eff_1 = Yatp_1/protein_cost_1;

%% pathway 2: upper glycolysis + xpk + lactate fermentation
model_2 = model;
model_2 = changeRxnBounds(model_2,'arm_R0101_REV',1.5,'b');
model_2 = changeRxnBounds(model_2,'EX0068',1.5,'b');
model_2 = changeObjective(model_2,'EX0002');
sol_2 = optimizeCbModel(model_2,'max','one');
model_2 = changeRxnBounds(model_2,'EX0002',sol_2.f,'b');
model_2 = changeObjective(model_2,'prot_pool_exchange');
sol_2 = optimizeCbModel(model_2,'min','one');
protein_cost_2 = sol_2.x(ismember(model.rxns,'prot_pool_exchange'));
Yatp_2 = sol_2.x(ismember(model.rxns,'NGAM'))/-sol_2.x(ismember(model.rxns,'EX0001'));
prot_eff_2 = Yatp_2/protein_cost_2;


%% pathway 3: glycolysis + pdh + OXPHOS
% model_3 = model;
% model_3 = changeObjective(model_3,'NGAM');
% sol_3 = optimizeCbModel(model_3,'max','one');
% model_3 = changeRxnBounds(model_3,'NGAM',sol_3.f,'b');
% model_3 = changeObjective(model_3,'prot_pool_exchange');
% sol_3 = optimizeCbModel(model_3,'min','one');
% protein_cost_3 = sol_3.x(ismember(model.rxns,'prot_pool_exchange'));
% Yatp_3 = sol_3.x(ismember(model.rxns,'NGAM'))/-sol_3.x(ismember(model.rxns,'EX0001'));
% prot_eff_3 = Yatp_3/protein_cost_3;

%% pathway 4: upper glycolysis + xpk + pdh + acetate fermentation + OXPHOS
% model_4 = model;
% model_4 = changeObjective(model_4,'EX0068');
% sol_4 = optimizeCbModel(model_4,'max','one');
% protein_cost_4 = sol_4.x(ismember(model.rxns,'prot_pool_exchange'));
% Yatp_4 = sol_4.x(ismember(model.rxns,'NGAM'))/-sol_4.x(ismember(model.rxns,'EX0001'));
% prot_eff_4 = Yatp_4/protein_cost_4;

%% pathway 5: glycolysis + pdh + acetate fermentation + OXPHOS
% model_5 = model;
% model_5 = changeRxnBounds(model_5,'R0032No1',0,'b');
% model_5 = changeObjective(model_5,'EX0068');
% sol_5 = optimizeCbModel(model_5,'max','one');
% protein_cost_5 = sol_5.x(ismember(model.rxns,'prot_pool_exchange'));
% Yatp_5 = sol_5.x(ismember(model.rxns,'NGAM'))/-sol_5.x(ismember(model.rxns,'EX0001'));
% prot_eff_5 = Yatp_5/protein_cost_5;
