%Plot derivative
%Plot only left side BK+BKW
[filename,filepath,~]=uigetfile('.xlsx');
DIFF=xlsread(strcat(filepath,filename),'DiffVicRef','AB17:AJ116');
Deriv=xlsread(strcat(filepath,filename),'DerivVicRef','AB17:AJ115');

orange=[221 114 26]/255;
blue=[58 70 163]/255;
red=[192 0 0]/255;
marron=[153 83 48]/255;
gray=[66 65 66]/255;
green=[108 206 66]/255;
axes=3;
tdiff=1:100;
tderiv=1:99;
onesVector=ones(1,100);
columnIdx={1:3;4:6;7:9};


%% Plott
figure

sup=suptitle('Derivative of the difference between PiG and MVN (DIFF_D) (Left)');
set(sup,'FontSize', 25)
AngleLabel={'Hip';'Knee';'Ankle'};
titles={'Abd - Add','Ext - Int','Ext - Flex'};
%Hip
for a=1:axes
    subplot(3,3,a) 
    plot(tdiff, DIFF(:,columnIdx{1}(:,a)),'LineWidth',2,'color',red);
    hold on
    maxDiff=max(DIFF(:,columnIdx{1}(:,a)));
    minDiff=min(DIFF(:,columnIdx{1}(:,a)));
    plot(tdiff, maxDiff*onesVector,'color',red);
    plot(tdiff, minDiff*onesVector,'color',red);
    plot(tderiv, Deriv(:,columnIdx{1}(:,a)),'LineWidth',2,'color','black');
    
    tit=title(titles{a});
    
    if a==1
        angLab=ylabel(AngleLabel(1));
        set(angLab,'FontSize',15)
    end
    set(tit,'FontSize',15)
    
    set(gca,'FontSize',12)
     if a~=3
        axis([0 100 -20 20])
    else
        axis([0 100 -5 75])
    end
end

%Knee
for a=1:axes
    subplot(3,3,a+3) 
    plot(tdiff, DIFF(:,columnIdx{2}(:,a)),'LineWidth',2,'color',red);
    hold on
    maxDiff=max(DIFF(:,columnIdx{2}(:,a)));
    minDiff=min(DIFF(:,columnIdx{2}(:,a)));
    plot(tdiff, maxDiff*onesVector,'color',red);
    plot(tdiff, minDiff*onesVector,'color',red);
    plot(tderiv, Deriv(:,columnIdx{2}(:,a)),'LineWidth',2,'color','black');
    
    if a==1
        angLab=ylabel(AngleLabel(2));
        set(angLab,'FontSize',15)
    end
    
    set(gca,'FontSize',12)
     if a~=3
        axis([0 100 -20 20])
    else
        axis([0 100 -5 75])
    end
end

%Ankle
for a=1:axes
    subplot(3,3,a+6) 
    plot(tdiff, DIFF(:,columnIdx{3}(:,a)),'LineWidth',2,'color',red);
    hold on
    maxDiff=max(DIFF(:,columnIdx{3}(:,a)));
    minDiff=min(DIFF(:,columnIdx{3}(:,a)));
    plot(tdiff, maxDiff*onesVector,'color',red);
    plot(tdiff, minDiff*onesVector,'color',red);
    plot(tderiv, Deriv(:,columnIdx{3}(:,a)),'LineWidth',2,'color','black');
    
    gaitLab=xlabel('% Gait Cycle');
    if a==1
        angLab=ylabel(AngleLabel(3));
        set(angLab,'FontSize',15)
    end
    
     set(gaitLab,'FontSize',15)
    set(gca,'FontSize',12)
    
    if a~=3
        axis([0 100 -20 20])
    else
        axis([0 100 -5 75])
    end
        
end