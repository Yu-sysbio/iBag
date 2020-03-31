%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% model = saveECmodel(model,toolbox,name,version)
%
% Benjamin J. Sanchez. Last edited: 2018-10-25
% Yu Chen              Last edited: 2020-03-30
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function model = saveECmodeliBag(model,name,version)

%Define file path for storage:
struct_name = 'ecModel';
if endsWith(name,'_batch')
    struct_name = [struct_name '_batch'];
    root_name   = name(1:strfind(name,'_batch')-1);
else
    root_name = name;
end

%Model description:
model.description = [struct_name ' of ' lower(root_name(3)) root_name(4:end)];
model.id          = [name '_v' version];

%Format S matrix: avoid long decimals
for i = 1:length(model.mets)
    for j = 1:length(model.rxns)
        if model.S(i,j) ~= 0
            orderMagn    = ceil(log10(abs(model.S(i,j))));
            model.S(i,j) = round(model.S(i,j),6-orderMagn);
        end
    end
end

%Remove model.fields (added by COBRA functions)
if isfield(model,'rules')
    model = rmfield(model,'rules');
end

end