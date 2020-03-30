[a1, b1, ~] = xlsread('Fig_ph.xlsx','Sheet1');

metid = b1(1,3:8);
expid = b1(2:5,1);

ph60_clr = [50,136,189]/255;
ph55_clr = [213,62,79]/255;

figure('Name','1');
box on;
hold on;
x1 = categorical(metid);
x1 = reordercats(x1,metid);
z1 = bar(x1,a1(:,2:7)',0.5);
set(gca,'FontSize',8,'FontName','Helvetica');
z1(1).EdgeColor = ph60_clr;
z1(1).FaceColor = ph60_clr;
z1(1).FaceAlpha = 0.5;
z1(2).EdgeColor = ph60_clr;
z1(2).FaceColor = ph60_clr;
z1(2).FaceAlpha = 0.5;
z1(3).EdgeColor = ph55_clr;
z1(3).FaceColor = ph55_clr;
z1(3).FaceAlpha = 0.5;
z1(4).EdgeColor = ph55_clr;
z1(4).FaceColor = ph55_clr;
z1(4).FaceAlpha = 0.5;
ylim([-12 18]);
legend(expid,'FontSize',8,'FontName','Helvetica','location','e');
ylabel('Exchange flux (mmol/gCDW/h)','FontSize',8,'FontName','Helvetica','Color','k');
set(gca,'xcolor','k');
set(gcf,'position',[0 0 250 190]);
set(gca,'position',[0.15 0.18 0.43 0.8]);


figure('Name','2');
[a2, b2, ~] = xlsread('Fig_ph.xlsx','Sheet2');
metid = b2(1,2:11);
box on;
hold on;
x1 = categorical(metid);
x1 = reordercats(x1,metid);
z1 = bar(x1,a2',0.5);
set(gca,'FontSize',8,'FontName','Helvetica');
z1(1).EdgeColor = ph60_clr;
z1(1).FaceColor = ph60_clr;
z1(1).FaceAlpha = 0.5;
z1(2).EdgeColor = ph60_clr;
z1(2).FaceColor = ph60_clr;
z1(2).FaceAlpha = 0.5;
z1(3).EdgeColor = ph55_clr;
z1(3).FaceColor = ph55_clr;
z1(3).FaceAlpha = 0.5;
z1(4).EdgeColor = ph55_clr;
z1(4).FaceColor = ph55_clr;
z1(4).FaceAlpha = 0.5;
ylim([-0.46 0.15]);
ylabel('Exchange flux (mmol/gCDW/h)','FontSize',8,'FontName','Helvetica','Color','k');
set(gca,'xcolor','k');
set(gcf,'position',[300 0 300 190]);
set(gca,'position',[0.15 0.18 0.6 0.8]);


figure('Name','3');
[a3, b3, ~] = xlsread('Fig_ph.xlsx','Sheet3');
box on;
hold on;
z1 = bar([a3'; 0 0 0 0],0.5);
set(gca,'FontSize',8,'FontName','Helvetica');
z1(1).EdgeColor = ph60_clr;
z1(1).FaceColor = ph60_clr;
z1(1).FaceAlpha = 0.5;
z1(2).EdgeColor = ph60_clr;
z1(2).FaceColor = ph60_clr;
z1(2).FaceAlpha = 0.5;
z1(3).EdgeColor = ph55_clr;
z1(3).FaceColor = ph55_clr;
z1(3).FaceAlpha = 0.5;
z1(4).EdgeColor = ph55_clr;
z1(4).FaceColor = ph55_clr;
z1(4).FaceAlpha = 0.5;
ylabel('ATP production rate (mmol/gCDW/h)','FontSize',8,'FontName','Helvetica','Color','k');
set(gca,'xcolor','k');
set(gcf,'position',[700 0 300 190]);
set(gca,'position',[0.15 0.18 0.13 0.8]);


