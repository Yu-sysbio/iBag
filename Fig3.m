% Fig 3
[a, b, ~] = xlsread('Fig3.xlsx');

AA_name = b(2:22,1);
AA_aver = a(1:21,1);
AA_sd = a(1:21,2);

CS_name = b(23:end,1);
CS_aver = a(22:end,1);
CS_sd = a(22:end,2);

figure('Name','1');
hold on;
x1 = categorical(AA_name);
x1 = reordercats(x1,AA_name);
z1 = bar(x1,AA_aver,0.5);
errorbar(AA_aver,AA_sd,'k','Marker','none','LineStyle','none','LineWidth',0.3,'CapSize',4);
set(gca,'FontSize',8,'FontName','Helvetica');
set(gca,'ycolor','k');
z1.EdgeColor = 'k';
z1.FaceColor = [228,26,28]/255;
z1.FaceAlpha = 0.2;
xtb = get(gca,'XTickLabel');
xt = get(gca,'XTick');
yt = get(gca,'YTick');
xtextp = xt;
ytextp = yt(1)*ones(1,length(xt));
text(xtextp,ytextp-0.03,xtb,'HorizontalAlignment','right','rotation',90,'FontSize',8,'FontName','Helvetica');
set(gca,'xticklabel','');
ylabel('Relative OD','FontSize',8,'FontName','Helvetica','Color','k');
set(gcf,'position',[20 0 450 170]);
set(gca,'position',[0.1 0.4 0.63 0.56]);

figure('Name','2');
hold on;
x2 = categorical(CS_name);
x2 = reordercats(x2,CS_name);
z2 = bar(x2,CS_aver,0.5);
errorbar(CS_aver,CS_sd,'k','Marker','none','LineStyle','none','LineWidth',0.3,'CapSize',4);
set(gca,'FontSize',8,'FontName','Helvetica');
set(gca,'ycolor','k');
z2.EdgeColor = 'k';
z2.FaceColor = [255,127,0]/255;
z2.FaceAlpha = 0.2;
xtb = get(gca,'XTickLabel');
xt = get(gca,'XTick');
yt = get(gca,'YTick');
xtextp = xt;
ytextp = yt(1)*ones(1,length(xt));
text(xtextp,ytextp-0.03,xtb,'HorizontalAlignment','right','rotation',90,'FontSize',8,'FontName','Helvetica');
set(gca,'xticklabel','');
ylabel('Relative OD','FontSize',8,'FontName','Helvetica','Color','k');
set(gcf,'position',[600 0 450 170]);
set(gca,'position',[0.1 0.4 0.27 0.56]);






