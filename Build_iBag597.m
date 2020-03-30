%% Read Excel model
model = readCbModel('iBag597.xlsx');

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

%% Export model files
cd ModelFiles/;
save('iBag597.mat','model');
writeSBML(model,'iBag597');
cd ../;
clear ans;