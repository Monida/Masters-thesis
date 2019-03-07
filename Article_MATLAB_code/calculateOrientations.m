function [orientStructs,orientArray,angles] = calculateOrientations(bodyDimensions,PathName,FileName)
%CALCULATEORIENTATIONS Summary of this function goes here
% Equations and instructions taken from:
% P:\Technical documetation\VICON 2012\Gait lab\Gait lab collection instructions and models\Vicon\ViconModels

% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%   Detailed explanation goes here
%   patientDimensions(1)=legLength
%   patientDimensions(2)= kneeWidth
%   patientDimensions(3)= ankleWidth
%   patientDimensions(4)= interAsisDist
%
%   1. Read in Excel file containing Marker Positions, Joint Angles
%   2. Define variables for marker positions, joint angles
%   3. Define Fixed Values (i.e. Pelvis and hip joint centers)
%   4. Find constants from the static trial
%   5. Calculate KJC, AJC. Foot.  Define Segment bases
%   6. Determine Segment Orientations (Z-vectors)
%   7. Calculate Joint Angles
% \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

% OUTPUTS
% 1. orientStructs = Cell (7x1) of structures representing each segment
%   orientation and joint origin:
%       {1} = Pelvis
%       {2} = Right Thigh
%       {3} = Right Shank
%       {4} = Right Foot
%       {5} = Left Thigh
%       {6} = Left Shank
%       {7} = Left Foot
%   Each segment has the sub-categories:
%       .origin     -   Global xyz location of proximal joint of segment
%       .x          -   Global xyz vector of local x-direction (AB/AD axis)
%       .y          -   Global xyz vector of local y-direction (FE axis)
%       .z          -   Global xyz vector of local z-direction (IE axis)
% 2. orientArray

%% 1. Read in Excel file containing Marker Positions, Joint Angles.  Unpack measurements
if isempty(PathName)==1
    [FileNameVicon,PathNameVicon,~] = uigetfile('.csv');
    filename=strcat(PathNameVicon,FileNameVicon);
else
    filename=strcat(PathName,FileName);
end
[posData,angData] = readAndSeparate(filename);
legLength=bodyDimensions(1);
kneeWidth=bodyDimensions(2);
ankleWidth=bodyDimensions(3);
interAsisDist=bodyDimensions(4);

%Remove NaN values due to missing markers
%Find the first row that doesn't contain NaN values
%It only checks the first half of posData becuase we are certain the there
%are no missing markers in the middle of the data
[I,~] = find(isnan(posData(1:ceil(size(posData,1)/2),:)) == 1);
if isempty(I)==1
    firstRow=1;
else
    firstRow=max(I)+1;
end
 
%% 2. Define variables for marker positions
% Assign Marker Data [x y z]
lasi = posData(firstRow:end,1:3);
rasi = posData(firstRow:end,4:6);
lpsi = posData(firstRow:end,7:9);
rpsi = posData(firstRow:end,10:12);
lthi = posData(firstRow:end,13:15);
lkne = posData(firstRow:end,16:18);
ltib = posData(firstRow:end,19:21);
lank = posData(firstRow:end,22:24);
lhee = posData(firstRow:end,25:27);
ltoe = posData(firstRow:end,28:30);
rthi = posData(firstRow:end,31:33);
rkne = posData(firstRow:end,34:36);
rtib = posData(firstRow:end,37:39);
rank = posData(firstRow:end,40:42);
rhee = posData(firstRow:end,43:45);
rtoe = posData(firstRow:end,46:48);

% Assign Angle Data
lHipAngles = angData(:,1:3);
lKneeAngles = angData(:,4:6);
lAnkleAngles = angData(:,7:9);
lAbsAnkleAngle = angData(:,10:12);
rHipAngles = angData(:,13:15);
rKneeAngles = angData(:,16:18);
rAnkleAngles = angData(:,19:21);
rAbsAnkleAngle = angData(:,22:24);

% Unpack body measurements
legLength = ones(1,2)*legLength;

%% 3. Define Fixed Values (i.e. Pelvis and hip joint centers)
[lhjc,rhjc,pelvis] = calcFixedAngles(legLength,lasi,rasi,lpsi,rpsi,interAsisDist);
 
%% 4. Find constants from static trial

[tibialTorsion,alpha,beta] = staticVicon(bodyDimensions,PathName,'Calibration.csv');

%% 5. Calculate KJC,AJC, Foot
% left knee joint
lkjc = calcJointCenter(-kneeWidth,legLength(1),lhjc,lthi,lkne,'left');

% right knee joint
rkjc = calcJointCenter(kneeWidth,legLength(2),rhjc,rthi,rkne,'right');

% left ankle joint - torsioned tibia
lajc = calcJointCenter(ankleWidth,legLength(1),lkjc,ltib,lank,'left');

% untorsioned (modify to use tibial torsion)
%{
lajcU.origin = lajc.origin;
lajcU.z = lajc.z; % vector from AJC to KJC, same as torsioned
lajcU.x = lkjc.x; % normal to plane defined by HJC,THI,KJC... same as knee!
lajcU.y = cross(lajcU.z,lajcU.x); % cross product between ankle z and x
%}

lajcU = calcUntorsionedTibia(lajc,tibialTorsion(1));

% right ankle joint - torsioned tibia
rajc = calcJointCenter(ankleWidth,legLength(2),rkjc,rtib,rank,'right');

% untorsioned
%{
rajcU.origin = rajc.origin;
rajcU.z = rajc.z; % vector from AJC to KJC, same as torsioned
rajcU.x = rkjc.x; % normal to plane defined by HJC,THI,KJC... same as knee!
rajcU.y = cross(rajcU.z,rajcU.x); % cross product between ankle z and x
%}

rajcU = calcUntorsionedTibia(rajc,tibialTorsion(2));

% left foot
lfoot = calcFoot(lajc.origin,ltoe,lkjc.origin,alpha(1),beta(1));

% right foot
rfoot = calcFoot(rajc.origin,rtoe,rkjc.origin,alpha(2),beta(2));

%% 6. Define Segment Orientations
lthigh = (lkjc.origin-lhjc.origin)./vecMag(lkjc.origin-lhjc.origin);
rthigh = (rkjc.origin-rhjc.origin)./vecMag(rkjc.origin-rhjc.origin);
lshank = (lajc.origin-lkjc.origin)./vecMag(lajc.origin-lkjc.origin);
rshank = (rajc.origin-rkjc.origin)./vecMag(rajc.origin-rkjc.origin);

%% 7. Calculate Joint Angles
% Hip Angles
lhipAng = calcJointAngles(lhjc,lkjc,'Hip','L');
rhipAng = calcJointAngles(rhjc,rkjc,'Hip','R');

% Knee Angles
lkneeAng = calcJointAngles(lkjc,lajcU,'Knee','L');%using untorsioned tibia
rkneeAng = calcJointAngles(rkjc,rajcU,'Knee','R');

% Ankle Angles 
lankleAng = calcJointAngles(lajc,lfoot,'Ankle','L');%using torsioned tibia
rankleAng = calcJointAngles(rajc,rfoot,'Ankle','R');

angles={lhipAng, lkneeAng, lankleAng, rhipAng, rkneeAng, rankleAng};

%% Prepare Outputs
% 1. orientStructs
orientStructs{1} = orderfields(pelvis); orientStructs{2} = orderfields(rkjc);
orientStructs{3} = orderfields(rajc); orientStructs{4} = orderfields(rfoot);
orientStructs{5} = orderfields(lkjc); orientStructs{6} = orderfields(lajc);
orientStructs{7} = orderfields(lfoot);

% 2. Array Format (row,col,frame,segment)
orientArray = calcOrientArray(orientStructs);
end

function [posData,angData] = readAndSeparate(filepath)
% Read in All Data
[num,txt,~] =xlsread(filepath);

%%Find Marker Position within Vicon Data
txtSz=size(txt); %All cells containting text
numSz=size(num); %All cells containing num data

%Find row where frames start
for r=1:txtSz(1)
    if num(r,1)==1 %Find where first frame starts (1)
        rowStart=r;
        break;
    end
end
framesVicon=num(rowStart:numSz(1),1);
framesViconSz=size(framesVicon);

%Find num of frames
frame=0;
row=rowStart;

while isnan(num(row,1))==0 && row<size(num,1)
    frame=frame+1;
    row=row+1;
end
rowEnd=row-1;

%Find column where marker position start
for r=1:txtSz(1)
    for c=1:txtSz(2)
        if strcmp('LASI',txt(r,c))==1
            colPosStart=c;
            break;
        end
    end
end
%%To find column where marker position end
for r=1:txtSz(1)
    for c=1:txtSz(2)
        if strcmp('RTOE',txt(r,c))==1
            colPosEnd=c;
            break;
        end
    end
end
colPosEnd=colPosEnd+2;

%Find column where joint angles start
for r=1:txtSz(1)
    for c=1:txtSz(2)
        if strcmp('LHipAngles',txt(r,c))==1
            colAngStart=c;
            break;
        end
    end
end
%%To find column where joint angles end
for r=1:txtSz(1)
    for c=1:txtSz(2)
        if strcmp('RAbsAnkleAngle',txt(r,c))==1
            colAngEnd=c;
            break;
        end
    end
end
colAngEnd=colAngEnd+2;

posData=num(rowStart:rowEnd,colPosStart:colPosEnd);
angData=num(rowStart:rowEnd,colAngStart:colAngEnd);
end

function [lhjc,rhjc,pelvis] = calcFixedAngles(legLength,lasi,rasi,lpsi,rpsi,interAsisDist)
%  Defined using the Newington-Gage model, as specified in the Plug-in Gait
%  manual

% Determine Pelvis Coordinate System
pelvis.origin = (lasi + rasi)./2;
sac = (lpsi + rpsi)./2; % sacrum position as mean of LPSI and RPSI markers

pelvis.y = (lasi-rasi)./repmat(sqrt(sum((lasi-rasi).^2,2)),1,3);
pelvis.z = cross((rasi - sac),(lasi-sac))./repmat(sqrt(sum((cross((rasi - sac),(lasi-sac))).^2,2)),1,3);
pelvis.x = cross(pelvis.y,pelvis.z,2);


% InterAsis distance
interAsis = interAsisDist;
%interAsis = mean(sqrt(sum((lasi-rasi).^2,2)));

% Left Asis to Trochanter distance
lAsisTrocDist = 0.1288*legLength(1) - 48.56;

% RightAsis to Trochanter distance
rAsisTrocDist = 0.1288*legLength(2) - 48.56;


% Left HJC offset
beta = 0.314; % radians... constant from model
aa = interAsis/2; % half inter asis distance
theta = 0.5; % radians... constant from model
mm = 14; % marker radius (mm)
C = mean(legLength(:))*0.115 - 15.3;

x = (C*cos(theta)*sin(beta) - (lAsisTrocDist + mm)*cos(beta))*pelvis.x;
y = (-(C*sin(theta) - aa))*pelvis.y;
z = (-C*cos(theta)*cos(beta) - (lAsisTrocDist + mm)*sin(beta))*pelvis.z;

offset = x+y+z;
% add offsets to the pelvis origin to calculate rhjc location
lhjc.origin = pelvis.origin + offset; % in global coordinates

% Right HJC offset
C = mean(legLength(:))*0.115 - 15.3;

x = (C*cos(theta)*sin(beta) - (rAsisTrocDist + mm)*cos(beta))*pelvis.x;
y = ((C*sin(theta) - aa))*pelvis.y;
z = (-C*cos(theta)*cos(beta) - (rAsisTrocDist + mm)*sin(beta))*pelvis.z;

offset = x+y+z;
% add offsets to the pelvis origin to calculate rhjc location
rhjc.origin = pelvis.origin + offset;  % in global coordinates

% calculate new pelvis origin to be midpoint of LHJC and RHJC
pelvis.origin = (lhjc.origin + rhjc.origin)./2;

% Calculate Hip Joint Coordinate Frame
rhjc.y = pelvis.y; lhjc.y = pelvis.y;
rhjc.x = pelvis.x; lhjc.x = pelvis.x;
rhjc.z = pelvis.z; lhjc.z = pelvis.z;

% ///////////////////////////////////////////////////////////////////////
% Determine Walking Direction
deltaLASI = lasi(end,:) - lasi(1,:);
if deltaLASI(1) - deltaLASI(2) >=0
    if deltaLASI(1) > 0
        dir = 'posX';
    else
        dir = 'negX';
    end
else
    if deltaLASI(2) > 0
        dir = 'posY';
    else
        dir = 'negY';
    end
end
% /////////////////////////////////////////////////////////////////////////

end

function [newJointCenter] = calcJointCenter(jointWidth,segLength,prox,mid,dist,sideFlag)
% jointWidth = measured according to Plug-in Gait requirements
% segLength = segment length
% prox = proximal joint center
% mid = mid-segment marker location
% dist = distal joint marker placement

% Initial Guess: vector from proximal segment to distal marker, offset in
% proximal y-direction by a distance "jointWidth/2"
%{
x0 = prox.origin(1,:) + (segLength/2)*((dist(1,:) - prox.origin(1,:))/sqrt(sum((dist(1,:) - prox.origin(1,:)).^2,2)))...
    + (jointWidth/2)*prox.y(1,:);
%}
segmentLength=segLength;

x0 = prox.origin(1,:) + ((dist(1,:) - prox.origin(1,:)) + (jointWidth/2)*prox.y(1,:));
numOfFrames=size(prox.origin,1);

for i = 1:numOfFrames
    % Calculate new distal joint center position
    newJointCenter.origin(i,:) = runnested(prox.origin(i,:),mid(i,:),dist(i,:),jointWidth,x0);
    x0 = newJointCenter.origin(i,:);
    
    % calculate corresponding coordinate system
    newJointCenter.z(i,:) = (prox.origin(i,:) - newJointCenter.origin(i,:))./...
        norm(prox.origin(i,:) - newJointCenter.origin(i,:)); % vector from distal to proximal joint centers
    
    switch sideFlag
        case 'right'
            %           Vector between joint center and joint marker (y).  Always points to
            %           the LEFT!!
            %             newJointCenter.y(i,:) = (newJointCenter.origin(i,:) - dist(i,:))./mean(vecMag(dist(i,:) - newJointCenter.origin(i,:)),2);
            newJointCenter.x(i,:) = cross(mid(i,:) - prox.origin(i,:),dist(i,:) - prox.origin(i,:))./...
            norm(cross(prox.origin(i,:) - mid(i,:),prox.origin(i,:) - dist(i,:))); % vector orthogonal to plane defined by prox, dist, and mid

        case 'left'
            %             newJointCenter.y(i,:) = (dist(i,:) - newJointCenter.origin(i,:))./mean(vecMag(dist(i,:) - newJointCenter.origin(i,:)),2);
            newJointCenter.x(i,:) = cross(dist(i,:) - prox.origin(i,:),mid(i,:) - prox.origin(i,:))./...
        norm(cross(dist(i,:) - prox.origin(i,:),mid(i,:) - prox.origin(i,:))); % vector orthogonal to plane defined by prox, dist, and mid
    end
    
    %     newJointCenter.x(i,:) = cross(newJointCenter.y(i,:),newJointCenter.z(i,:));
    
    newJointCenter.y(i,:) = cross(newJointCenter.z(i,:),newJointCenter.x(i,:)); % cross product of z and x
end

end

function x = runnested(prox,mid,dist,jointWidth,x0)
% Uses lsqnonlin (nonlinear equation solver) to calculate the position of
% the proximal joint centers.  Uses nested functions to pass constants
% (e.g. marker locations) into the solver
opts1=  optimset('display','off');
x = lsqnonlin(@calcJC,x0,[],[],opts1);
    function y = calcJC(x)
        a = dot(x-prox,x-dist);
        n1 = cross(dist-prox,x-prox);n2 = cross(mid-prox,x-prox);
        b = dot(n1,n2)-norm(n1)*norm(n2)*cosd(0);
        c = norm(x-dist) - jointWidth/2;
        y = [a b c]';
    end
end

function ajcU = calcUntorsionedTibia(ajc,tibialTorsion)
ajcU.origin = ajc.origin;
for i=1:size(ajc.origin,1)
  P = [ajc.x(i,:)', ajc.y(i,:)', ajc.z(i,:)'];
  rz = Rz(tibialTorsion);
  Rg = P*rz;
  
  ajcU.x(i,:)=Rg(:,1)';ajcU.y(i,:)=Rg(:,2)'; ajcU.z(i,:)=Rg(:,3)';
  
end

end

function foot = calcFoot(ajc,toe,kjc,alpha,beta)
for i=1:size(ajc,1)
%  Uncorrected foot
    foot.origin(i,:) = ajc(i,:);
    foot.z(i,:) = (toe(i,:) - ajc(i,:))./norm(toe(i,:)-ajc(i,:));
    foot.y(i,:) = cross(ajc(i,:) - toe(i,:),kjc(i,:) - toe(i,:))./norm(cross(ajc(i,:)-toe(i,:),kjc(i,:)-toe(i,:)));
    %foot.y(i,:) = ajcUy(i,:);
    foot.x(i,:) = cross(foot.y(i,:),foot.z(i,:));
    
  
       % Apply static offset rotations to uncorrected reference frame
        Ry = [1 0 0;0 cosd(alpha) -sind(alpha);0 sind(alpha) cosd(alpha)];
        Rx = [cosd(beta) 0 sind(beta);0 1 0;-sind(beta) 0 cosd(beta)];
        P = [foot.y(i,:)' foot.x(i,:)' foot.z(i,:)']; %why is it y x z?
        Rg = P*Rx'*Ry; % orientation of rotated foot frame in global coordinates
        %Rg = Rx'*Ry*P; % orientation of rotated foot frame in global coordinates
    
%     footref.y(i,:) = Rg(:,1)'; footref.x(i,:) = Rg(:,2)'; footref.z(i,:) = -footref.z(i,:);
      foot.y(i,:) = Rg(:,1)'; foot.x(i,:) = Rg(:,2)'; foot.z(i,:) = Rg(:,3)';
end
end

function EulerAngles = calcEulerAngles(R1,R2,joint,side)
% "Parent Joint" R1
% "Child Joint" R2

% Child relative to parent:
R = R1'*R2;

% Rearrange rotations.  Original:
% rotation about y = FE
% rotation about x = AB/AD
% rotation about z = IE

% New Arrangement:
% alpha about y --> IE
% beta about x --> AB/AD
% gamma about z --> FE
% R = [R(:,1) R(:,3) R(:,2)];

if abs(R(3,1))~=1
    beta1 = -asin(R(2,3));
    beta2 = pi+asin(R(2,3));
    
    alpha1 = atan2(R(2,1)/cos(beta1),R(2,2)/cos(beta1));
    alpha2 = atan2(R(2,1)/cos(beta2),R(2,2)/cos(beta2));
    
    gamma1 = atan2(R(1,3)/cos(beta1),R(3,3)/cos(beta1));
    gamma2 = atan2(R(1,3)/cos(beta2),R(3,3)/cos(beta2));
else
    gamma1 = 0;
    delta = atan2(R(3,1),R(3,2));
    if R(3,1) == -1
        beta1 = pi/2;
        alpha1 = gamma + delta;
    else
        beta1 = -pi/2;
        alpha1 = -gamma+delta;
    end
end
% Euler Angles = [AB/AD IE FE]
if strcmp('Hip',joint)==1
     if strcmp('R', side)==1
         EulerAngles = [beta1 alpha1 gamma2]*180./pi;
     else if strcmp('L',side)==1
             EulerAngles = [beta1 alpha1 gamma2]*180./pi;
         end
     end
     else if strcmp('Knee',joint)==1
             if strcmp('R',side) ==1
                 EulerAngles = [beta1 alpha1 gamma1]*180./pi;
             else if strcmp('L',side)==1
                     EulerAngles = [beta1 -alpha1 gamma1]*180./pi;
                 end
             end
         else if strcmp('Ankle',joint)==1
                 if strcmp('R',side)==1
                     EulerAngles = [beta1 alpha1 gamma1]*180./pi;         
                 else if strcmp ('L',side)==1
                         EulerAngles = [beta1 alpha1 gamma1]*180./pi;
                     end
                 end
             end
         end
 end
end

function KadabaAngles = calcKadabaAngles(R1,R2,joint,side)
I=R1(:,1);
J=R1(:,2);
K=R1(:,3);
I3=R2(:,1);
J3=R2(:,2);
K3=R2(:,3);
%theta1 = flexion/extension
%theta2 = ab/adduction
%theta3 = internal/external rotation
theta2=asin(dot(-K3,J))*180/pi;
theta1=asin(dot(K3,I))*180/pi;
theta3=asin(dot(I3,J))*180/pi;

 %Modify angles according to joint and side
 if strcmp('Hip',joint)==1
     if strcmp('R', side)==1
         KadabaAngles = [theta2 theta3 -theta1];
     else if strcmp('L',side)==1
             KadabaAngles = [-theta2 -theta3 -theta1];
         end
     end
     else if strcmp('Knee',joint)==1
             if strcmp('R',side) ==1
                 KadabaAngles = [theta2 theta3 theta1];
             else if strcmp('L',side)==1
                     KadabaAngles = [-theta2 -theta3 theta1];
                 end
             end
         else if strcmp('Ankle',joint)==1
                 I3=R2(:,3);
                 J3=R2(:,2);
                 K3=R2(:,1);
                 %theta1 = flexion/extension
                 %theta2 = ab/adduction
                 %theta3 = internal/external rotation
                 theta2=asin(dot(-K3,J))*180/pi;
                 theta1=asin(dot(K3,I))*180/pi;
                 theta3=asin(dot(I3,J))*180/pi;
                 if strcmp('R',side)==1
                    % theta1=asin(dot(-I3,I))*180/pi;
                     KadabaAngles = [theta2 theta3 theta1];        
                 else if strcmp ('L',side)==1
                     %    theta1=asin(dot(-I3,I))*180/pi;
                         KadabaAngles = [theta2 -theta3 theta1];
                     end
                 end
             end
         end
 end

end

function GroodAndSuntayAngles = calcGroodAndSuntayAngles(R1,R2,joint,side) %GroodAndSuntayAngles.m addaptation for Vicon 
I=R1(:,1);
J=R1(:,2);
K=R1(:,3);
i=R2(:,1);
j=R2(:,2);
k=R2(:,3);
e1=J;
e3=k;
e2=cross(e1,e3);

%Calculate angles according to Grood and Suntay(1983)
flexion=asin(dot(-e2,K))*180/pi;

beta=acos(dot(J,k))*180/pi;

 if strcmp('R', side)==1
     adduction=beta-90;
 else
     adduction=90-beta;
 end
 
 if strcmp('R', side)==1
     internal=asin(dot(-e2,j))*180/pi;
 else
     internal=asin(dot(e2,j))*180/pi;
 end
 
 %Modify angles according to joint and side
 if strcmp('Hip',joint)==1
     if strcmp('R', side)==1
         GroodAndSuntayAngles = [-adduction internal -flexion];
     else if strcmp('L',side)==1
             GroodAndSuntayAngles = [-adduction internal -flexion];
         end
     end
     else if strcmp('Knee',joint)==1
             if strcmp('R',side) ==1
                 GroodAndSuntayAngles = [-adduction internal flexion];
             else if strcmp('L',side)==1
                     GroodAndSuntayAngles = [-adduction internal flexion];
                 end
             end
         else if strcmp('Ankle',joint)==1
                 i=R2(:,3);
                 j=R2(:,2);
                 k=R2(:,1);
                 e1=J;
                 e3=k;
                 e2=cross(e1,-e3);
                 %Calculate angles according to Grood and Suntay(1983)
                 flexion=asin(dot(-e2,K))*180/pi;
                 beta=acos(dot(J,k))*180/pi;
                 if strcmp('R', side)==1
                     adduction=beta-90;
                 else
                     adduction=90-beta;
                 end
                 
                 if strcmp('R', side)==1
                     internal=asin(dot(-e2,j))*180/pi;
                 else
                     internal=asin(dot(e2,j))*180/pi;
                 end
                 
                 if strcmp('R',side)==1
                     GroodAndSuntayAngles = [-adduction internal -flexion];        
                 else if strcmp ('L',side)==1
                         GroodAndSuntayAngles = [-adduction internal -flexion];
                     end
                 end
             end
         end
 end
end

function angles = calcJointAngles(prox,dist,joint,side)
% prox = proximal joint coordinates
% dist = distal joint coordinates
EulerAngles = zeros(size(prox.origin));
KadabaAngles = zeros(size(prox.origin));
GroodAndSuntayAngles = zeros(size(prox.origin));

for i = 1:size(prox.origin,1)
    %  Rearrange into rotation matrices
    R1 = [prox.x(i,:)' prox.y(i,:)' prox.z(i,:)'];
    R2 = [dist.x(i,:)' dist.y(i,:)' dist.z(i,:)'];
    
    EulerAngles(i,:) = calcEulerAngles(R1,R2,joint,side);
    KadabaAngles(i,:) = calcKadabaAngles(R1,R2,joint,side);
    GroodAndSuntayAngles(i,:) = calcGroodAndSuntayAngles(R1,R2,joint,side);
        
    %    jointAngles = nx3 matrix of joint angles.  n = number of frames
    % column 1 = abduction/adduction; col. 2 = flex/ext; col 3 =
    % internal/external
end
angles{1} = EulerAngles;
angles{2} = KadabaAngles;
angles{3} = GroodAndSuntayAngles;
end

function normVec = vecMag(vec)
normVec = repmat(sqrt(sum(vec.^2,2)),1,3);
end

function walkingMovie(pelvis,lhjc,rhjc,lkjc,rkjc,lajc,rajc,lfoot,rfoot)
% create 2D movie of walking
figure(1)
for i = 1:size(lajc.origin,1)
    % Plot Pelvic Markers
    plot3([pelvis.origin(i,1),lhjc.origin(i,1)],[pelvis.origin(i,2),lhjc.origin(i,2)],[pelvis.origin(i,3) lhjc.origin(i,3)],'ko-','linewidth',2);
    hold on
    plot3([pelvis.origin(i,1),rhjc.origin(i,1)],[pelvis.origin(i,2),rhjc.origin(i,2)],[pelvis.origin(i,3) rhjc.origin(i,3)],'ko-','linewidth',2,'markersize',4);
    quiver3(pelvis.origin(i,1),pelvis.origin(i,2),pelvis.origin(i,3),200*pelvis.z(i,1),200*pelvis.z(i,2),200*pelvis.z(i,3),'b','linewidth',2,'markersize',4);
    quiver3(pelvis.origin(i,1),pelvis.origin(i,2),pelvis.origin(i,3),200*pelvis.y(i,1),200*pelvis.y(i,2),200*pelvis.y(i,3),'g','linewidth',2,'markersize',4);
    quiver3(pelvis.origin(i,1),pelvis.origin(i,2),pelvis.origin(i,3),200*pelvis.x(i,1),200*pelvis.x(i,2),200*pelvis.x(i,3),'r','linewidth',2,'markersize',4);
    
    % Plot Legs
    plot3([lhjc.origin(i,1) lkjc.origin(i,1)],[lhjc.origin(i,2) lkjc.origin(i,2)],[lhjc.origin(i,3) lkjc.origin(i,3)],'ko-','linewidth',2,'markersize',4);
    plot3([lajc.origin(i,1) lkjc.origin(i,1)],[lajc.origin(i,2) lkjc.origin(i,2)],[lajc.origin(i,3) lkjc.origin(i,3)],'ko-','linewidth',2,'markersize',4);
    plot3([rhjc.origin(i,1) rkjc.origin(i,1)],[rhjc.origin(i,2) rkjc.origin(i,2)],[rhjc.origin(i,3) rkjc.origin(i,3)],'ko-','linewidth',2,'markersize',4);
    plot3([rajc.origin(i,1) rkjc.origin(i,1)],[rajc.origin(i,2) rkjc.origin(i,2)],[rajc.origin(i,3) rkjc.origin(i,3)],'ko-','linewidth',2,'markersize',4);
    
    % Plot Feet
    plot3([lfoot.origin(i,1) lajc.origin(i,1)],[lfoot.origin(i,2) lajc.origin(i,2)],[lfoot.origin(i,3) lajc.origin(i,3)],'ko-','linewidth',2,'markersize',4);
    plot3([rfoot.origin(i,1) rajc.origin(i,1)],[rfoot.origin(i,2) rajc.origin(i,2)],[rfoot.origin(i,3) rajc.origin(i,3)],'ko-','linewidth',2,'markersize',4);
    
    % Leg Coordinate Vectors
    quiver3(lhjc.origin(i,1),lhjc.origin(i,2),lhjc.origin(i,3),200*lhjc.x(i,1),200*lhjc.x(i,2),200*lhjc.x(i,3),'r')
    quiver3(lhjc.origin(i,1),lhjc.origin(i,2),lhjc.origin(i,3),200*lhjc.z(i,1),200*lhjc.z(i,2),200*lhjc.z(i,3),'b')
    quiver3(lhjc.origin(i,1),lhjc.origin(i,2),lhjc.origin(i,3),200*lhjc.y(i,1),200*lhjc.y(i,2),200*lhjc.y(i,3),'g')
    quiver3(rhjc.origin(i,1),rhjc.origin(i,2),rhjc.origin(i,3),200*rhjc.x(i,1),200*rhjc.x(i,2),200*rhjc.x(i,3),'r')
    quiver3(rhjc.origin(i,1),rhjc.origin(i,2),rhjc.origin(i,3),200*rhjc.z(i,1),200*rhjc.z(i,2),200*rhjc.z(i,3),'b')
    quiver3(rhjc.origin(i,1),rhjc.origin(i,2),rhjc.origin(i,3),200*rhjc.y(i,1),200*rhjc.y(i,2),200*rhjc.y(i,3),'g')
    
    quiver3(lkjc.origin(i,1),lkjc.origin(i,2),lkjc.origin(i,3),200*lkjc.x(i,1),200*lkjc.x(i,2),200*lkjc.x(i,3),'r')
    quiver3(lkjc.origin(i,1),lkjc.origin(i,2),lkjc.origin(i,3),200*lkjc.z(i,1),200*lkjc.z(i,2),200*lkjc.z(i,3),'b')
    quiver3(lkjc.origin(i,1),lkjc.origin(i,2),lkjc.origin(i,3),200*lkjc.y(i,1),200*lkjc.y(i,2),200*lkjc.y(i,3),'g')
    quiver3(rkjc.origin(i,1),rkjc.origin(i,2),rkjc.origin(i,3),200*rkjc.x(i,1),200*rkjc.x(i,2),200*rkjc.x(i,3),'r')
    quiver3(rkjc.origin(i,1),rkjc.origin(i,2),rkjc.origin(i,3),200*rkjc.z(i,1),200*rkjc.z(i,2),200*rkjc.z(i,3),'b')
    quiver3(rkjc.origin(i,1),rkjc.origin(i,2),rkjc.origin(i,3),200*rkjc.y(i,1),200*rkjc.y(i,2),200*rkjc.y(i,3),'g')
    
    quiver3(lajc.origin(i,1),lajc.origin(i,2),lajc.origin(i,3),200*lajc.x(i,1),200*lajc.x(i,2),200*lajc.x(i,3),'r')
    quiver3(lajc.origin(i,1),lajc.origin(i,2),lajc.origin(i,3),200*lajc.z(i,1),200*lajc.z(i,2),200*lajc.z(i,3),'b')
    quiver3(lajc.origin(i,1),lajc.origin(i,2),lajc.origin(i,3),200*lajc.y(i,1),200*lajc.y(i,2),200*lajc.y(i,3),'g')
    quiver3(rajc.origin(i,1),rajc.origin(i,2),rajc.origin(i,3),200*rajc.x(i,1),200*rajc.x(i,2),200*rajc.x(i,3),'r')
    quiver3(rajc.origin(i,1),rajc.origin(i,2),rajc.origin(i,3),200*rajc.z(i,1),200*rajc.z(i,2),200*rajc.z(i,3),'b')
    quiver3(rajc.origin(i,1),rajc.origin(i,2),rajc.origin(i,3),200*rajc.y(i,1),200*rajc.y(i,2),200*rajc.y(i,3),'g')
      
    % Plot Feet Coord. Vectors
    quiver3(lfoot.origin(i,1),lfoot.origin(i,2),lfoot.origin(i,3),200*lfoot.x(i,1),200*lfoot.x(i,2),200*lfoot.x(i,3),'r')
    quiver3(lfoot.origin(i,1),lfoot.origin(i,2),lfoot.origin(i,3),200*lfoot.z(i,1),200*lfoot.z(i,2),200*lfoot.z(i,3),'b')
    quiver3(lfoot.origin(i,1),lfoot.origin(i,2),lfoot.origin(i,3),200*lfoot.y(i,1),200*lfoot.y(i,2),200*lfoot.y(i,3),'g')
    
    quiver3(rfoot.origin(i,1),rfoot.origin(i,2),rfoot.origin(i,3),200*rfoot.x(i,1),200*rfoot.x(i,2),200*rfoot.x(i,3),'r')
    quiver3(rfoot.origin(i,1),rfoot.origin(i,2),rfoot.origin(i,3),200*rfoot.z(i,1),200*rfoot.z(i,2),200*rfoot.z(i,3),'b')
    quiver3(rfoot.origin(i,1),rfoot.origin(i,2),rfoot.origin(i,3),200*rfoot.y(i,1),200*rfoot.y(i,2),200*rfoot.y(i,3),'g')
    
    hold off
    axis([-1000 1000 -3000 3000 0 1000])
    axis square
    m(i) = getframe;
end


end

function outArray = calcOrientArray(orientStructs)
for i = 1:7
    cellData = struct2cell(orientStructs{i});
    for f = 1:size(cellData{1},1)
        outArray(:,:,f,i) = [cellData{2}(f,:)' cellData{3}(f,:)' cellData{4}(f,:)'];
    end
end

end

