% Figure 5


%% bar charts
[a1, b1, ~] = xlsread('Chemostat_data.xlsx','Data4Fig5A');

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
[a2, b2, ~] = xlsread('Chemostat_data.xlsx','Data4Fig5B');
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
set(gca,'position',[0.15 0.18 0.65 0.8]);

figure('Name','3');
load('res_qatp_ph.mat');
box on;
hold on;
z1 = bar([res_qatp_ph; 0 0 0 0],0.5);
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

%% plot sampling
a = importdata('rxnlist.txt');
a = split(a);
rxn_no = a(:,1);
rxn_id = a(:,2);
rxn_name = a(:,3);

load('samples_ph060.mat');
load('samples_ph055.mat');
load('iBag597.mat');

samples_1 = samples_ph060;
samples_2 = samples_ph055;
samples_1(abs(samples_1)<1e-6)=0;
samples_2(abs(samples_2)<1e-6)=0;
samples_1 = round(samples_1,5);
samples_2 = round(samples_2,5);

sampledRxns = rxn_id;
RxnIDs = rxn_name;

rxnsIdx = findRxnIDs(model, sampledRxns);

nbins = 100;
ph60_clr = [50,136,189]/255;
ph55_clr = [213,62,79]/255;

pvalues = ones(length(sampledRxns),1);

figure('Name','4');
for i = 1:length(sampledRxns)
    tmp = 1;
    if i == 10
        tmp = -1;
    end
    subplot(2,6,i);
    p = ranksum(samples_1(rxnsIdx(i), :),samples_2(rxnsIdx(i), :));
    pvalues(i,1) = p;
    hold on;
    [y1, x1] = hist(samples_1(rxnsIdx(i), :)*tmp, nbins);
    [y2, x2] = hist(samples_2(rxnsIdx(i), :)*tmp, nbins);
    plot(x1, y1, 'Color', ph60_clr);
    plot(x2, y2, 'Color', ph55_clr);
    f1 = fill([x1,fliplr(x1)],[y1,zeros(1,length(x1))],ph60_clr);
    set(f1,'edgealpha',0,'facealpha',0.5);
    f2 = fill([x2,fliplr(x2)],[y2,zeros(1,length(x2))],ph55_clr);
    set(f2,'edgealpha',0,'facealpha',0.5);
    title(sprintf('%s', strcat(num2str(i),'. ',RxnIDs{i})));
    set(gca,'FontSize',8,'FontName','Helvetica');
    if contains(RxnIDs{i},'LDH') || contains(RxnIDs{i},'PGI')
        ylim([0 800]);
    else
        ylim([0 400]);
    end
    hold off;
end
set(gcf,'position',[500 500 450 150]);
