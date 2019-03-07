%Plot scatter plot of DIFFs (Vicon-MVN)
right=xlsread('C:\Users\Monica\Dropbox\Thesis\Results\Summary Results.xlsx','DIFFStatic','B5:AB7');
left=xlsread('C:\Users\Monica\Dropbox\Thesis\Results\Summary Results.xlsx','DIFFStatic','B13:AB15');
sup=suptitle('Difference between Vicon and MVN during calibratio posture');
set(sup,'FontSize', 25)
joints=3;
titles={'Hip';'Knee';'Ankle'};
AngleLabel={'Abd - Add','Ext - Int','Ext - Flex'};
colIdx={1:3,4:6,7:9,10:12,13:15,16:18,19:21,22:24,25:27};
trialCount=3;



%Hip
for j=1:joints
    subplot(3,1,j)
    for t=1:trialCount
        plot(1:3,right(t,colIdx{j}),'o','MarkerSize',5,'MarkerFaceColor',[0,0,0])
          
        hold on
        tit=title(titles{1});
            angLab=ylabel(AngleLabel(j));
                xlim([0 4])
                ylim([-30 30])
                set(gca,'XTick',[0 1 2 3 4])
                set(gca,'XTickLabel',{'','1','2','3'})
                gaitLab=xlabel('Participant ID');
                set(angLab,'FontSize',15)   
                set(gaitLab,'FontSize',15)
                
                set(gca,'FontSize',12)
                set(tit,'FontSize',15)
    end
end

%Knee
for a=1:axes
    subplot(3,3,a+3)
    for t=1:trialCount
        plot(1:3,right(t,colIdx{a+3}),'o','MarkerSize',5,'MarkerFaceColor',[0,0,0])
        hold on
        tit=title(titles{2});
            angLab=ylabel(AngleLabel(a));
                xlim([0 4])
                ylim([-30 30])
                set(gca,'XTick',[0 1 2 3 4])
                set(gca,'XTickLabel',{'','1','2','3'})
                gaitLab=xlabel('Participant ID');
                set(angLab,'FontSize',15)   
                set(gaitLab,'FontSize',15)
                
                set(gca,'FontSize',12)
                set(tit,'FontSize',15)
    end
end

%Ankle
for a=1:axes
    subplot(3,3,a+6)
    for t=1:trialCount
        plot(1:3,right(t,colIdx{a+6}),'o','MarkerSize',5,'MarkerFaceColor',[0,0,0])
        hold on
        tit=title(titles{3});
            angLab=ylabel(AngleLabel(a));
                xlim([0 4])
                ylim([-30 30])
                set(gca,'XTick',[0 1 2 3 4])
                set(gca,'XTickLabel',{'','1','2','3'})
                gaitLab=xlabel('Participant ID');
                set(angLab,'FontSize',15)   
                set(gaitLab,'FontSize',15)
                
                set(gca,'FontSize',12)
                set(tit,'FontSize',15)
    end
end