%Plot the summary of all the CMC values of all participants for
%Uncorrected OC and PAC
sup=suptitle('CMC values');
set(sup,'FontSize', 25)
AngleLabel={'Hip','Knee','Ankle'};
jointCount=3;

RHip=xlsread('C:\Users\Monica\Dropbox\Thesis\Results\Summary Results.xlsx','CMC','B6:J9');
RKnee=xlsread('C:\Users\Monica\Dropbox\Thesis\Results\Summary Results.xlsx','CMC','B15:J18');
RAnkle=xlsread('C:\Users\Monica\Dropbox\Thesis\Results\Summary Results.xlsx','CMC','B24:J27');

LHip=xlsread('C:\Users\Monica\Dropbox\Thesis\Results\Summary Results.xlsx','CMC','K6:S9');
LKnee=xlsread('C:\Users\Monica\Dropbox\Thesis\Results\Summary Results.xlsx','CMC','K15:S18');
LAnkle=xlsread('C:\Users\Monica\Dropbox\Thesis\Results\Summary Results.xlsx','CMC','K24:S27');

xLabels={'AA','IE','FE','AA','IE','FE','AA','IE','FE'};
t=0:10;
conditions={'Uncorrected','MVN OC', 'MVN PAC'};
conditionsIdx={1:3,4:6,7:9};
conditionCount=3;

burgundy=[163 32 67]/255;
green=[108 206 66]/255;
pink=[177 47 206]/255;
orange=[221 114 26]/255;
blue=[60 92 255]/255;
colors={burgundy orange pink};

%% Plot Right
%RHip
subplot(3,2,1)

plot(-1:9,ones(1,11),'k')
hold on
plot(-1:9,-1*ones(1,11),'k')
for c=1:conditionCount
    plot(t(conditionsIdx{c}),RHip(1:4,conditionsIdx{c})','+','MarkerEdgeColor',colors{c},'MarkerSize',10,'LineWidth',2)    
end

xlim ([-1 9])
ylim ([-1.1 1.1])
set(gca,'XTick',[-1 0 1 2 3 4 5 6 7 8 9])
set(gca,'XTickLabel',{'','AA','IE','FE','AA','IE','FE','AA','IE','FE',''})

tit=title('Right');
angLab=ylabel(AngleLabel(1));
set(tit,'FontSize',15)
set(angLab,'FontSize',14)    
set(gca,'FontSize',12)

%RKnee
subplot(3,2,3)

plot(-1:9,ones(1,11),'k')
hold on
plot(-1:9,-1*ones(1,11),'k')
for c=1:conditionCount
    plot(t(conditionsIdx{c}),RKnee(1:4,conditionsIdx{c})','+','MarkerEdgeColor',colors{c},'MarkerSize',10,'LineWidth',2)    
end

xlim ([-1 9])
ylim ([-1.1 1.1])
set(gca,'XTick',[-1 0 1 2 3 4 5 6 7 8 9])
set(gca,'XTickLabel',{'','AA','IE','FE','AA','IE','FE','AA','IE','FE',''})

angLab=ylabel(AngleLabel(2));
set(angLab,'FontSize',14)    
set(gca,'FontSize',12)

%RAnkle
subplot(3,2,5)

plot(-1:9,ones(1,11),'k')
hold on
plot(-1:9,-1*ones(1,11),'k')
for c=1:conditionCount
    plot(t(conditionsIdx{c}),RAnkle(1:4,conditionsIdx{c})','+','MarkerEdgeColor',colors{c},'MarkerSize',10,'LineWidth',2)    
end

xlim ([-1 9])
ylim ([-1.1 1.1])
set(gca,'XTick',[-1 0 1 2 3 4 5 6 7 8 9])
set(gca,'XTickLabel',{'','AA','IE','FE','AA','IE','FE','AA','IE','FE',''})

angLab=ylabel(AngleLabel(3));
set(angLab,'FontSize',14)    
set(gca,'FontSize',12)

%LHip
subplot(3,2,2)

plot(-1:9,ones(1,11),'k')
hold on
plot(-1:9,-1*ones(1,11),'k')
for c=1:conditionCount
    plot(t(conditionsIdx{c}),LHip(1:4,conditionsIdx{c})','+','MarkerEdgeColor',colors{c},'MarkerSize',10,'LineWidth',2)    
end

xlim ([-1 9])
ylim ([-1.1 1.1])
set(gca,'XTick',[-1 0 1 2 3 4 5 6 7 8 9])
set(gca,'XTickLabel',{'','AA','IE','FE','AA','IE','FE','AA','IE','FE',''})

tit=title('Left');
angLab=ylabel(AngleLabel(1));
set(tit,'FontSize',15)
set(angLab,'FontSize',14)    
set(gca,'FontSize',12)

%LKnee
subplot(3,2,4)

plot(-1:9,ones(1,11),'k')
hold on
plot(-1:9,-1*ones(1,11),'k')
for c=1:conditionCount
    plot(t(conditionsIdx{c}),LKnee(1:4,conditionsIdx{c})','+','MarkerEdgeColor',colors{c},'MarkerSize',10,'LineWidth',2)    
end

xlim ([-1 9])
ylim ([-1.1 1.1])
set(gca,'XTick',[-1 0 1 2 3 4 5 6 7 8 9])
set(gca,'XTickLabel',{'','AA','IE','FE','AA','IE','FE','AA','IE','FE',''})

angLab=ylabel(AngleLabel(2));
set(angLab,'FontSize',14)    
set(gca,'FontSize',12)

%LAnkle
subplot(3,2,6)

plot(-1:9,ones(1,11),'k')
hold on
plot(-1:9,-1*ones(1,11),'k')
for c=1:conditionCount
    plot(t(conditionsIdx{c}),LAnkle(1:4,conditionsIdx{c})','+','MarkerEdgeColor',colors{c},'MarkerSize',10,'LineWidth',2)    
end

xlim ([-1 9])
ylim ([-1.1 1.1])
set(gca,'XTick',[-1 0 1 2 3 4 5 6 7 8 9])
set(gca,'XTickLabel',{'','AA','IE','FE','AA','IE','FE','AA','IE','FE',''})

angLab=ylabel(AngleLabel(3));
set(angLab,'FontSize',14)    
set(gca,'FontSize',12)

%% Legends
text('String','    -  Crouch gait (Uncorrected)',...
    'Position',[110 80 0],...
    'FontSize',16,...
    'EdgeColor',[0 0 0],...
    'Color',burgundy,...
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


