%Plot Inside vs Outside
figure
filesCount=size(NormLHipRef,2);
GaitCycleCount=size(NormLHipRef{1},2);
totalGaitCycleCount=GaitCycleCount*filesCount;
titles={'Hip';'Knee';'Ankle'};
AngleLabel={'Abd - Add','Ext - Int','Ext - Flex'};
t=1:100;
ExperimentalCond={'Normal';'Bent Knees';'Tiptoes';'External Rotation'};
Comparisson={'NPose + Normal Walking (Left)'; 'Bent Knees + Bent-Knees Walking (Left)'; 'Tiptoes + Tiptoe Walking (Left)' };Side={'Right'; 'Left'};
sup=suptitle(Comparisson{1});
axes=3;
set(sup,'FontSize', 25)
orange=[221 114 26]/255;
blue=[58 70 163]/255;
burgundy=[163 32 67]/255;
marron=[153 83 48]/255;
gray=[66 65 66]/255;
green=[96 114 32]/255;
purple=[0.400000005960464 0 0.800000011920929];
%% Hip

for a=1:axes
    subplot(3,3,a)
    plot(t,0,'black','LineStyle','-') %Zero Line
    hold on
        plot(t,MeanLHipVicR(:,a,1),'Color',blue,'Linewidth',2)
        plot(t,MeanLHipVicR(:,a,2),'Color',blue)
        plot(t,MeanLHipVicR(:,a,3),'Color',blue)
        plot(t,MeanLHipComp(:,a,1),'Color',orange,'Linewidth',2)
        plot(t,MeanLHipComp(:,a,2),'Color',orange)
        plot(t,MeanLHipComp(:,a,3),'Color',orange)
%         plot(t,DIFFLHipVicRComp(:,a),'Color',green,'Linewidth',2)
%         M=max(DIFFLHipVicRComp(:,a)); 
%         m=min(DIFFLHipVicRComp(:,a));   
%         %plot max and min limits
%         plot(t,M*ones(size(t)),'Color',green,'LineStyle','-')
%         plot(t,m*ones(size(t)),'Color',green,'LineStyle','-')

        tit=title(titles{1});
        angLab=ylabel(AngleLabel(a));
        gaitLab=xlabel('% Gait Cycle');
        
        set(tit,'FontSize',15)
        set(angLab,'FontSize',15)
        set(gaitLab,'FontSize',15)
        set(gca,'FontSize',12)
end
%% Knee
for a=1:axes
    subplot(3,3,a+3)
    plot(t,0,'black','LineStyle','-') %Zero Line
    hold on
        plot(t,MeanLKneeVicR(:,a,1),'Color',blue,'Linewidth',2)
        plot(t,MeanLKneeVicR(:,a,2),'Color',blue)
        plot(t,MeanLKneeVicR(:,a,3),'Color',blue)
        plot(t,MeanLKneeComp(:,a),'Color',orange,'Linewidth',2)
        plot(t,MeanLKneeComp(:,a,2),'Color',orange)
        plot(t,MeanLKneeComp(:,a,3),'Color',orange)
%         plot(t,DIFFLKneeVicRComp(:,a),'Color',green,'Linewidth',2)
%         M=max(DIFFLKneeVicRComp(:,a));
%         m=min(DIFFLKneeVicRComp(:,a));
%         %plot max and min limits
%         plot(t,M*ones(size(t)),'Color',green,'LineStyle','-')
%         plot(t,m*ones(size(t)),'Color',green,'LineStyle','-')
% 
        tit=title(titles{2});
        angLab=ylabel(AngleLabel(a));
        gaitLab=xlabel('% Gait Cycle');
        
        set(tit,'FontSize',15)
        set(angLab,'FontSize',15)
        set(gaitLab,'FontSize',15)
        set(gca,'FontSize',12)
end
%% Ankle
for a=1:axes
    subplot(3,3,a+6)
    plot(t,0,'black','LineStyle','-') %Zero Line
    hold on
    plot(t,MeanLAnkleVicR(:,a,1),'Color',blue,'Linewidth',2)
    plot(t,MeanLAnkleVicR(:,a,2),'Color',blue)
    plot(t,MeanLAnkleVicR(:,a,3),'Color',blue)
    plot(t,MeanLAnkleComp(:,a),'Color',orange,'Linewidth',2)
    plot(t,MeanLAnkleComp(:,a,2),'Color',orange)
    plot(t,MeanLAnkleComp(:,a,3),'Color',orange)
%     plot(t,DIFFLAnkleVicRComp(:,a),'Color',green,'Linewidth',2)
%     M=max(DIFFLAnkleVicRComp(:,a));
%     m=min(DIFFLAnkleVicRComp(:,a));
%     %plot max and min limits
%     plot(t,M*ones(size(t)),'Color',green,'LineStyle','-')
%     plot(t,m*ones(size(t)),'Color',green,'LineStyle','-')

    tit=title(titles{3});
    angLab=ylabel(AngleLabel(a));
    gaitLab=xlabel('% Gait Cycle');
    
    set(tit,'FontSize',15)
    set(angLab,'FontSize',15)
    set(gaitLab,'FontSize',15)
    set(gca,'FontSize',12)
end

%% Add Legend
text('String','    -  Vicon',...
    'Position',[110 80 0],...
    'FontSize',16,...
    'EdgeColor',[0 0 0],...
    'Color',blue,...
    'BackgroundColor',[1 1 1]);
text('String','    -  MVN',...
    'Position',[110 65 0],...
    'FontSize',16,...
    'EdgeColor',[0 0 0],...
    'Color',orange,...
    'BackgroundColor',[1 1 1]);

% text('String','    -  Difference',...
%     'Position',[110 50 0],...
%     'FontSize',16,...
%     'EdgeColor',[0 0 0],...
%     'Color',green,...
%     'BackgroundColor',[1 1 1]);

