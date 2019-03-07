    %WorldCongressPlots
%% plot boxplot
f=figure;
filesCount=size(NormLHipRef,2);
GaitCycleCount=size(NormLHipRef{1},2);
totalGaitCycleCount=GaitCycleCount*filesCount;
titles={'Hip';'Knee';'Ankle'};
AngleLabel={'Abd - Add','Ext - Int','Ext - Flex'};
t=1:100;
ExperimentalCond={'Normal';'Bent Knees';'Tiptoes';'External Rotation'};
Comparisson={'Normal Gait (Left)'; 'Crouch Gait (Left)'; 'Toe Gait (Left)' };
Side={'Right'; 'Left'};
sup=suptitle(Comparisson{2});
axs=3;
set(sup,'FontSize', 25,'position',[0.475111441307578 -0.031786941580756 9.16025403784439])
red=[192 0  0]/255;
blue=[60 92 255]/255;
green=[108 206 66]/255;
pink=[177 47 206]/255;
burgundy=[163 32 67]/255;
orange=[221 114 26]/255;

%% Hip
xpos=0;
for a=1:axs
    s=subplot(3,3,a);
    set(s,'position', [0.07+xpos 0.7 0.21 0.18]);
    xpos=xpos+0.3;
    plot(t,0,'black','LineStyle','-') %Zero Line
    hold on
    plot(t,MeanRHipVic(:,a,1),'Color','k','Linewidth',2)
    plot(t,MeanRHipVic(:,a,2),'Color','k')
    plot(t,MeanRHipVic(:,a,3),'Color','k')
    plot(t,MeanRHipRef(:,a,1),'Color',gray,'Linewidth',2) 
    plot(t,MeanRHipRef(:,a,2),'Color',gray)
    plot(t,MeanRHipRef(:,a,3),'Color',gray)
%     plot(t,MeanLHipComp(:,a,1),'Color',orange,'Linewidth',2) 
%     plot(t,MeanLHipComp(:,a,2),'Color',orange)
%     plot(t,MeanLHipComp(:,a,3),'Color',orange)    
    %plot max and min limits
     tit=title(titles{1});
     angLab=ylabel(AngleLabel(a));
     gaitLab=xlabel('% Gait Cycle');

     set(tit,'FontSize',15)
     set(angLab,'FontSize',15)
     set(gaitLab,'FontSize',15)
     set(gca,'FontSize',12)
     axis([0 100 -30 30])
end

%% Knee
xpos=0;
for a=1:axs
    s=subplot(3,3,a+3);
    set(s,'position', [0.07+xpos 0.4 0.21 0.18]);
    xpos=xpos+0.3;
    plot(t,0,'black','LineStyle','-') %Zero Line
    hold on
    plot(t,MeanRKneeVic(:,a,1),'Color',blue,'Linewidth',2)
    plot(t,MeanRKneeVic(:,a,2),'Color',blue)
    plot(t,MeanRKneeVic(:,a,3),'Color',blue)
    plot(t,MeanRKneeRef(:,a,1),'Color',red,'Linewidth',2) 
    plot(t,MeanRKneeRef(:,a,2),'Color',red)
    plot(t,MeanRKneeRef(:,a,3),'Color',red)
%     plot(t,MeanLKneeComp(:,a,1),'Color',orange,'Linewidth',2) 
%     plot(t,MeanLKneeComp(:,a,2),'Color',orange)
%     plot(t,MeanLKneeComp(:,a,3),'Color',orange) 
%         plot(t,MeanLKneeCorr(:,a),'magenta','Linewidth',2)
    tit=title(titles{2});
     angLab=ylabel(AngleLabel(a));
     gaitLab=xlabel('% Gait Cycle');

     set(tit,'FontSize',15)
     set(angLab,'FontSize',15)
     set(gaitLab,'FontSize',15)
     set(gca,'FontSize',12)
     axis([0 100 -30 30])
     set(gca,'Xtick',0:20:100)
end
%% Ankle
xpos=0;
for a=1:axs
    s=subplot(3,3,a+6);
    set(s,'position', [0.07+xpos 0.1 0.21 0.18]);
    xpos=xpos+0.3;
    plot(t,0,'black','LineStyle','-') %Zero Line
    hold on
    plot(t,MeanRAnkleVic(:,a,1),'Color',blue,'Linewidth',2)
    plot(t,MeanRAnkleVic(:,a,2),'Color',blue)
    plot(t,MeanRAnkleVic(:,a,3),'Color',blue)
    plot(t,MeanRAnkleRef(:,a,1),'Color',red,'Linewidth',2) 
    plot(t,MeanRAnkleRef(:,a,2),'Color',red)
    plot(t,MeanRAnkleRef(:,a,3),'Color',red)
%     plot(t,MeanLAnkleComp(:,a,1),'Color',orange,'Linewidth',2) 
%     plot(t,MeanLAnkleComp(:,a,2),'Color',orange)
%     plot(t,MeanLAnkleComp(:,a,3),'Color',orange) 
%     plot(t,MeanLAnkleCorr(:,a),'magenta','Linewidth',2)
      tit=title(titles{3});
     angLab=ylabel(AngleLabel(a));
     gaitLab=xlabel('% Gait Cycle');

     set(tit,'FontSize',15)
     set(angLab,'FontSize',15)
     set(gaitLab,'FontSize',15)
     set(gca,'FontSize',12)
     axis([0 100 -30 30])
     set(gca,'Xtick',0:20:100)
end
%% Add Legend
text('String','    -  Vicon',...
    'Position',[110 80 0],...
    'FontSize',16,...
    'EdgeColor',[0 0 0],...
    'Color',blue,...
    'BackgroundColor',[1 1 1]);
text('String','    -  MVN',...
    'Position',[110.137457044674 56.9902912621359 17.3205080756888],...
    'FontSize',16,...
    'EdgeColor',[0 0 0],...
    'Color',red,...
    'BackgroundColor',[1 1 1]);
% text('String','    -  MVN PAC',...
%     'Position',[110 65 0],...
%     'FontSize',16,...
%     'EdgeColor',[0 0 0],...
%     'Color',pink,...
%     'BackgroundColor',[1 1 1]);

