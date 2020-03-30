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
% save('kcats.mat','kcats');
% cd ../;

%Integrate enzymes in the model:
ecModel                 = readKcatDataiBag(model_data,kcats);
% [ecModel,modifications] = manualModifications(ecModel);
% 
% %Constrain model to batch conditions:
% sigma    = 0.5;      %Optimized for glucose
% Ptot     = 0.5;      %Assumed constant
% gR_exp   = 0.41;     %[g/gDw h] Max batch gRate on minimal glucose media
% c_source = 'D-glucose exchange (reversible)'; %Rxn name for the glucose uptake reaction
% cd ../limit_proteins
% [ecModel_batch,OptSigma] = getConstrainedModel(ecModel,c_source,sigma,Ptot,gR_exp,modifications,name);
% disp(['Sigma factor (fitted for growth on glucose): ' num2str(OptSigma)])

%% Save output models:
cd ModelFiles/;
ecModel = saveECmodel(ecModel,'COBRA','eciBag597','1.0');
writeCbModel(ecModel,'xls','eciBag597.xls');
writeCbModel(ecModel,'sbml','eciBag597.xml');
cd ../;
