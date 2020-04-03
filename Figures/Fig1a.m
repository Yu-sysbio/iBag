% Figure 1
[a, b, ~] = xlsread('Fig1.xlsx');
Y_axis = b(2:end,1);
x = a;
% Y_axis = cellfun(@(x) x(4:end),Y_axis,'UniformOutput',false);
y = categorical(Y_axis);
z = barh(y,x,0.5);
z.EdgeColor = 'k';
z.FaceColor = [222,235,247]/255;
% z.FaceAlpha = 0.5;

set(gca,'FontSize',8,'FontName','Helvetica');
set(gca,'ycolor','k');
xlabel('Number of reactions','FontSize',8,'FontName','Helvetica','Color','k');
box off;
set(gcf,'position',[20 0 450 170]);
set(gca,'position',[0.5 0.2 0.45 0.56]);