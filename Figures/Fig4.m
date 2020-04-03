% Figure 4

%% Without SD
[a, ~, ~] = xlsread('Chemostat_data.xlsx','Data4Fig4');
mu = a(:,1);
qglc = a(:,2);
qlac = a(:,3);
qace = a(:,4);
qcit = a(:,5);
qpyr = a(:,6);

sdglc = a(:,7);
sdlac = a(:,8);
sdace = a(:,9);
sdcit = a(:,10);
sdpyr = a(:,11);

load('res_qatp.mat');
mu_atp = res_qatp(1,:);
q_atp = res_qatp(2,:);

figure('Name','1');
subplot(1,3,1);
hold on;
box on;
scatter(mu,qglc,30,'o','LineWidth',0.75,'MarkerEdgeColor',[55,126,184]/255);
scatter(mu,qlac,30,'o','LineWidth',0.75,'MarkerEdgeColor',[228,26,28]/255);
legend({'Glucose','Lactate'},'FontSize',7,'FontName','Helvetica','location','e');
set(gca,'FontSize',7,'FontName','Helvetica');
xlim([0 0.3]);
ylim([-15 20]);
ylabel(['Exchange flux',char(13,10)','(mmol/gCDW/h)'],'FontSize',7,'FontName','Helvetica');
xlabel('Specific growth rate (/h)','FontSize',7,'FontName','Helvetica');

subplot(1,3,2);
hold on;
box on;
scatter(mu,qace,30,'o','LineWidth',0.75,'MarkerEdgeColor',[77,175,74]/255);
scatter(mu,qcit,30,'o','LineWidth',0.75,'MarkerEdgeColor',[152,78,163]/255);
scatter(mu,qpyr,30,'o','LineWidth',0.75,'MarkerEdgeColor',[255,127,0]/255);
legend({'Acetate','Citrate','Pyruvate'},'FontSize',7,'FontName','Helvetica','location','nw');
set(gca,'FontSize',7,'FontName','Helvetica');
xlim([0 0.3]);
ylim([0 2.8]);
ylabel(['Exchange flux',char(13,10)','(mmol/gCDW/h)'],'FontSize',7,'FontName','Helvetica');
xlabel('Specific growth rate (/h)','FontSize',7,'FontName','Helvetica');

subplot(1,3,3);
hold on;
box on;
p = polyfit(mu_atp,q_atp,1);
x1 = linspace(min(mu_atp),max(mu_atp));
y1 = polyval(p,x1);
plot(x1,y1,'-','LineWidth',2,'Color',[223,194,125]/255);
scatter(mu_atp,q_atp,30,'o','LineWidth',0.75,'MarkerEdgeColor',[191,129,45]/255);
equation = ['y = ',num2str(round(p(1),2)),' x + ',num2str(round(p(2),2))];
[RHO,~] = corr([mu_atp;q_atp]');
r_sq = ['R^2 = ',num2str(round(RHO(1,2)^2,2))];
text(0.07,10,equation,'FontSize',7,'FontName','Helvetica','Color',[84,48,5]/255);
text(0.07,7,r_sq,'FontSize',7,'FontName','Helvetica','Color',[84,48,5]/255);
set(gca,'FontSize',7,'FontName','Helvetica');
xlim([0 0.3]);
ylim([0 28]);
ylabel(['ATP production rate',char(13,10)','(mmol/gCDW/h)'],'FontSize',7,'FontName','Helvetica');
xlabel('Specific growth rate (/h)','FontSize',7,'FontName','Helvetica');

set(gcf,'position',[300 0 410 100]);

%% With SD
% figure('Name','2');
% subplot(1,3,1);
% hold on;
% box on;
% % scatter(mu,qglc,50,'o','LineWidth',0.75,'MarkerEdgeColor',[228,26,28]/255);
% % scatter(mu,qlac,50,'o','LineWidth',0.75,'MarkerEdgeColor',[55,126,184]/255);
% errorbar(mu,qglc,sdglc,'o','LineStyle','none','MarkerSize',5,'LineWidth',0.3,'CapSize',4,'Color',[55,126,184]/255);
% errorbar(mu,qlac,sdlac,'o','LineStyle','none','MarkerSize',5,'LineWidth',0.3,'CapSize',4,'Color',[228,26,28]/255);
% legend({'Glucose','Lactate'},'FontSize',7,'FontName','Helvetica','location','e');
% set(gca,'FontSize',7,'FontName','Helvetica');
% xlim([0 0.3]);
% ylim([-15 20]);
% ylabel('Flux (mmol/gCDW/h)','FontSize',7,'FontName','Helvetica');
% xlabel('Specific growth rate (/h)','FontSize',7,'FontName','Helvetica');
% 
% subplot(1,3,2);
% hold on;
% box on;
% errorbar(mu,qace,sdace,'o','LineStyle','none','MarkerSize',5,'LineWidth',0.3,'CapSize',4,'Color',[77,175,74]/255);
% errorbar(mu,qcit,sdcit,'o','LineStyle','none','MarkerSize',5,'LineWidth',0.3,'CapSize',4,'Color',[152,78,163]/255);
% errorbar(mu,qpyr,sdpyr,'o','LineStyle','none','MarkerSize',5,'LineWidth',0.3,'CapSize',4,'Color',[255,127,0]/255);
% legend({'Acetate','Citrate','Pyruvate'},'FontSize',7,'FontName','Helvetica','location','nw');
% set(gca,'FontSize',7,'FontName','Helvetica');
% xlim([0 0.3]);
% ylim([0 3]);
% ylabel('Flux (mmol/gCDW/h)','FontSize',7,'FontName','Helvetica');
% xlabel('Specific growth rate (/h)','FontSize',7,'FontName','Helvetica');
% 
% subplot(1,3,3);
% hold on;
% box on;
% p = polyfit(mu_atp,q_atp,1);
% x1 = linspace(min(mu_atp),max(mu_atp));
% y1 = polyval(p,x1);
% plot(x1,y1,'-','LineWidth',2,'Color',[223,194,125]/255);
% scatter(mu_atp,q_atp,30,'o','LineWidth',0.75,'MarkerEdgeColor',[191,129,45]/255);
% equation = ['y = ',num2str(round(p(1),2)),' x + ',num2str(round(p(2),2))];
% [RHO,~] = corr([mu_atp;q_atp]');
% r_sq = ['R^2 = ',num2str(round(RHO(1,2)^2,2))];
% text(0.07,10,equation,'FontSize',7,'FontName','Helvetica','Color',[84,48,5]/255);
% text(0.07,7,r_sq,'FontSize',7,'FontName','Helvetica','Color',[84,48,5]/255);
% set(gca,'FontSize',7,'FontName','Helvetica');
% xlim([0 0.3]);
% ylim([0 28]);
% ylabel(['ATP production rate',char(13,10)','(mmol/gCDW/h)'],'FontSize',7,'FontName','Helvetica');
% xlabel('Specific growth rate (/h)','FontSize',7,'FontName','Helvetica');
% 
% set(gcf,'position',[300 0 410 100]);

%% Flux change of each reaction
load('res_chem_fluxes.mat');
load('res_chem_FVA.mat');
load('iBag597.mat');

a = importdata('rxnlist.txt');
a = split(a);
rxn_no = a(:,1);
rxn_id = a(:,2);
rxn_name = a(:,3);

totglc = -res_chem_fluxes(ismember(model.rxns,'EX0001'),:);
mu = res_chem_fluxes(ismember(model.rxns,'EXBiomass'),:);

figure('Name','4');
color_line = [247,104,161]/255;
for i = 1:length(rxn_name)
    ttl_i = rxn_name(i);
    ttl_tmp = strcat(num2str(i),'. ',ttl_i);
    fba_i = res_chem_fluxes(ismember(model.rxns,rxn_id(i)),:);
    minfva_i = res_chem_FVA(ismember(model.rxns,rxn_id(i)),1:2:end-1);
    maxfva_i = res_chem_FVA(ismember(model.rxns,rxn_id(i)),2:2:end);
    
    if fba_i(1) < 0
        fba_tmp = abs(fba_i);
        minfva_tmp = abs(maxfva_i);
        maxfva_tmp = abs(minfva_i);
    else
        fba_tmp = fba_i;
        minfva_tmp = minfva_i;
        maxfva_tmp = maxfva_i;
    end
    
    fba_tmp = fba_tmp./abs(totglc)*100;
    minfva_tmp = minfva_tmp./abs(totglc)*100;
    maxfva_tmp = maxfva_tmp./abs(totglc)*100;
    
	subplot(2,6,i);
    hold on;
    box on;
%     scatter(mu,fba_tmp,10,'o','MarkerEdgeColor',color_line);
%     x = mu; y = fba_tmp; yu = maxfva_tmp; yl = minfva_tmp;
%     fill([x fliplr(x)],[yu fliplr(yl)],color_line,'linestyle','none','FaceAlpha',0.3);
    errorbar(mu,fba_tmp,abs(fba_tmp-minfva_tmp),abs(fba_tmp-maxfva_tmp),'x','Color',color_line,'linestyle','none','MarkerSize',5,'LineWidth',1,'CapSize',3);
    set(gca,'FontSize',6,'FontName','Helvetica');
    if contains(ttl_tmp,'LDH')
        ylim([135 170]);
    elseif contains(ttl_tmp,'FBA')
        ylim([0 100]);
    elseif contains(ttl_tmp,'ETC')
        ylim([15 50]);
    elseif contains(ttl_tmp,'PGI')
        ylim([65 100]);
    elseif contains(ttl_tmp,'PYK')
        ylim([55 90]);
    else
        ylim([-5 30]);
    end
    xlim([0 0.3]);
    title(ttl_tmp,'FontSize',8,'FontName','Helvetica');
end
set(gcf,'position',[500 300 450 150]);
