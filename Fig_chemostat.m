[a, ~, ~] = xlsread('Fig_chemostat.xlsx');
[b, ~, ~] = xlsread('Fig_chemostat.xlsx','Sheet2');

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

mu_atp = b(1,:);
q_atp = b(2,:);

%% Without SD
figure('Name','1');
subplot(1,3,1);
hold on;
box on;
scatter(mu,qglc,30,'o','LineWidth',0.75,'MarkerEdgeColor',[55,126,184]/255);
scatter(mu,qlac,30,'o','LineWidth',0.75,'MarkerEdgeColor',[228,26,28]/255);
legend({'Glucose','Lactate'},'FontSize',8,'FontName','Helvetica','location','e');
set(gca,'FontSize',8,'FontName','Helvetica');
xlim([0 0.3]);
ylim([-15 20]);
ylabel(['Exchange flux',char(13,10)','(mmol/gCDW/h)'],'FontSize',8,'FontName','Helvetica');
xlabel('Specific growth rate (/h)','FontSize',8,'FontName','Helvetica');

subplot(1,3,2);
hold on;
box on;
scatter(mu,qace,30,'o','LineWidth',0.75,'MarkerEdgeColor',[77,175,74]/255);
scatter(mu,qcit,30,'o','LineWidth',0.75,'MarkerEdgeColor',[152,78,163]/255);
scatter(mu,qpyr,30,'o','LineWidth',0.75,'MarkerEdgeColor',[255,127,0]/255);
legend({'Acetate','Citrate','Pyruvate'},'FontSize',8,'FontName','Helvetica','location','nw');
set(gca,'FontSize',8,'FontName','Helvetica');
xlim([0 0.3]);
ylim([0 3]);
ylabel(['Exchange flux',char(13,10)','(mmol/gCDW/h)'],'FontSize',8,'FontName','Helvetica');
xlabel('Specific growth rate (/h)','FontSize',8,'FontName','Helvetica');

subplot(1,3,3);
hold on;
box on;
p = polyfit(mu_atp,q_atp,1);
x1 = linspace(min(mu_atp),max(mu_atp));
y1 = polyval(p,x1);
plot(x1,y1,'-','LineWidth',2,'Color',[223,194,125]/255);
scatter(mu_atp,q_atp,30,'o','LineWidth',0.75,'MarkerEdgeColor',[191,129,45]/255);
equation = ['y = ',num2str(round(p(1),2)),' x + ',num2str(round(p(2),2))];
r_sq = 'R^2 = 0.86';
text(0.09,12,equation,'FontSize',8,'FontName','Helvetica','Color',[84,48,5]/255);
text(0.09,9,r_sq,'FontSize',8,'FontName','Helvetica','Color',[84,48,5]/255);
set(gca,'FontSize',8,'FontName','Helvetica');
xlim([0 0.3]);
ylim([0 25]);
ylabel(['ATP production rate',char(13,10)','(mmol/gCDW/h)'],'FontSize',8,'FontName','Helvetica');
xlabel('Specific growth rate (/h)','FontSize',8,'FontName','Helvetica');


%% With SD
% figure('Name','2');
% subplot(2,1,1);
% hold on;
% box on;
% % scatter(mu,qglc,50,'o','LineWidth',0.75,'MarkerEdgeColor',[228,26,28]/255);
% % scatter(mu,qlac,50,'o','LineWidth',0.75,'MarkerEdgeColor',[55,126,184]/255);
% errorbar(mu,qglc,sdglc,'o','LineStyle','none','LineWidth',0.3,'CapSize',4);
% errorbar(mu,qlac,sdlac,'o','LineStyle','none','LineWidth',0.3,'CapSize',4);
% set(gca,'FontSize',8,'FontName','Helvetica');
% xlim([0 0.3]);
% ylim([-15 20]);
% ylabel('Flux (mmol/gCDW/h)','FontSize',8,'FontName','Helvetica');
% xlabel('Specific growth rate (/h)','FontSize',8,'FontName','Helvetica');
% 
% subplot(2,1,2);
% hold on;
% box on;
% errorbar(mu,qace,sdace,'o','LineStyle','none','LineWidth',0.3,'CapSize',4);
% errorbar(mu,qcit,sdcit,'o','LineStyle','none','LineWidth',0.3,'CapSize',4);
% errorbar(mu,qpyr,sdpyr,'o','LineStyle','none','LineWidth',0.3,'CapSize',4);
% set(gca,'FontSize',8,'FontName','Helvetica');
% xlim([0 0.3]);
% ylim([0 3]);
% ylabel('Flux (mmol/gCDW/h)','FontSize',8,'FontName','Helvetica');
% xlabel('Specific growth rate (/h)','FontSize',8,'FontName','Helvetica');

%% Flux change of each reaction
% [c, d, ~] = xlsread('Fig_chemostat.xlsx','Sheet4');
% ttl = d(2:19,3);
% totglc = c(19,1:10);
% mu = c(20,1:10);
% fba = c(1:18,1:10);
% minfva = c(1:18,11:20);
% maxfva = c(1:18,21:30);
% 
% figure('Name','3');
% color_line = [227,74,51]/255;
% for i = 1:18
%     ttl_i = ttl(i);
%     fba_i = fba(i,:);
%     minfva_i = minfva(i,:);
%     maxfva_i = maxfva(i,:);
%     
%     if fba_i(1) < 0
%         fba_tmp = abs(fba_i);
%         minfva_tmp = abs(maxfva_i);
%         maxfva_tmp = abs(minfva_i);
%     else
%         fba_tmp = fba_i;
%         minfva_tmp = minfva_i;
%         maxfva_tmp = maxfva_i;
%     end
%     
%     fba_tmp = fba_tmp./abs(totglc);
%     minfva_tmp = minfva_tmp./abs(totglc);
%     maxfva_tmp = maxfva_tmp./abs(totglc);
%     
% 	subplot(2,9,i);
%     hold on;
%     box on;
% %     plot(mu,fba_tmp,'-','LineWidth',0.75,'Color',color_line);
%     scatter(mu,fba_tmp,30,'o','LineWidth',0.75,'MarkerEdgeColor',color_line);
%     x = mu; y = fba_tmp; yu = maxfva_tmp; yl = minfva_tmp;
% %     plot(x,y,'-.','LineWidth',0.75,'Color',color_line);
%     fill([x fliplr(x)],[yu fliplr(yl)],color_line,'linestyle','none','FaceAlpha',0.3);
%     set(gca,'FontSize',8,'FontName','Helvetica');
%     xlim([0 0.3]);
%     title(ttl_i,'FontSize',8,'FontName','Helvetica');
% end


%% Flux change of each reaction
[c, d, ~] = xlsread('Fig_chemostat.xlsx','Sheet3');
ttl = d(2:13,3);
totglc = c(13,1:10);
mu = c(14,1:10);
fba = c(1:13,1:10);
minfva = c(1:13,11:20);
maxfva = c(1:13,21:30);

figure('Name','4');
color_line = [247,104,161]/255;
for i = 1:12
    ttl_i = ttl(i);
    ttl_tmp = strcat(num2str(i),'. ',ttl_i);
    fba_i = fba(i,:);
    minfva_i = minfva(i,:);
    maxfva_i = maxfva(i,:);
    
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
    xlim([0 0.3]);
    title(ttl_tmp,'FontSize',8,'FontName','Helvetica');
end













