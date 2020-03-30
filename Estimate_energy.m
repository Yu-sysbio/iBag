model = xls2model('iBag604_energy.xlsx');
model = changeRxnBounds(model,'R0095',0,'b'); %block PFL reaction for aerobic condition

% EMP to lactate
model_1 = model;
model_1 = changeObjective(model_1,'EX0002');
sol_1 = optimizeCbModel(model_1,'max','one');
[minFlux_1, maxFlux_1, ~] = fastFVA(model_1);
minFlux_1(1)
maxFlux_1(1)

% EMP to acetate with ETC recycling NADH/NAD
model_2 = model;
model_2 = changeObjective(model_2,'EX0068');
model_2 = changeRxnBounds(model_2,{'R0083','R0035','R0037','R0025','R0104','R0108'},[0 0 0 0 0 0],'b'); % block 
sol_2 = optimizeCbModel(model_2,'max','one');
[minFlux_2, maxFlux_2, ~] = fastFVA(model_2);
minFlux_2(1)
maxFlux_2(1)
model_2 = changeRxnBounds(model_2,'EX0068',sol_2.f,'b'); % block
model_2 = changeObjective(model_2,'NGAM');
sol_2 = optimizeCbModel(model_2,'max','one');


% XPK to acetate with ETC recycling NADH/NAD
model_3 = model;
model_3 = changeObjective(model_3,'EX0002');
model_3 = changeRxnBounds(model_3,{'R0024','R0011','R0108','R0109','R0102'},[0 0 0 0 0],'b'); % block 
sol_3 = optimizeCbModel(model_3,'max','one');
[minFlux_3, maxFlux_3, ~] = fastFVA(model_3);
minFlux_3(1)
maxFlux_3(1)

% ETC + TCA