%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [model,enzUsages,modifications] = constrainEnzymes(model,Ptot,sigma,f,GAM,pIDs,data,gRate,c_UptakeExp,c_source)
% Main function for overlaying proteomics data on an enzyme-constrained
% model. If chosen, also scales the protein content, optimizes GAM, and
% flexibilizes the proteomics data.
%
%   model           ecModel.
%   sigma           Average saturation factor.
%   Ptot            Total protein content [g/gDW].
% 	f				(Opt) Estimated mass fraction of enzymes in model.
%	GAM				(Opt) Growth-associated maintenance value. If not
%					provided, it will be fitted to chemostat data.
% 	pIDs			(Opt) Protein IDs from proteomics data.
%	data			(Opt) Protein abundances from proteomics data [mmol/gDW].
%   gRate           Minimum growth rate the model should grow at [1/h]. For
%                   finding the growth reaction, GECKO will choose the
%                   non-zero coeff in the objective function.
%   c_UptakeExp     (Opt) Experimentally measured glucose uptake rate 
%                   [mmol/gDW h].
%	c_source        (Opt) The name of the exchange reaction that supplies
%                   the model with carbon.
%
%   model           ecModel with calibrated enzyme usage upper bounds
%   enzUsages       Calculated enzyme usages after final calibration 
%                   (enzyme_i demand/enzyme_i upper bound)
%   modifications   Table with all the modified values 
%                   (Protein ID/old value/Flexibilized value)
%
% Benjamin J. Sanchez	2018-12-11
% Yu Chen               2020-03-30
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function model = constrainEnzymesiBag(model,Ptot,sigma,f)

%Constrain the rest of enzymes with the pool assumption:
if sum(strcmp(model.rxns,'prot_pool_exchange')) == 0
    model = constrainPooliBag(model,full(f*sigma*Ptot));
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function model = constrainPooliBag(model,UB)

%Find default compartment:
cytIndex = strcmpi(model.compNames,'cytoplasm');
if sum(cytIndex) == 1
    comp = model.comps{cytIndex};	%Protein pool in cytosol
else
    comp = model.comps{1};
end

%Define new rxns: For each enzyme, add a new rxn that draws enzyme from the
%enzyme pool (a new metabolite), and remove previous exchange rxn. The new
%rxns have the following stoichiometry (T is the enzyme pool):
% MW[i]*P[T] -> P[i]
for i = 1:length(model.enzymes)
    rxnToAdd.rxns         = {['draw_prot_' model.enzymes{i}]};
    rxnToAdd.rxnNames     = rxnToAdd.rxns;
    rxnToAdd.mets         = {'prot_pool' ['prot_' model.enzymes{i}]};
    rxnToAdd.stoichCoeffs = [-model.MWs(i) 1];
    rxnToAdd.lb           = 0; % ub is taken from model default, otherwise inf
    rxnToAdd.grRules      = model.enzGenes(i);
    model = addRxns(model,rxnToAdd,1,comp,true);
    model = removeReactions(model,{['prot_' model.enzymes{i} '_exchange']});
end

%Finally, constraint enzyme pool by fixed value:
rxnToAdd.rxns         = {'prot_pool_exchange'};
rxnToAdd.rxnNames     = rxnToAdd.rxns;
rxnToAdd.mets         = {'prot_pool'};
rxnToAdd.stoichCoeffs = 1;
rxnToAdd.lb           = 0;
rxnToAdd.ub           = UB;
rxnToAdd.grRules      = {''};
model = addRxns(model,rxnToAdd);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
