%% Read Excel model
model = readCbModel('iBag597.xlsx');
model.id = 'iBag597';
model.description = 'iBag597';

%% Add protein information
[a, b, ~] = xlsread('iBag597.xlsx','Gene List');
%Uniprot ID and molecular weight
b1 = b(2:end,1);
b2 = b(2:end,2);
model.proteinUniprotID = cell(length(model.genes),1);
model.proteinMW = zeros(length(model.genes),1);
for i = 1:length(model.genes)
    model.proteinUniprotID(i) = b2(ismember(b1,model.genes(i)));
    model.proteinMW(i) = a(ismember(b1,model.genes(i)));
end
clear a b b1 b2 i;

%% Add SBO
%rxns
[~, b, ~] = xlsread('iBag597.xlsx','Reaction List');
b1 = b(2:end,1);
b2 = b(2:end,11);
model.rxnSBOTerms = cell(length(model.rxns),1);
for i = 1:length(model.rxns)
    model.rxnSBOTerms(i) = b2(ismember(b1,model.rxns(i)));
end
clear b b1 b2 i;
%mets
[~, b, ~] = xlsread('iBag597.xlsx','Metabolite List');
b1 = b(2:end,1);
b2 = b(2:end,6);
model.metSBOTerms = cell(length(model.mets),1);
for i = 1:length(model.mets)
    tmp = model.mets{i};
    if strcmp(tmp(end-1),'c')
        tmp = tmp(1:end-3);
    end
    model.metSBOTerms(i) = b2(ismember(b1,{tmp}));
end
clear b b1 b2 i tmp;

cd ModelFiles/;
save('iBag597.mat','model');

%% Set model
model = changeRxnBounds(model,'EX0001',-1,'l');
model = changeRxnBounds(model,'Biomass',0,'b');
Unlimited_reactions = {'EX0004' 'EX0005' 'EX0006' 'EX0007' 'EX0008' 'EX0009' 'EX0010' 'EX0011' 'EX0012' 'EX0013'};
model = changeRxnBounds(model,Unlimited_reactions,ones(1,length(Unlimited_reactions))*-1,'l');
AA_reactions = {'EX0014' 'EX0015' 'EX0016' 'EX0017' 'EX0018' 'EX0019' 'EX0020' 'EX0021' 'EX0022' 'EX0023' 'EX0024'};
model = changeRxnBounds(model,AA_reactions,ones(1,length(AA_reactions))*-1,'l');
clear Unlimited_reactions AA_reactions;

%% Save as SBML file
writeSBML(model,'iBag597');
cd ../;
clear ans;