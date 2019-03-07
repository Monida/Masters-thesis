%Plot Inside vs Outside
figure
filesCount=size(NormLHipRef,2);
GaitCycleCount=size(NormLHipRef{1},2);
totalGaitCycleCount=GaitCycleCount*filesCount;
titles={'Hip';'Knee';'Ankle'};
AngleLabel={'Abd - Add','Ext - Int','Ext - Flex'};
t=1:100;
ExperimentalCond={'Normal';'Bent Knees';'Tiptoes';'External Rotation'};
Comparisson={'NPose + Normal Walking (Left)'; 'Bent Knees + Bent-Knees Walking (Left)'; 'Tiptoes + Tiptoe Walking (Left)';'Difference between PiG and MVN (DIFF)' };
Side={'Right'; 'Left'};
sup=suptitle(Comparisson{4});
axs=3;
set(sup,'FontSize', 25,'position',[0.404465592972182 -0.0504132231404959 9.16025403784439])
red=[192 0 0]/255;
green=[108 206 66]/255;
purple=[136 49 143]/255;
orange=[221 114 26]/255;
blue=[92 128 208]/255;

%% Prepare the Range of Error the text
% hipText=text(90,max(a),num2str(max-min));
%% Hip
xpos=0;
for a=1:axs
    s=subplot(3,3,a);
    set(s,'position',[0.06+xpos 0.7 0.2 0.17]);
    xpos=xpos+0.25;
    plot(t,0,'black','LineStyle','-') %Zero Line
    hold on
    
    plot(t,DIFFRHipVicRComp(:,a),'Color',green,'Linewidth',2)
    M=max(DIFFRHipVicRComp(:,a)); 
    m=min(DIFFRHipVicRComp(:,a)); 
    plot(t,M*ones(size(t)),'Color',green)
    plot(t,m*ones(size(t)),'Color',green)
    errorRangeVicRComp=M-m;
    eRVicRComp=text(90,10,num2str(errorRangeVicRComp,'%.2f'));
    
    plot(t,DIFFRHipVicCorr(:,a),'Color','black','Linewidth',2)
    M=max(DIFFRHipVicCorr(:,a)); 
    m=min(DIFFRHipVicCorr(:,a));  
    errorRangeVicCorr=M-m;
    eRVicCorr=text(90,10,num2str(errorRangeVicCorr,'%.2f'),'Color','black');
    %plot max and min limits
    plot(t,M*ones(size(t)),'Color','black')
    plot(t,m*ones(size(t)),'Color','black')
    
    tit=title(titles{1});
    angLab=ylabel(AngleLabel(a));
    gaitLab=xlabel('% Gait Cycle');
    
    set(eRVicRComp,'Fontsize',13)
    set(eRVicCorr,'Fontsize',13)
    set(tit,'FontSize',15)
    set(angLab,'FontSize',15)
    set(gaitLab,'FontSize',15)
    set(gca,'FontSize',12)
    axis([0 120 -30 30])
    set(gca,'Xtick',0:20:100)
end


%% Knee
xpos=0;
for a=1:axs
    s=subplot(3,3,a+3);
    set(s,'position',[0.06+xpos 0.4 0.2 0.17]);
    xpos=xpos+0.25;
    plot(t,0,'black','LineStyle','-') %Zero Line
    hold on
    
        plot(t,DIFFRKneeVicRComp(:,a),'Color',green,'Linewidth',2)
    M=max(DIFFRKneeVicRComp(:,a)); 
    m=min(DIFFRKneeVicRComp(:,a)); 
    plot(t,M*ones(size(t)),'Color',green)
    plot(t,m*ones(size(t)),'Color',green)
    errorRangeVicRComp=M-m;
    eRVicRComp=text(90,10,num2str(errorRangeVicRComp,'%.2f'));
    plot(t,DIFFRKneeVicCorr(:,a),'Color','black','Linewidth',2)
    M=max(DIFFRKneeVicCorr(:,a)); 
    m=min(DIFFRKneeVicCorr(:,a));  
    errorRangeVicCorr=M-m;
    eRVicCorr=text(90,10,num2str(errorRangeVicCorr,'%.2f'),'Color','black');
    %plot max and min limits
    plot(t,M*ones(size(t)),'Color','black')
    plot(t,m*ones(size(t)),'Color','black')
    
        tit=title(titles{2});
    angLab=ylabel(AngleLabel(a));
    gaitLab=xlabel('% Gait Cycle');
    
        
        set(eRVicRComp,'Fontsize',13)
    set(eRVicCorr,'Fontsize',13)
    set(tit,'FontSize',15)
    set(angLab,'FontSize',15)
    set(gaitLab,'FontSize',15)
    set(gca,'FontSize',12)
    axis([0 120 -30 30])
    set(gca,'Xtick',0:20:100)
end
%% Ankle
xpos=0;
for a=1:axs
    s=subplot(3,3,a+6);
    set(s,'position',[0.06+xpos 0.1 0.2 0.17]);
    xpos=xpos+0.25;
    plot(t,0,'black','LineStyle','-') %Zero Line
    hold on
    
    plot(t,DIFFRAnkleVicRComp(:,a),'Color',green,'Linewidth',2)
    M=max(DIFFRAnkleVicRComp(:,a)); 
    m=min(DIFFRAnkleVicRComp(:,a)); 
    plot(t,M*ones(size(t)),'Color',green)
    plot(t,m*ones(size(t)),'Color',green)
    errorRangeVicRComp=M-m;
    eRVicRComp=text(90,10,num2str(errorRangeVicRComp,'%.2f'));
    plot(t,DIFFRAnkleVicCorr(:,a),'Color','black','Linewidth',2)
    M=max(DIFFRAnkleVicCorr(:,a)); 
    m=min(DIFFRAnkleVicCorr(:,a));  
    errorRangeVicCorr=M-m;
    eRVicCorr=text(90,10,num2str(errorRangeVicCorr,'%.2f'),'Color','black');
    %plot max and min limits
    plot(t,M*ones(size(t)),'Color','black')
    plot(t,m*ones(size(t)),'Color','black')
    tit=title(titles{3});
    angLab=ylabel(AngleLabel(a));
    gaitLab=xlabel('% Gait Cycle');
    
    set(eRVicRComp,'Fontsize',13)
    set(eRVicCorr,'Fontsize',13)
    set(tit,'FontSize',15)
    set(angLab,'FontSize',15)
    set(gaitLab,'FontSize',15)
    set(gca,'FontSize',12)
    axis([0 120 -30 30])
    set(gca,'Xtick',0:20:100)
end
%% Add Legend
text('String','    Baseline error',...
    'Position',[132 126 17],...
    'FontSize',16,...
    'EdgeColor',[0 0 0],...
    'Color',green,...
    'BackgroundColor',[1 1 1]);
text('String','    Toe Gait error (OC)',...
    'Position',[132 99 17],...
    'FontSize',16,...
    'EdgeColor',[0 0 0],...
    'Color','black',...
    'BackgroundColor',[1 1 1]);