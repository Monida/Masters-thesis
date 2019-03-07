function [PathNameVicon,numOfFramesVicon,ViconJointAngles]=getViconData(PathName,FileName)
%% GetViconData
if isempty(PathName)==1
    [FileNameVicon,PathNameVicon,FilterIndexVicon] = uigetfile('.csv');
    filename=strcat(PathNameVicon,FileNameVicon);
else
    filename=strcat(PathName,FileName);
    PathNameVicon=PathName;
    
end
[num,txt,raw] =xlsread(filename);

%% Find Joint AngleAs within Vicon Data
txtSz=size(txt); %All cells containting text
numSz=size(num); %All cells containing num data

%% To find row where data start
for r=1:txtSz(1)
    if num(r,1)==1 %Find where first frame starts (1)
        rowStart=r;
        break;
    end
end
framesVicon=num(rowStart:numSz(1),1);
framesViconSz=size(framesVicon);

%% To find num of frames
frame=0;
row=rowStart;

while isnan(num(row,1))==0 && row<size(num,1)
    frame=frame+1;
    row=row+1;
end

numOfFramesVicon=frame;
rowEnd=row-1;
%% To find column where joint angles start
for r=1:txtSz(1)
    for c=1:txtSz(2)
        if strcmp('LHipAngles',txt(r,c))==1
            colStart=c;
            break;
        end
    end
end


%ADDED THE SNIPET BELOW TO REMOVE ALL THE NaN VALUES WHILE IMPORTING
%VivonJointAngles BUT I DO NEED TO IMPORT THEM TO SEE HOW MANY FRAMES ARE
%IN TOTAL 
% %% To find row where angle data starts 
% row=rowStart;
% while isnan(num(row,colStart))==1 && row<size(num,1)
%     row=row+1;
% end
% rowStart=row;
%% To find column where joint angles end
for r=1:txtSz(1)
    for c=1:txtSz(2)
        if strcmp('RAnkleAngles',txt(r,c))==1
            colEnd=c;
            break;
        end
    end
end
colEnd=colEnd+2;
%% Extract Joint Angles Vicon
%%ViconJointAngles Matrix 
%row=frames 
%columns= rotation about x, y and z fora each joint
ViconJointAngles=num(rowStart:rowEnd,colStart:colEnd); 
JtAngViSz=size(ViconJointAngles);

%% Remove all the rows that has al zeros

%% Re-order Vicon Data Columns so that X=AA Y=IE Z=FE (x,y,z refer to the components of the vector containing joint angle data)

%%Vicon Euler Extraction uses Cardan Angles a
%%X=FE
%%Y=IE
%%Z=AA
numOfFramesVicon=size(ViconJointAngles,1);
ViconJointsCount=7;
ViconColumnIdx={1:3;4:6;7:9;10:12;13:15;16:18;19:21};
% ViconColumnIdx meaning
%1 = LeftHip
%2 = LeftKnee
%3 = LeftAnkle
%4 = LAbsAnkleAngle
%5 = RightHip
%6 = RightKnee
%7 = RightAnkle
axisV=3;

ViconIE=zeros(numOfFramesVicon,ViconJointsCount);
ViconAA=zeros(numOfFramesVicon,ViconJointsCount);
ViconFE=zeros(numOfFramesVicon,ViconJointsCount);

for j=1:ViconJointsCount
    ViconIE(:,j)=ViconJointAngles(:,ViconColumnIdx{j}(3));
    ViconAA(:,j)=ViconJointAngles(:,ViconColumnIdx{j}(2));
    ViconFE(:,j)=ViconJointAngles(:,ViconColumnIdx{j}(1));
end

for j=1:ViconJointsCount
    ViconJointAngles(:,ViconColumnIdx{j}(1))=ViconAA(:,j);
    ViconJointAngles(:,ViconColumnIdx{j}(2))=ViconIE(:,j);
    ViconJointAngles(:,ViconColumnIdx{j}(3))=ViconFE(:,j);
end
end

