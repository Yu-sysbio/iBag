%% Add GECKO and load model
addpath(genpath('../GECKO/')); %add to path
load('iBag597.mat');

%% Parameters
org_name = 'Bacillus coagulans';
sigma    = 0.5;
Ptot     = 0.35;
f        = 0.4;

%% Generate ecModel
%Convert model to RAVEN for easier visualization later on:
format short e
if isfield(model,'rules')
    model = ravenCobraWrapper(model);
end

%Remove blocked rxns + correct model.rev:
[model,name,version] = preprocessModel(model,'eciBag597','1.0');

%Retrieve kcats & MWs for each rxn in model:
model_data = getEnzymeCodesiBag(model);

kcats      = matchKcatsiBag(model_data,org_name);
cd GECKOfunction/;
save('kcats_iBag.mat','kcats');
cd ../;

%Modify low kcats:
% load('kcats_iBag.mat');
% kcats_tmp = kcats;
% kcats_tmp.forw.kcats(kcats_tmp.forw.kcats == 0) = nan;
% kcats_tmp.back.kcats(kcats_tmp.back.kcats == 0) = nan;
% low = quantile(reshape([kcats_tmp.forw.kcats;kcats_tmp.back.kcats],[],1),0.1,1);
% kcats.forw.kcats(kcats.forw.kcats > 0 & kcats.forw.kcats < low) = low;
% kcats.back.kcats(kcats.back.kcats > 0 & kcats.back.kcats < low) = low;
% clear kcats_tmp low;

%Integrate enzymes in the model:
ecModel = readKcatDataiBag(model_data,kcats);

%Constrain model to batch conditions:
ecModel = constrainEnzymesiBag(ecModel,Ptot,sigma,f);

%% Save output models:
cd ModelFiles/;
ecModel = saveECmodeliBag(ecModel,'eciBag597','1.0');
save('eciBag597.mat','ecModel');
cd ../;
