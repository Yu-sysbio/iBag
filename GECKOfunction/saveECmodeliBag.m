%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% model = saveECmodel(model,toolbox,name,version)
%
% Benjamin J. Sanchez. Last edited: 2018-10-25
% Yu Chen              Last edited: 2020-03-30
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function model = saveECmodeliBag(model,name,version)

%Model ID
model.id = [name '_v' version];

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

%Transform model back to COBRA for saving purposes:
model_cobra = ravenCobraWrapper(model);
%Remove fields from COBRA model (temporal):
model_cobra = takeOutField(model_cobra,'metCharges');
model_cobra = takeOutField(model_cobra,'metChEBIID');
model_cobra = takeOutField(model_cobra,'metKEGGID');
model_cobra = takeOutField(model_cobra,'metSBOTerms');
model_cobra = takeOutField(model_cobra,'rxnConfidenceScores');
model_cobra = takeOutField(model_cobra,'rxnECNumbers');
model_cobra = takeOutField(model_cobra,'rxnKEGGID');
model_cobra = takeOutField(model_cobra,'rxnReferences');
model_cobra.subSystems = cell(size(model_cobra.rxns));
model_cobra = takeOutField(model_cobra,'rxnSBOTerms');
%Save model as sbml and text:
writeCbModel(model_cobra,'sbml',[name '.xml']);
writeCbModel(model_cobra,'text',[name '.txt']);
writeCbModel(model_cobra,'xls',[name '.xls']);

%Convert notation "e-005" to "e-05 " in stoich. coeffs. to avoid
%inconsistencies between Windows and MAC:
copyfile([name '.xml'],'backup.xml')
fin  = fopen('backup.xml', 'r');
fout = fopen([name '.xml'], 'w');
still_reading = true;
while still_reading
    inline = fgets(fin);
    if ~ischar(inline)
        still_reading = false;
    else
        if ~isempty(regexp(inline,'-00[0-9]','once'))
            inline = strrep(inline,'-00','-0');
        elseif ~isempty(regexp(inline,'-01[0-9]','once'))
            inline = strrep(inline,'-01','-1');
        end
        fwrite(fout, inline);
    end
end
fclose('all');
delete('backup.xml');

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function model = takeOutField(model,field)

if isfield(model,field)
    model = rmfield(model,field);
end


end