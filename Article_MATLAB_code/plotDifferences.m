%Plot Inside vs Outside
figure
filesCount=size(NormLHipRef,2);
GaitCycleCount=size(NormLHipRef{1},2);
totalGaitCycleCount=GaitCycleCount*filesCount;
titles={'Hip';'Knee';'Ankle'};
AngleLabel={'Abd - Add','Ext - Int','Ext - Flex'};
t=1:100;
ExperimentalCond={'Normal';'Bent Knees';'Tiptoes';'External Rotation'};
Comparisson={'NPose + Normal Walking (Left)'; 'Bent Knees + Bent-Knees Walking (Left)'; 'Tiptoes + Tiptoe Walking (Left)';'Difference between Vicon and MVN' };
Side={'Right'; 'Left'};
sup=suptitle(Comparisson{4});
axes=3;
set(sup,'FontSize', 25)
orange=[221 114 26]/255;
blue=[60 92 255]/255;
burgundy=[163 32 67]/255;
marron=[153 83 48]/255;
gray=[66 65 66]/255;
green=[108 206 66]/255;

%% Prepare the Range of Error the text
% hipText=text(90,max(a),num2str(max-min));
%% Hip

for a=1:axes
    subplot(3,3,a)
    plot(t,0,'black','LineStyle','-') %Zero Line
    hold on
    
    plot(t,DIFFLHipVicRef(:,a),'Color',green,'Linewidth',2)
    M=max(DIFFLHipVicRef(:,a)); 
    m=min(DIFFLHipVicRef(:,a)); 
    plot(t,M*ones(size(t)),'Color',green)
    plot(t,m*ones(size(t)),'Color',green)
    errorRangeVicRef=M-m;
    eRVicRef=text(90,10,num2str(errorRangeVicRef,'%.2f'));
%     plot(t,DIFFLHipVicCorr(:,a),'Color',burgundy,'Linewidth',2)
%     M=max(DIFFLHipVicCorr(:,a)); 
%     m=min(DIFFLHipVicCorr(:,a));  
%     errorRangeVicRef=M-m;
%     eRVicRef=text(90,10,num2str(errorRangeVicRef,'%.2f'),'Color',burgundy);
%     %plot max and min limits
%     plot(t,M*ones(size(t)),'Color',burgundy)
%     plot(t,m*ones(size(t)),'Color',burgundy)
    
    tit=title(titles{1});
    angLab=ylabel(AngleLabel(a));
    gaitLab=xlabel('% Gait Cycle');
    
%     set(eRVicComp,'Fontsize',13)
    set(eRVicRef,'Fontsize',13)
    set(tit,'FontSize',15)
    set(angLab,'FontSize',15)
    set(gaitLab,'FontSize',15)
    set(gca,'FontSize',12)
    axis([0 120 -30 30])
    set(gca,'Xtick',0:20:100)
end


%% Knee
for a=1:axes
    subplot(3,3,a+3)
    plot(t,0,'black','LineStyle','-') %Zero Line
    hold on
    
        plot(t,DIFFLKneeVicRef(:,a),'Color',green,'Linewidth',2)
    M=max(DIFFLKneeVicRef(:,a)); 
    m=min(DIFFLKneeVicRef(:,a)); 
    plot(t,M*ones(size(t)),'Color',green)
    plot(t,m*ones(size(t)),'Color',green)
    errorRangeVicRef=M-m;
    eRVicRef=text(90,10,num2str(errorRangeVicRef,'%.2f'));
%     plot(t,DIFFLKneeVicCorr(:,a),'Color',burgundy,'Linewidth',2)
%     M=max(DIFFLKneeVicCorr(:,a)); 
%     m=min(DIFFLKneeVicCorr(:,a));  
%     errorRangeVicRef=M-m;
%     eRVicRef=text(90,10,num2str(errorRangeVicRef,'%.2f'),'Color',burgundy);
%     %plot max and min limits
%     plot(t,M*ones(size(t)),'Color',burgundy)
%     plot(t,m*ones(size(t)),'Color',burgundy)
    
        tit=title(titles{2});
    angLab=ylabel(AngleLabel(a));
    gaitLab=xlabel('% Gait Cycle');
    
        
        set(eRVicRef,'Fontsize',13)
    set(eRVicRef,'Fontsize',13)
    set(tit,'FontSize',15)
    set(angLab,'FontSize',15)
    set(gaitLab,'FontSize',15)
    set(gca,'FontSize',12)
    axis([0 120 -30 30])
    set(gca,'Xtick',0:20:100)
end
%% Ankle
for a=1:axes
    subplot(3,3,a+6)
    plot(t,0,'black','LineStyle','-') %Zero Line
    hold on
    
    plot(t,DIFFLAnkleVicRef(:,a),'Color',green,'Linewidth',2)
    M=max(DIFFLAnkleVicRef(:,a)); 
    m=min(DIFFLAnkleVicRef(:,a)); 
    plot(t,M*ones(size(t)),'Color',green)
    plot(t,m*ones(size(t)),'Color',green)
    errorRangeVicRef=M-m;
    eRVicRef=text(90,10,num2str(errorRangeVicRef,'%.2f'));
%     plot(t,DIFFLAnkleVicCorr(:,a),'Color',burgundy,'Linewidth',2)
%     M=max(DIFFLAnkleVicCorr(:,a)); 
%     m=min(DIFFLAnkleVicCorr(:,a));  
%     errorRangeVicRef=M-m;
%     eRVicRef=text(90,10,num2str(errorRangeVicRef,'%.2f'),'Color',burgundy);
%     %plot max and min limits
%     plot(t,M*ones(size(t)),'Color',burgundy)
%     plot(t,m*ones(size(t)),'Color',burgundy)
    tit=title(titles{3});
    angLab=ylabel(AngleLabel(a));
    gaitLab=xlabel('% Gait Cycle');
    
    set(eRVicRef,'Fontsize',13)
    set(eRVicRef,'Fontsize',13)
    set(tit,'FontSize',15)
    set(angLab,'FontSize',15)
    set(gaitLab,'FontSize',15)
    set(gca,'FontSize',12)
    axis([0 120 -30 30])
    set(gca,'Xtick',0:20:100)
end
%% Add Legend
text('String','    Difference NPose + NW',...
    'Position',[110 80 0],...
    'FontSize',16,...
    'EdgeColor',[0 0 0],...
    'Color',green,...
    'BackgroundColor',[1 1 1]);
% text('String','    Difference BK + BKW',...
%     'Position',[110 80 0],...
%     'FontSize',16,...
%     'EdgeColor',[0 0 0],...
%     'Color',burgundy,...
%     'BackgroundColor',[1 1 1]);