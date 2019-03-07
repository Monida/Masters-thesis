 [FileNameVicon,PathNameVicon,~] = uigetfile('.csv');
    listVicon=dir(strcat(PathNameVicon,'*.csv'));
    filesCountVicon=length(listVicon);
    
        
for fi=1:filesCountVicon
    if isequal(listVicon(fi).name,FileNameVicon)==1
        startFileVicon=fi;
    end
end

for t=1:9
    
FileNameVicon=listVicon((startFileVicon-1)+t).name;
[~,~,ViconJointAngles]=getViconData(PathNameVicon,FileNameVicon);
ViconAngles{t}=ViconJointAngles;
figure
plot(ViconAngles{t}(:,18))
figure
plot(ViconAngles{t}(:,6))
end