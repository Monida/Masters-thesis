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

%% Plot Boxplots for Hip
for a=1:axesCount 
   
A=[DIFFLHipVicRef(:,a)];
axes('Position', posArray{a});
axis auto
boxplot(A);
set(gca,'XTickLabel',{' '})
set(gca,'XTick',-30:30)
set(gca,'YAxisLocation','right')
colors = {green};
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

%% Plot Boxplots for Knee
for a=1:axesCount
   
A=[DIFFLKneeVicRef(:,a)];
axes('Position', posArray{a+3});

boxplot(A);
set(gca,'XTickLabel',{' '})
set(gca,'XTick',-30:30)
set(gca,'YAxisLocation','right')

colors = {green};
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
   
A=[DIFFLAnkleVicRef(:,a)];
axes('Position', posArray{a+6});

boxplot(A);
set(gca,'XTickLabel',{' '})
set(gca,'XTick',-30:30)
set(gca,'YAxisLocation','right')

colors = {green};
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

