% Figure 1

%% A

figure('Name','1');
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
set(gcf,'position',[20 0 300 170]);
set(gca,'position',[0.55 0.2 0.37 0.56]);

%% B

figure('Name','2');
c = categorical({'consistency','annotation met','annotation rxn','annotation gene','annotation sbo'});
z = barh(c,[98.93,54.27,54.74,33.33,77.1],0.5);
z.EdgeColor = 'k';
z.FaceColor = [229,245,224]/255;
% z.FaceAlpha = 0.5;
set(gca,'FontSize',8,'FontName','Helvetica');
set(gca,'ycolor','k');
text(35,1,'Total score: 80%','FontSize',7,'FontName','Helvetica','Color','k');
xlabel('Memote score (%)','FontSize',8,'FontName','Helvetica','Color','k');
box off;
set(gcf,'position',[400 0 170 170]);
set(gca,'position',[0.45 0.2 0.5 0.56]);
