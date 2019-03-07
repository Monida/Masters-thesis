%Returns a structure that contain a cell Array with the normalized
%Gait cycle data corrected using the Orientation Correction per joint.
function CorrectedAngles=orientCorrection(ExperimentalCondition)
trialCount=3;

%Select the folder
%MAKE SURE THAT THE FILES ARE STORED WITH THE NAMEFORMAT
%Trial-001,...,Trial-010,...Trial-020, etc.
%So that when using dir to import the files they are in order

%NPose+NW ---> Normal walking
%BK+BKW ---> Crouch Gait
%TT+TTW ---> Tiptoe Gait

display(strcat('Select the first dynamic MVN trial for experimental condition ', ExperimentalCondition));
[FileNameXsens,PathNameXsens,~] = uigetfile('.mvnx');
listXsens=dir(strcat(PathNameXsens,'*.mvnx'));
filesCountXsens=length(listXsens);

display(strcat('Select the Static Vicon trial for experimental condition',ExperimentalCondition));
[FileNameVicon,PathNameVicon,~] = uigetfile('.csv');
listVicon=dir(strcat(PathNameVicon,'*.csv'));
filesCountVicon=length(listVicon);

%Identify the file where the trials for this Experimental condition starts
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
    FileNameXsens=listXsens((startFileXsens-1)+t).name;
   [PathNameXsens,numOfFramesXsens,XsensOrient,~,~]=getXsensData(PathNameXsens,FileNameXsens);
   
  
Pelvis=1;
%Upper Leg
RUpperLeg=16;
RLowerLeg=17;
%Lower Leg
LUpperLeg=20;
LLowerLeg=21;
%Feet
RFoot=18;
LFoot=22;

% %% Re-orient them to face magnetic north
% %Rotate 54 degrees about Xsens ZG axis
% % a = angle to rotate
% % [x, y, z] = axis to rotate around
% a=10;
% x=0; y=0; z=2;
% 
% q=[cosd(a/2) sind(a/2)*x sind(a/2)*y sind(a/2)*z];
% 
% for f=3:numOfFramesXsens
%     Pelvis(f,:)=quatmultip(q,XsensOrient(f,Pelvis*4-3:Pelvis*4));
%     
%     RightUpperLeg(f,:)=quatmultip(q,XsensOrient(f,RUpperLeg*4-3:RUpperLeg*4));
%     LeftUpperLeg(f,:)=quatmultip(q,XsensOrient(f,LUpperLeg*4-3:LUpperLeg*4));
%     
%     RightLowerLeg(f,:)=quatmultip(q,XsensOrient(f,RLowerLeg*4-3:RLowerLeg*4));
%     LeftLowerLeg(f,:)=quatmultip(q,XsensOrient(f,LLowerLeg*4-3:LLowerLeg*4));
%     
%     Rfoot(f,:)=quatmultip(q,XsensOrient(f,RFoot*4-3:RFoot*4));
%     Lfoot(f,:)=quatmultip(q,XsensOrient(f,LFoot*4-3:LFoot*4));
% end
% 
% 

%% From quaternion 2 matrix
for f=1:numOfFramesXsens
    PelvisRmatrix(:,:,f)=quaternion2matrix(XsensOrient(f,Pelvis*4-3:Pelvis*4));
    RUpperLegRmatrix(:,:,f)=quaternion2matrix(XsensOrient(f,RUpperLeg*4-3:RUpperLeg*4));
    LUpperLegRmatrix(:,:,f)=quaternion2matrix(XsensOrient(f,LUpperLeg*4-3:LUpperLeg*4));
    
    RLowerLegRmatrix(:,:,f)=quaternion2matrix(XsensOrient(f,RLowerLeg*4-3:RLowerLeg*4));
    LLowerLegRmatrix(:,:,f)=quaternion2matrix(XsensOrient(f,LLowerLeg*4-3:LLowerLeg*4));
    
    RFootRmatrix(:,:,f)=quaternion2matrix(XsensOrient(f,RFoot*4-3:RFoot*4));
    LFootRmatrix(:,:,f)=quaternion2matrix(XsensOrient(f,LFoot*4-3:LFoot*4));
end
    
%% Get reference orientations
filename=strcat(PathNameXsens,'Frames.xlsx');
bodyDimensions=xlsread(filename,'ParticipantInfo','B1:B4');

FileNameVicon=listVicon((startFileVicon-1)+t).name;
[~,orientArray,~]=calculateOrientations(bodyDimensions,PathNameVicon,FileNameVicon);

orientArrayMean=mean(orientArray(:,:,:,:),3);  

%% Change of Basis

numOfFramesVicon=size(orientArray,3);
segmentCount=size(orientArray,4);
C=[0 -1 0; 1 0 0; 0 0 1];  
% C = [0 1 0; -1 0 0; 0 0 1]; %From Vicon to Xsens
newOrientArray=zeros(3,3,segmentCount);
for s=1:segmentCount
    newOrientArray(:,:,s)=C*orientArrayMean(:,:,s);
end
%%  Real body segment orientations

Pelvis=newOrientArray(:,:,1);
RThigh=newOrientArray(:,:,2);
RShank=newOrientArray(:,:,3);
LThigh=newOrientArray(:,:,5);
LShank=newOrientArray(:,:,6);

%Adjust foot Rmatrix to account for diffrence in foot definition
RFoot=zeros(3,3);
LFoot=zeros(3,3);
RFoot(:,1)=newOrientArray(:,3,4);
RFoot(:,2)=newOrientArray(:,2,4);
RFoot(:,3)=-newOrientArray(:,1,4);

LFoot(:,1)=newOrientArray(:,3,7);
LFoot(:,2)=newOrientArray(:,2,7);
LFoot(:,3)=-newOrientArray(:,1,7);



%% Do correction

for f=1:numOfFramesXsens
    PelvisCorrRmatrix(:,:,f)=PelvisRmatrix(:,:,f)*Pelvis;
    RUpperLegCorrRmatrix(:,:,f)=RUpperLegRmatrix(:,:,f)*RThigh;
    LUpperLegCorrRmatrix(:,:,f)=LUpperLegRmatrix(:,:,f)*LThigh;
    
    RLowerLegCorrRmatrix(:,:,f)=RLowerLegRmatrix(:,:,f)*RShank;
    LLowerLegCorrRmatrix(:,:,f)=LLowerLegRmatrix(:,:,f)*LShank;
    
    RFootCorrRmatrix(:,:,f)=RFootRmatrix(:,:,f)*RFoot;
    LFootCorrRmatrix(:,:,f)=LFootRmatrix(:,:,f)*LFoot;
end

%% Reestimate Kinematics with GroodSuntayAngles fucntion
for f=1:numOfFramesXsens
    RHipCorr(f,:)=GroodSuntayAngles(PelvisCorrRmatrix(:,:,f),RUpperLegCorrRmatrix(:,:,f),'Hip','R');
    LHipCorr(f,:)=GroodSuntayAngles(PelvisCorrRmatrix(:,:,f),LUpperLegCorrRmatrix(:,:,f),'Hip','L');

    RKneeCorr(f,:)=GroodSuntayAngles(RUpperLegCorrRmatrix(:,:,f),RLowerLegCorrRmatrix(:,:,f),'Knee','R');
    LKneeCorr(f,:)=GroodSuntayAngles(LUpperLegCorrRmatrix(:,:,f),LLowerLegCorrRmatrix(:,:,f),'Knee','L');

    RAnkleCorr(f,:)=GroodSuntayAngles(RLowerLegCorrRmatrix(:,:,f),RFootCorrRmatrix(:,:,f),'Ankle','R');
    LAnkleCorr(f,:)=GroodSuntayAngles(LLowerLegCorrRmatrix(:,:,f),LFootCorrRmatrix(:,:,f),'Ankle','L');
end

%% Reallocate
%{
RAnkleCorr=RAnkle(:,2);
LAnkleCorr=LAnkle(:,2);
RAnkleCorr(:,2)=RAnkle(:,1);
LAnkleCorr(:,2)=LAnkle(:,1);
RAnkleCorr(:,3)=RAnkle(:,3);
LAnkleCorr(:,3)=LAnkle(:,3);
%}
CorrectedAngles{t}=[RHipCorr,RKneeCorr,RAnkleCorr,LHipCorr,LKneeCorr,LAnkleCorr];
%% Normalize
% trial=t;
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

%% Prepare output
%NormCorrStruct=struct('RHipCorr',NormRHipCorr,'LHipCorr',NormLHipCorr,'RKneeCorr',NormRKneeCorr,'LKneeCorr',NormLKneeCorr,'RAnkleCorr',NormRAnkleCorr,'LAnkleCorr',NormLAnkleCorr);
end

function [framesR,framesL]=findFrame(filename,ExperimentalCondition,trial)
[num,txt,~] =xlsread(filename,'Frames');
txtSz=size(txt); %All cells containting text

%Row where frames data start
rowStart=4;

%Find column corresponding to that Experimental condition
for r=1:txtSz(1)
    for c=1:txtSz(2)
        if strcmp(ExperimentalCondition,txt(r,c))==1
            colStart=c;
            break;
        end
    end
end

colEnd=colStart+1;

%Find last row that contains data
row=rowStart;

while isnan(num(row,colStart))==0 
    row=row+1;
end

rowEnd=row-1;

switch trial
    case 1
        frames=num(rowStart:rowEnd,colStart:colEnd); 
    case 2
        frames=num((rowStart:rowEnd)+9,colStart:colEnd); 
    case 3
        frames=num((rowStart:rowEnd)+18,colStart:colEnd);      
end    

framesR=frames(:,1);
framesL=frames(:,2);
end
