% Figure S1

[a, ~, ~] = xlsread('Batch_data.xlsx');

x = a(:,1);
y_od = a(:,2);
y_glc = a(:,3);
y_lac = a(:,4);

figure('Name','1');

hold on;
yyaxis left;
plot(x,y_glc,'k-^','LineWidth',1,'MarkerSize',5);
plot(x,y_lac,'k-v','LineWidth',1,'MarkerSize',5);
set(gca,'FontSize',8,'FontName','Helvetica');
set(gca,'ycolor','k');
ylim([0 40]);
ylabel('Concentration (g/L)','FontSize',10,'FontName','Helvetica','Color','k');

yyaxis right;
plot(x,y_od,'r-o','LineWidth',1,'MarkerSize',5);
set(gca,'ycolor','r');
ylim([0 5.3]);
ylabel('OD620','FontSize',10,'FontName','Helvetica','Color','r');

legend({'Glucose',...
        'Lactate',...
        'OD620'},'FontSize',10,'FontName','Helvetica','location','e');
xlabel('Fermentation time (h)','FontSize',10,'FontName','Helvetica','Color','k');
set(gcf,'position',[0 0 350 220]);
set(gca,'position',[0.15 0.13 0.65 0.85]);



