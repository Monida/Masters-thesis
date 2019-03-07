%Plot scatter plot of DIFFs (Vicon-MVN)
rightVic=xlsread('C:\Users\Monica\Dropbox\Thesis\Results\Summary Results.xlsx','DIFFStatic','B30:AK32');
leftVic=xlsread('C:\Users\Monica\Dropbox\Thesis\Results\Summary Results.xlsx','DIFFStatic','B38:AK40');
rightRef=xlsread('C:\Users\Monica\Dropbox\Thesis\Results\Summary Results.xlsx','DIFFStatic','B47:AK49');
leftRef=xlsread('C:\Users\Monica\Dropbox\Thesis\Results\Summary Results.xlsx','DIFFStatic','B55:AK57');
sup=suptitle('Difference between PiG and MVN (DIFF_S) (Left)');
set(sup,'FontSize', 25)
axes=3;
AngleLabel={'Hip (degrees)';'Knee (degrees)';'Ankle (degrees)'};
titles={'Abd - Add','Ext - Int','Ext - Flex'};
colIdx={1:4,5:8,9:12,13:16,17:20,21:24,25:28,29:32,33:36};
trialCount=3;
participantCount=4;
red=[192 0 0]/255;
green=[108 206 67]/255;

%RHip
for a=1:axes
    subplot(3,3,a)
    for t=1:trialCount
        plot(1:participantCount,leftRef(t,colIdx{a}),'+','MarkerSize',10,'MarkerEdgeColor',red,'LineWidth',2)
        hold on
        plot(1:participantCount,leftVic(t,colIdx{a}),'+','MarkerSize',10,'MarkerEdgeColor',green,'LineWidth',2)
        tit=title(titles{a});
        if a==1
            angLab=ylabel(AngleLabel(1));
            set(angLab,'FontSize',15) 
        end
                xlim([0 5])
                ylim([-30 30])
                set(gca,'XTick',[0 1 2 3 4])
                set(gca,'XTickLabel',{'','1','2','3','4',''})
                  
                set(gca,'FontSize',12)
                set(tit,'FontSize',15)
    end
end

%RKnee
for a=1:axes
    subplot(3,3,a+3)
    for t=1:trialCount
        plot(1:participantCount,leftRef(t,colIdx{a+3}),'+','MarkerSize',10,'MarkerEdgeColor',red,'LineWidth',2)
        hold on
        plot(1:participantCount,leftVic(t,colIdx{a+3}),'+','MarkerSize',10,'MarkerEdgeColor',green,'LineWidth',2)
        if a==1
            angLab=ylabel(AngleLabel(2));
            set(angLab,'FontSize',15) 
        end
                xlim([0 5])
                ylim([-30 30])
                set(gca,'XTick',[0 1 2 3 4])
                set(gca,'XTickLabel',{'','1','2','3','4',''})
                set(gca,'FontSize',12)
    end
end

%RAnkle
for a=1:axes
    subplot(3,3,a+6)
    for t=1:trialCount
        plot(1:participantCount,leftRef(t,colIdx{a+6}),'+','MarkerSize',10,'MarkerEdgeColor',red,'LineWidth',2)
        hold on
        plot(1:participantCount,leftVic(t,colIdx{a+6}),'+','MarkerSize',10,'MarkerEdgeColor',green,'LineWidth',2)
        if a==1
            angLab=ylabel(AngleLabel(3));
            set(angLab,'FontSize',15) 
        end
                xlim([0 5])
                ylim([-30 30])
                set(gca,'XTick',[0 1 2 3 4])
                set(gca,'XTickLabel',{'','1','2','3','4',''})
                gaitLab=xlabel('Participant ID');
                set(gaitLab,'FontSize',15)
                set(gca,'FontSize',12)
    end
end