    %WorldCongressPlots

%% plot boxplot
figure
filesCount=size(NormLHipRef,2);
GaitCycleCount=size(NormLHipRef{1},2);
totalGaitCycleCount=GaitCycleCount*filesCount;
titles={'Hip';'Knee';'Ankle'};
AngleLabel={'Abd - Add','Ext - Int','Ext - Flex'};
t=1:100;
ExperimentalCond={'Normal';'Bent Knees';'Tiptoes';'External Rotation'};
Comparisson={'NPose + Normal Walking (Left)'; 'Bent Knees + Bent-Knees Walking (Left)'; 'Tiptoes + Tiptoe Walking (Left)' };
Side={'Right'; 'Left'};
sup=suptitle(Comparisson{2});
axes=3;
set(sup,'FontSize', 25)
orange=[221 114 26]/255;
blue=[60 92 255]/255;
green=[108 206 66]/255;
pink=[177 47 206]/255;
burgundy=[163 32 67]/255;

%% Hip

for a=1:axes
    subplot(3,3,a)
    plot(t,0,'black','LineStyle','-') %Zero Line
    hold on
    plot(t,MeanLHipVic(:,a,1),'Color',blue,'Linewidth',2)
    plot(t,MeanLHipVic(:,a,2),'Color',blue)
    plot(t,MeanLHipVic(:,a,3),'Color',blue)
    plot(t,MeanLHipCorr(:,a,1),'Color',pink,'Linewidth',2) 
    plot(t,MeanLHipCorr(:,a,2),'Color',pink)
    plot(t,MeanLHipCorr(:,a,3),'Color',pink)
    plot(t,MeanLHipComp(:,a,1),'Color',orange,'Linewidth',2) 
    plot(t,MeanLHipComp(:,a,2),'Color',orange)
    plot(t,MeanLHipComp(:,a,3),'Color',orange)    
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
for a=1:axes
    subplot(3,3,a+3)
    plot(t,0,'black','LineStyle','-') %Zero Line
    hold on
    plot(t,MeanLKneeVic(:,a,1),'Color',blue,'Linewidth',2)
    plot(t,MeanLKneeVic(:,a,2),'Color',blue)
    plot(t,MeanLKneeVic(:,a,3),'Color',blue)
    plot(t,MeanLKneeCorr(:,a,1),'Color',pink,'Linewidth',2) 
    plot(t,MeanLKneeCorr(:,a,2),'Color',pink)
    plot(t,MeanLKneeCorr(:,a,3),'Color',pink)
    plot(t,MeanLKneeComp(:,a,1),'Color',orange,'Linewidth',2) 
    plot(t,MeanLKneeComp(:,a,2),'Color',orange)
    plot(t,MeanLKneeComp(:,a,3),'Color',orange) 
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
for a=1:axes
    subplot(3,3,a+6)
    plot(t,0,'black','LineStyle','-') %Zero Line
    hold on
    plot(t,MeanLAnkleVic(:,a,1),'Color',blue,'Linewidth',2)
    plot(t,MeanLAnkleVic(:,a,2),'Color',blue)
    plot(t,MeanLAnkleVic(:,a,3),'Color',blue)
    plot(t,MeanLAnkleCorr(:,a,1),'Color',pink,'Linewidth',2) 
    plot(t,MeanLAnkleCorr(:,a,2),'Color',pink)
    plot(t,MeanLAnkleCorr(:,a,3),'Color',pink)
    plot(t,MeanLAnkleComp(:,a,1),'Color',orange,'Linewidth',2) 
    plot(t,MeanLAnkleComp(:,a,2),'Color',orange)
    plot(t,MeanLAnkleComp(:,a,3),'Color',orange) 
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
text('String','    -  MVN OC',...
    'Position',[110 65 0],...
    'FontSize',16,...
    'EdgeColor',[0 0 0],...
    'Color',orange,...
    'BackgroundColor',[1 1 1]);
text('String','    -  MVN PAC',...
    'Position',[110 65 0],...
    'FontSize',16,...
    'EdgeColor',[0 0 0],...
    'Color',pink,...
    'BackgroundColor',[1 1 1]);

