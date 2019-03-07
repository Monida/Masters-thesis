% Plot boxplots on comparison plots

%Define the position for the boxplots
boxplot11=[0.226 0.7 0.034 0.219];
boxplot12=[0.476 0.7 0.034 0.219];
boxplot13=[0.727 0.7 0.034 0.219];
boxplot21=[0.226 0.4 0.034 0.219];
boxplot22=[0.476 0.4 0.034 0.219];
boxplot23=[0.727 0.4 0.034 0.219];
boxplot31=[0.226 0.98 0.034 0.219];
boxplot32=[0.476 0.98 0.034 0.219];
boxplot33=[0.727 0.98 0.034 0.219];

burgundy=[163 32 67]/255;
green=[108 206 66]/255;
pink=[177 47 206]/255;
orange=[221 114 26]/255;
axesCount=3;

posArray={boxplot11; boxplot12; boxplot13; boxplot21; boxplot22; boxplot23; boxplot31; boxplot32; boxplot33};

%% Plot Boxplots for Hip
for a=1:axesCount 
   
A=[DIFFLHipVicRComp(:,a) DIFFLHipVicRef(:,a)];
axes('Position', posArray{a});
axis auto
boxplot(A);
set(gca,'XTickLabel',{' '})
set(gca,'XTick',-30:30)
set(gca,'YAxisLocation','right')
colors = {green burgundy};
l = findall(gca,'type','line'); % get all lines in the box plot
for boxnum=1:2
    for j=1:length(l);
        xdata = get(l(j),'xdata'); % get their x values
        if all(abs(xdata-boxnum)<.5) % find ones in the desired group
            set(l(j))
            set(l(j), 'color', colors{boxnum});
        end
    end
end

end

%% Plot Boxplots for Knee
for a=1:axesCount
   
A=[DIFFLKneeVicRComp(:,a) DIFFLKneeVicRef(:,a)];
axes('Position', posArray{a+3});

boxplot(A);
set(gca,'XTickLabel',{' '})
set(gca,'XTick',-30:30)
set(gca,'YAxisLocation','right')

colors = {green burgundy};
l = findall(gca,'type','line'); % get all lines in the box plot
for boxnum=1:3
    for j=1:length(l);
        xdata = get(l(j),'xdata'); % get their x values
        if all(abs(xdata-boxnum)<.5) % find ones in the desired group
            set(l(j))
            set(l(j), 'color', colors{boxnum});
        end
    end
end

end
%% Plot Boxplots for Ankle
for a=1:axesCount
   
A=[DIFFLAnkleVicRComp(:,a) DIFFLAnkleVicRef(:,a)];
axes('Position', posArray{a+6});

boxplot(A);
set(gca,'XTickLabel',{' '})
set(gca,'XTick',-30:30)
set(gca,'YAxisLocation','right')

colors = {green burgundy};
l = findall(gca,'type','line'); % get all lines in the box plot
for boxnum=1:3
    for j=1:length(l);
        xdata = get(l(j),'xdata'); % get their x values
        if all(abs(xdata-boxnum)<.5) % find ones in the desired group
            set(l(j))
            set(l(j), 'color', colors{boxnum});
        end
    end
end

end

