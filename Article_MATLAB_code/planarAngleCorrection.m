%planarAngleCorrection
%This function/script takes XsensJointAngles (gaitData) and used
%ViconJointAngles (calibration posture) to remove offsets
%Retutns NormCorr
function CorrectedAngles=planarAngleCorrection(ExperimentalCondition)
trialCount=3;
%Select the folder
%MAKE SURE THAT THE FILES ARE STORED WITH THE NAMEFORMAT
%Trial-001,...,Trial-010,...Trial-020, etc.
%So that when using dir to import the files they are in order

display(strcat('Select the first dynamic MVN trial for experimental condition   ', ExperimentalCondition));

%Choose the trial file
[FileNameXsens,PathNameXsens,~] = uigetfile('.mvnx');
listXsens=dir(strcat(PathNameXsens,'*.mvnx'));
filesCountXsens=length(listXsens);


display(strcat('Select the dynamic Vicon trial for experimental condition    ',ExperimentalCondition));


%Choose the static file
[FileNameVicon,PathNameVicon,~] = uigetfile('.csv');
listVicon=dir(strcat(PathNameVicon,'*.csv'));
filesCountVicon=length(listVicon);


%Identify the file where the trials for this Experimental condition start
for fi=1:filesCountXsens
    if isequal(listXsens(fi).name,FileNameXsens)==1
        startFileXsens=fi;
    end
end

for fi=1:filesCountVicon
    if isequal(listVicon(fi).name,FileNameVicon)==1
        startFileVicon=fi;
    end
end

for t=1:trialCount
    %Read the 3 files corresponding to the 3 trials for that
    %ExperimentalCondition starting with startFile
    
    
%% Get XsensJointAngles
FileNameXsens=listXsens((startFileXsens-1)+t).name;
   [PathNameXsens,numOfFramesXsens,~,~,XsensJointAngles]=getXsensData(PathNameXsens,FileNameXsens);
XsensJointsColumnIdx={1:3;4:6;7:9;10:12;13:15;16:18;19:21;22:24;25:27;28:30;31:33;34:36;37:39;40:42;43:45;46:48;49:51;52:54;55:57;58:60;61:63;64:66};

jRHip=15;
jRKnee=16;
jRAnkle=17;

jLHip=19;
jLKnee=20;
jLAnkle=21;

RHipRef=XsensJointAngles(:,XsensJointsColumnIdx{jRHip});
RKneeRef=XsensJointAngles(:,XsensJointsColumnIdx{jRKnee});
RAnkleRef=XsensJointAngles(:,XsensJointsColumnIdx{jRAnkle});
LHipRef=XsensJointAngles(:,XsensJointsColumnIdx{jLHip});
LKneeRef=XsensJointAngles(:,XsensJointsColumnIdx{jLKnee});
LAnkleRef=XsensJointAngles(:,XsensJointsColumnIdx{jLAnkle});


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


RHipVic=mean(ViconJointAngles(firstRow:end,ViconJointsColumnIdx{RHip}));
RKneeVic=mean(ViconJointAngles(firstRow:end,ViconJointsColumnIdx{RKnee}));
RAnkleVic=mean(ViconJointAngles(firstRow:end,ViconJointsColumnIdx{RAnkle}));
LHipVic=mean(ViconJointAngles(firstRow:end,ViconJointsColumnIdx{LHip}));
LKneeVic=mean(ViconJointAngles(firstRow:end,ViconJointsColumnIdx{LKnee}));
LAnkleVic=mean(ViconJointAngles(firstRow:end,ViconJointsColumnIdx{LAnkle}));

%{
RHipVic=mean(ViconJointAngles(40:70,ViconJointsColumnIdx{RHip}));
RKneeVic=mean(ViconJointAngles(40:70,ViconJointsColumnIdx{RKnee}));
RAnkleVic=mean(ViconJointAngles(40:70,ViconJointsColumnIdx{RAnkle}));
LHipVic=mean(ViconJointAngles(40:70,ViconJointsColumnIdx{LHip}));
LKneeVic=mean(ViconJointAngles(40:70,ViconJointsColumnIdx{LKnee}));
LAnkleVic=mean(ViconJointAngles(40:70,ViconJointsColumnIdx{LAnkle}));
%}
%% Do Corrections
for f=1:numOfFramesXsens
    RHipCorr(f,:)=RHipRef(f,:)+RHipVic;
    RKneeCorr(f,:)=RKneeRef(f,:)+RKneeVic;
    RAnkleCorr(f,:)=RAnkleRef(f,:)+RAnkleVic;
    LHipCorr(f,:)=LHipRef(f,:)+LHipVic;
    LKneeCorr(f,:)=LKneeRef(f,:)+LKneeVic;
    LAnkleCorr(f,:)=LAnkleRef(f,:)+LAnkleVic;
end

CorrectedAngles{t}=[RHipCorr,RKneeCorr,RAnkleCorr,LHipCorr,LKneeCorr,LAnkleCorr];

% trial=t;
%     filename=strcat(PathNameXsens,'Frames.xlsx');
%     [framesR,framesL]=findFrame(filename,ExperimentalCondition,trial);
% 
% 
%     NormRHipCorr{t}=NormGaitCycles(RHipCorr,framesR.');
%     NormLHipCorr{t}=NormGaitCycles(LHipCorr,framesL.');
%     
%     NormRKneeCorr{t}=NormGaitCycles(RKneeCorr,framesR.');
%     NormLKneeCorr{t}=NormGaitCycles(LKneeCorr,framesL.');
%     
%     NormRAnkleCorr{t}=NormGaitCycles(RAnkleCorr,framesR.');
%     NormLAnkleCorr{t}=NormGaitCycles(LAnkleCorr,framesL.');
% end
end
