% Figure 2
% Require spider_plot (https://github.com/NewGuy012/spider_plot).

%% add path and load data
addpath(genpath('../../spider_plot/')); %add to path

[a1, b1, ~] = xlsread('Fig2.xlsx','Biomass_comparison');
[a2, b2, ~] = xlsread('Fig2.xlsx','AA_comparison');
[a3, b3, ~] = xlsread('Fig2.xlsx','Biomass_batch');

%% Biomass_comparison
figure('Name','1');
spider_plot(a1','AxesLabels', b1(3:end,1)',...
    'AxesInterval', 5,...
    'AxesPrecision', 0,...
    'AxesDisplay', 'one',...
    'AxesLimits', [zeros(1,length(a1)); ones(1,length(a1))*50],...
    'LineWidth', 1.5,...
    'Color', [228,26,28;55,126,184;77,175,74]/255,...
    'Marker', 'none',...
    'AxesFontSize', 6,...
    'LabelFontSize', 7);
legend(b1(2,2:4), 'Location', 'southoutside');
set(gcf,'position',[200 400 300 200]);

%% AA_comparison
figure('Name','2');
spider_plot(a2','AxesLabels', b2(3:end,1)',...
    'AxesInterval', 3,...
    'AxesPrecision', 0,...
    'AxesDisplay', 'one',...
    'AxesLimits', [zeros(1,length(a2)); ones(1,length(a2))*15],...
    'LineWidth', 1.5,...
    'Color', [228,26,28;55,126,184;77,175,74]/255,...
    'Marker', 'none',...
    'AxesFontSize', 6,...
    'LabelFontSize', 7);
legend(b2(2,2:4), 'Location', 'southoutside');
set(gcf,'position',[500 400 300 200]);

%% Biomass_batch
res_mean = a3(:,1:4);
res_error = a3(:,5:8);

figure('Name','3');
hold on;
b = bar(res_mean,'stacked');

b(1).FaceColor = [215,48,39]/255;
b(2).FaceColor = [244,109,67]/255;
b(3).FaceColor = [253,174,97]/255;
b(4).FaceColor = [254,224,139]/255;

errorbar(cumsum(res_mean')',res_error,'k','Marker','none','LineStyle','none','LineWidth',0.5,'CapSize',5);

set(gca,'FontSize',7,'FontName','Helvetica');
legend(b3(2,2:5),'FontSize',7,'FontName','Helvetica','location','n');
legend('boxoff');
xticks(1:1:5);
xticklabels(b3(3:7,1));
xlim([0.3 5.7]);
ylim([0 1]);
ylabel('Content (g/gCDW)','FontSize',8,'FontName','Helvetica');
xlabel('Fermentation time','FontSize',8,'FontName','Helvetica');

set(gcf,'position',[0 0 150 150]);
set(gca,'position',[0.2 0.17 0.6 0.7]);





