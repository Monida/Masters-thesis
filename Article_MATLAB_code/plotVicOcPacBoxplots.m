%Plot boxplots of means
% Plot boxplots on comparison plots

%Define the position for the boxplots
boxplot11=[0.232886904761905 0.683087027914614 0.0355308830087619 0.17219875002596];
boxplot12=[0.513392857142857 0.683087027914614 0.0355308830087619 0.17219875002596];
boxplot13=[0.794642857142857 0.683087027914614 0.0355308830087619 0.17219875002596];
boxplot21=[0.233630952380952 0.38423645320197 0.0355308830087619 0.17219875002596];
boxplot22=[0.514136904761905 0.38423645320197 0.0355308830087619 0.17219875002596];
boxplot23=[0.794642857142857 0.384451496279458 0.0355308830087619 0.17219875002596];
boxplot31=[0.232142857142857 0.0836908179013772 0.0355308830087619 0.17219875002596];
boxplot32=[0.514136904761905 0.083743842364532 0.0355308830087619 0.17219875002596];
boxplot33=[0.794642857142857 0.083743842364532 0.0355308830087619 0.17219875002596];

burgundy=[163 32 67]/255;
green=[108 206 66]/255;
pink=[177 47 206]/255;
orange=[221 114 26]/255;
axesCount=3;

posArray={boxplot11; boxplot12; boxplot13; boxplot21; boxplot22; boxplot23; boxplot31; boxplot32; boxplot33};

titles={'Hip';'Knee';'Ankle'};
AngleLabel={'Abd - Add','Ext - Int','Ext - Flex'};
sup=suptitle('Comparison of error means');
set(sup,'FontSize', 25)

%% Plot Boxplots for Hip
for a=1:axesCount 
   subplot(3,3,a)
A=[DIFFLHipVicRComp(:,a) DIFFLHipVicRef(:,a) DIFFLHipVicComp(:,a) DIFFLHipVicCorr(:,a)];
meanVicRComp=mean(DIFFLHipVicRComp(:,a));
meanVicRef=mean(DIFFLHipVicRef(:,a));
meanVicComp=mean(DIFFLHipVicComp(:,a));
meanVicCorr=mean(DIFFLHipVicCorr(:,a));
means={num2str(meanVicRComp,'.%2f'),num2str(meanVicRef,'%.2f'), num2str(meanVicComp,'%.2f'), num2str(meanVicCorr,'%.2f')};
axis auto
boxplot(A,'labels',means);
set(gca,'XTick',-30:30)
colors = {green blue orange pink};
l = findall(gca,'type','line'); % get all lines in the box plot
for boxnum=1:4
    for j=1:length(l);
        xdata = get(l(j),'xdata'); % get their x values
        if all(abs(xdata-boxnum)<.5) % find ones in the desired group
            set(l(j))
            set(l(j), 'color', colors{boxnum});
        end
    end
end

tit=title(titles{1});
angLab=ylabel(AngleLabel(a));
set(tit,'FontSize',14)
set(angLab,'FontSize',14)    
set(gca,'FontSize',12)
end


%% Plot Boxplots for Knee
for a=1:axesCount
   subplot(3,3,a+3)
A=[DIFFLKneeVicRComp(:,a) DIFFLKneeVicRef(:,a) DIFFLKneeVicComp(:,a) DIFFLKneeVicCorr(:,a)];
meanVicRComp=mean(DIFFLKneeVicRComp(:,a));
meanVicRef=mean(DIFFLKneeVicRef(:,a));
meanVicComp=mean(DIFFLKneeVicComp(:,a));
meanVicCorr=mean(DIFFLKneeVicCorr(:,a));
means={num2str(meanVicRComp,'%.2f'),num2str(meanVicRef,'%.2f'), num2str(meanVicComp,'%.2f'), num2str(meanVicCorr,'%.2f')};

boxplot(A,'labels',means);
set(gca,'XTick',-30:30)

colors = {green blue orange pink};
l = findall(gca,'type','line'); % get all lines in the box plot
for boxnum=1:4
    for j=1:length(l);
        xdata = get(l(j),'xdata'); % get their x values
        if all(abs(xdata-boxnum)<.5) % find ones in the desired group
            set(l(j))
            set(l(j), 'color', colors{boxnum});
        end
    end
end

tit=title(titles{2});
angLab=ylabel(AngleLabel(a));
set(tit,'FontSize',14)
set(angLab,'FontSize',14)    
set(gca,'FontSize',12)

end
%% Plot Boxplots for Ankle
for a=1:axesCount
    subplot(3,3,a+6)
A=[DIFFLAnkleVicRComp(:,a) DIFFLAnkleVicRef(:,a) DIFFLAnkleVicComp(:,a) DIFFLAnkleVicCorr(:,a)];
meanVicRComp=mean(DIFFLAnkleVicRComp(:,a));
meanVicRef=mean(DIFFLAnkleVicRef(:,a));
meanVicComp=mean(DIFFLAnkleVicComp(:,a));
meanVicCorr=mean(DIFFLAnkleVicCorr(:,a));
means={num2str(meanVicRComp,'%.2f'),num2str(meanVicRef,'%.2f'), num2str(meanVicComp,'%.2f'), num2str(meanVicCorr,'%.2f')};

boxplot(A,'labels',means);
set(gca,'XTick',-30:30)


colors = {green blue orange pink};
l = findall(gca,'type','line'); % get all lines in the box plot
for boxnum=1:4
    for j=1:length(l);
        xdata = get(l(j),'xdata'); % get their x values
        if all(abs(xdata-boxnum)<.5) % find ones in the desired group
            set(l(j))
            set(l(j), 'color', colors{boxnum});
        end
    end
end

tit=title(titles{3});
angLab=ylabel(AngleLabel(a));
set(tit,'FontSize',14)
set(angLab,'FontSize',14)    
set(gca,'FontSize',12)

end
%% Lengend

text('String','    -  Ideal Calibration',...
    'Position',[110 80 0],...
    'FontSize',16,...
    'EdgeColor',[0 0 0],...
    'Color',green,...
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
