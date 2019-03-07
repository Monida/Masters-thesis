%Plot Inside vs Outside
f=figure;
filesCount=size(NormLHipRef,2);
GaitCycleCount=size(NormLHipRef{1},2);
totalGaitCycleCount=GaitCycleCount*filesCount;
titles={'Hip';'Knee';'Ankle'};
AngleLabel={'Abd - Add','Ext - Int','Ext - Flex'};
t=1:100;
ExperimentalCond={'Normal';'Bent Knees';'Tiptoes';'External Rotation'};
Comparisson={'NPose + Normal Walking (Left)'; 'Bent Knees + Bent-Knees Walking (Left)'; 'Tiptoes + Tiptoe Walking (Left)';'Difference between PiG and MVN' };
Side={'Right'; 'Left'};
sup=suptitle(Comparisson{4});
axs=3;
set(sup,'FontSize', 25,'position',[0.404465592972182 -0.0504132231404959 9.16025403784439])
red=[192 0 0]/255;
green=[108 206 66]/255;
purple=[136 49 143]/255;
orange=[221 114 26]/255;
blue=[92 128 208]/255;
axesCount=3;


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
    
    plot(t,DIFFLHipVicRComp(:,a),'Color',green,'Linewidth',2)
    M=max(DIFFLHipVicRComp(:,a)); 
    m=min(DIFFLHipVicRComp(:,a)); 
    plot(t,M*ones(size(t)),'Color',green)
    plot(t,m*ones(size(t)),'Color',green)
    errorRangeVicRComp=M-m;
    eRVicRComp=text(90,10,num2str(errorRangeVicRComp,'%.2f'));
    
    plot(t,DIFFLHipVicRef(:,a),'Color',red,'Linewidth',2)
    M=max(DIFFLHipVicRef(:,a)); 
    m=min(DIFFLHipVicRef(:,a));  
    errorRangeVicRef=M-m;
    eRVicRef=text(90,10,num2str(errorRangeVicRef,'%.2f'),'Color',red);
    %plot max and min limits
    plot(t,M*ones(size(t)),'Color',red)
    plot(t,m*ones(size(t)),'Color',red)
    
    tit=title(titles{1});
    angLab=ylabel(AngleLabel(a));
    gaitLab=xlabel('% Gait Cycle');
    
    set(eRVicRComp,'Fontsize',13)
    set(eRVicRef,'Fontsize',13)
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
    
        plot(t,DIFFLKneeVicRComp(:,a),'Color',green,'Linewidth',2)
    M=max(DIFFLKneeVicRComp(:,a)); 
    m=min(DIFFLKneeVicRComp(:,a)); 
    plot(t,M*ones(size(t)),'Color',green)
    plot(t,m*ones(size(t)),'Color',green)
    errorRangeVicRComp=M-m;
    eRVicRComp=text(90,10,num2str(errorRangeVicRComp,'%.2f'));
    plot(t,DIFFLKneeVicRef(:,a),'Color',red,'Linewidth',2)
    M=max(DIFFLKneeVicRef(:,a)); 
    m=min(DIFFLKneeVicRef(:,a));  
    errorRangeVicRef=M-m;
    eRVicRef=text(90,10,num2str(errorRangeVicRef,'%.2f'),'Color',red);
    %plot max and min limits
    plot(t,M*ones(size(t)),'Color',red)
    plot(t,m*ones(size(t)),'Color',red)
    
        tit=title(titles{2});
    angLab=ylabel(AngleLabel(a));
    gaitLab=xlabel('% Gait Cycle');
    
        
        set(eRVicRComp,'Fontsize',13)
    set(eRVicRef,'Fontsize',13)
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
    
    plot(t,DIFFLAnkleVicRComp(:,a),'Color',green,'Linewidth',2)
    M=max(DIFFLAnkleVicRComp(:,a)); 
    m=min(DIFFLAnkleVicRComp(:,a)); 
    plot(t,M*ones(size(t)),'Color',green)
    plot(t,m*ones(size(t)),'Color',green)
    errorRangeVicRComp=M-m;
    eRVicRComp=text(90,10,num2str(errorRangeVicRComp,'%.2f'));
    plot(t,DIFFLAnkleVicRef(:,a),'Color',red,'Linewidth',2)
    M=max(DIFFLAnkleVicRef(:,a)); 
    m=min(DIFFLAnkleVicRef(:,a));  
    errorRangeVicRef=M-m;
    eRVicRef=text(90,10,num2str(errorRangeVicRef,'%.2f'),'Color',red);
    %plot max and min limits
    plot(t,M*ones(size(t)),'Color',red)
    plot(t,m*ones(size(t)),'Color',red)
    tit=title(titles{3});
    angLab=ylabel(AngleLabel(a));
    gaitLab=xlabel('% Gait Cycle');
    
    set(eRVicRComp,'Fontsize',13)
    set(eRVicRef,'Fontsize',13)
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
text('String','    Crouch Gait error',...
    'Position',[132 99 17],...
    'FontSize',16,...
    'EdgeColor',[0 0 0],...
    'Color',red,...
    'BackgroundColor',[1 1 1]);