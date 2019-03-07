%StaticViconAngles
%Find the Vicon static angles mean
function [RStatVicAng, LStatVicAng]=StaticViconAngles()
trialCount=3;
%Choose the static file
[FileNameVicon,PathNameVicon,~] = uigetfile('.csv');
listVicon=dir(strcat(PathNameVicon,'*.csv'));
filesCountVicon=length(listVicon);

%Identify the file where the trials for this Experimental condition start
for fi=1:filesCountVicon
    if isequal(listVicon(fi).name,FileNameVicon)==1
        startFileVicon=fi;
    end
end

RHipVic=zeros(trialCount,3);
RKneeVic=zeros(trialCount,3);
RAnkleVic=zeros(trialCount,3);
LHipVic=zeros(trialCount,3);
LKneeVic=zeros(trialCount,3);
LAnkleVic=zeros(trialCount,3);

for t=1:trialCount
    %% Get ViconJointAngles
FileNameVicon=listVicon((startFileVicon-1)+t).name;
[PathNameVicon,~,ViconJointAngles]=getViconData(PathNameVicon,FileNameVicon);
ViconJointsColumnIdx={1:3;4:6;7:9;10:12;13:15;16:18;19:21};


%Remove NaN values due to missing markers
%Find the first row that doesn't contain NaN values
%It only checks the first half of posData becuase we are certain the there
%are no missing markers in the middle of the data
[I,~] = find(isnan(ViconJointAngles) == 1);
if isempty(I)==1
    firstRow=1;
else
    firstRow=max(I)+1;
end

RHip=5;
RKnee=6;
RAnkle=7;
LHip=1;
LKnee=2;
LAnkle=3;

RHipVic(t,:)=mean(ViconJointAngles(firstRow:end,ViconJointsColumnIdx{RHip}));
RKneeVic(t,:)=mean(ViconJointAngles(firstRow:end,ViconJointsColumnIdx{RKnee}));
RAnkleVic(t,:)=mean(ViconJointAngles(firstRow:end,ViconJointsColumnIdx{RAnkle}));
LHipVic(t,:)=mean(ViconJointAngles(firstRow:end,ViconJointsColumnIdx{LHip}));
LKneeVic(t,:)=mean(ViconJointAngles(firstRow:end,ViconJointsColumnIdx{LKnee}));
LAnkleVic(t,:)=mean(ViconJointAngles(firstRow:end,ViconJointsColumnIdx{LAnkle}));

end
RStatVicAng=[RHipVic RKneeVic RAnkleVic];
LStatVicAng=[LHipVic LKneeVic LAnkleVic];
end