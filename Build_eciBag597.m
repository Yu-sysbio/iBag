%% Add GECKO and load model
addpath(genpath('../GECKO/')); %add to path
load('iBag597.mat');

%% Generate ecModel

%Provide your organism scientific name
org_name = 'Bacillus coagulans';

%Convert model to RAVEN for easier visualization later on:
format short e
if isfield(model,'rules')
    model = ravenCobraWrapper(model);
end

%Remove blocked rxns + correct model.rev:
[model,name,version] = preprocessModel(model,'eciBag597','1.0');

%Retrieve kcats & MWs for each rxn in model:
model_data = getEnzymeCodesiBag(model);
% kcats      = matchKcatsiBag(model_data,org_name);
% cd GECKOfunction/;
% save('kcats_iBag.mat','kcats');
% cd ../;

%Integrate enzymes in the model:
load('kcats_iBag.mat');
ecModel = readKcatDataiBag(model_data,kcats);

%Constrain model to batch conditions:
sigma    = 0.5;
Ptot     = 0.5;
f        = 0.5;
ecModel = constrainEnzymesiBag(ecModel,Ptot,sigma,f);

%% Save output models:

ecModel = saveECmodeliBag(ecModel,'eciBag597','1.0');
cd ModelFiles/;
writeCbModel(ecModel,'xls','eciBag597.xls');
save('eciBag597.mat','ecModel');
cd ../;
