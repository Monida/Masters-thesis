%getXsensData
%{
This function outputs sevelar information about the file that is being opened.
PathNameXsens: is the path where the file is saved.
numOfFramesXsens: is the number of frames present in that file
XsensOrient: the orientation of each of the segments in the MVN
Biomechanical model in quaternion format.
XsensOrient: the orientation of each of the segments in the MVN
Biomechanical model in matrix format.
XsensJointAngles: the angle in the three planes of motion for each of the joints in the MVN Biomechanical model
The data is organized as follows. 
Each group of three columns correspond to a joint in the following order
1. L5S1
2. L4L3
3. L1T12
4. 

%}
%% Open a file
function [PathNameXsens,numOfFramesXsens,XsensOrient,XsensOrientRmatrix,XsensJointAngles]=getXsensData(PathName,FileName)

if isempty(PathName)==1 && isempty(FileName)
    [FileNameXsens,PathNameXsens,FilterIndexXsens] = uigetfile('.mvnx');
    filename=strcat(PathNameXsens,FileNameXsens);
else
    filename=strcat(PathName,FileName);
    PathNameXsens=PathName;
end
mvn=load_mvnx(filename);

%% Extract BodySegment Orientation
mvnxCell=struct2cell(mvn.subject.frames.frame);
mvnxCellSize=size(mvnxCell);
numOfFramesXsens=mvnxCellSize(3);
XsensOrientColumnCount=92;
for f=1:numOfFramesXsens
    OrientationCell(f)=mvnxCell(6,1,f); %Number 6 is the element of the Cell that contains all the bodysegment orientations.
end
XsensOrient=zeros(numOfFramesXsens,XsensOrientColumnCount);
for f=1:numOfFramesXsens
    XsensOrient(f,:)=OrientationCell{f};
end

NposeOrientQuat=XsensOrient(1,:);


%% Find all the conjugates
qconj = @(x) [x(1) -x(2) -x(3) -x(4)];

XsensColumnIdx={1:4;5:8;9:12;13:16;17:20;21:24;25:28;29:32;33:36;37:40;41:44;45:48;49:52;53:56;57:60;61:64;65:68;69:72;73:76;77:80;81:84;85:88;89:92};
XsensOrientConj=zeros(numOfFramesXsens,XsensOrientColumnCount);
XsensSegmentCount=23;

for f=1:numOfFramesXsens
    for j=1:XsensSegmentCount
        XsensOrientConj(f,XsensColumnIdx{j})=qconj(XsensOrient(f,XsensColumnIdx{j}));
    end
end

%% Convert quaternions into rotation matrix
szXsens=size(XsensOrient);
numOfFramesXsens=szXsens(1);
XsensOrientColumnCount=szXsens(2);

XsensOrientRmatrix=zeros(3,3,numOfFramesXsens,XsensSegmentCount);%XsensOrientRmatrix(rows,cols,frames,joint)
XsensOrientRmatrixConj=zeros(3,3,numOfFramesXsens,XsensSegmentCount);
%Each row of this array contains the column indeces corresponding to
%each joint

%% test
for f=1:numOfFramesXsens
    for j=1:XsensSegmentCount
        XsensOrientRmatrix(:,:,f,j)=quaternion2matrix(XsensOrient(f,XsensColumnIdx{j}));
        XsensOrientRmatrixConj(:,:,f,j)=quaternion2matrix(XsensOrientConj(f,XsensColumnIdx{j}));
    end
end

%% Extract JointAnglesXsens
XsensJointsColumnIdx={1:3;4:6;7:9;10:12;13:15;16:18;19:21;22:24;25:27;28:30;31:33;34:36;37:39;40:42;43:45;46:48;49:51;52:54;55:57;58:60;61:63;64:66};

for f=1:numOfFramesXsens
    JointAnglesCell(f)=mvnxCell(16,1,f); %Number 16 is the element of the Cell that contains all the joint Angles.
end
XsensJointsColumnCount=66;
XsensJointAngles=zeros(numOfFramesXsens,XsensJointsColumnCount);

XsensJointAngles(1,:)=zeros(1,XsensJointsColumnCount);
XsensJointAngles(2,:)=zeros(1,XsensJointsColumnCount);

for f=3:numOfFramesXsens
    XsensJointAngles(f,:)=JointAnglesCell{f};
end
end