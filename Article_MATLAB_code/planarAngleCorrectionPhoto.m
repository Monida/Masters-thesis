 %planarAngleCorrection
%This function/script takes XsensJointAngles (gaitData) and used
%ViconJointAngles (calibration posture) to remove offsets
%Retutns NormCorr
function CorrectedAngles=planarAngleCorrectionPhoto(ExperimentalCondition)
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

%Choose the trial file
[FileName2D,PathName2D,~] = uigetfile('.xlsx');


%Identify the file where the trials for this Experimental condition start
for fi=1:filesCountXsens
    if isequal(listXsens(fi).name,FileNameXsens)==1
        startFileXsens=fi;
    end
end

%Open Excel spreadsheet with angles
[num,txt,~]=xlsread(strcat(PathName2D,FileName2D),'2D');
ang=findAng(num,txt,ExperimentalCondition);
%ang is a matrix size 3x9. col=hip AA Hip IE hip FE, knee AA knee IE knee FE, ankle AA, Ankle IE, ankle FE;  row=trial
hip=1;
knee=2;
ankle=3;

angIdx={1:3,4:6,7:9};

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

RHipCorr=RHipRef;
RKneeCorr=RKneeRef;
RAnkleCorr=RAnkleRef;
LHipCorr=LHipRef;
LKneeCorr=LKneeRef;
LAnkleCorr=LAnkleRef;

%% Do Corrections

for f=1:numOfFramesXsens
    RHipCorr(f,:)=RHipRef(f,:)+ang(t,angIdx{hip});
    RKneeCorr(f,:)=RKneeRef(f,:)+ang(t,angIdx{knee});
    RAnkleCorr(f,:)=RAnkleRef(f,:)+ang(t,angIdx{ankle});
    LHipCorr(f,:)=LHipRef(f,:)+ang(t,angIdx{hip});
    LKneeCorr(f,:)=LKneeRef(f,:)+ang(t,angIdx{knee});
    LAnkleCorr(f,:)=LAnkleRef(f,:)+ang(t,angIdx{ankle});
end

CorrectedAngles{t}=[RHipCorr,RKneeCorr,RAnkleCorr,LHipCorr,LKneeCorr,LAnkleCorr];
% trial=t;
%     filename=strcat(PathNameXsens,'Frames');
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
end
end

function ang=findAng(num,txt,ExperimentalCondition)
for c=1:size(txt,2)
    if strcmp(txt(1,c),ExperimentalCondition)==1
        col=c;
        break;
    end
end
ang=num(9:11,col:col+8);
end