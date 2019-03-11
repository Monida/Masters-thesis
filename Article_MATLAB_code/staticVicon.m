function [ tibialTorsion,alpha,beta] = staticVicon(bodyDimensions,PathName,FileName)
%This function takes the Vicon position Data and returns tibialTorsion and alpha and beta angles to further calculate the body
%segments orientations based on Vicon data
%% 1. Read in Excel file containing Marker Positions, Joint Angles.  Unpack measurements
if isempty(PathName)==1
    [FileNameVicon,PathNameVicon,~] = uigetfile('.csv');
    filename=strcat(PathNameVicon,FileNameVicon);
else
    filename=strcat(PathName,FileName);
end
[posData,~] = readAndSeparate(filename);
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

% Unpack body measurements
legLength = ones(1,2)*legLength;

%% 3. Define Fixed Values (i.e. Pelvis and hip joint centers)
[lhjc,rhjc,pelvis] = calcFixedAngles(legLength,lasi,rasi,lpsi,rpsi,interAsisDist);

% left knee joint
lkjc = calcJointCenter(-kneeWidth,legLength(1),lhjc,lthi,lkne,'left');

% right knee joint
rkjc = calcJointCenter(kneeWidth,legLength(2),rhjc,rthi,rkne,'right');

% left ankle joint - torsioned tibia
lajc = calcJointCenter(ankleWidth,legLength(1),lkjc,ltib,lank,'left');

% To calculate untorsioned tibia
% 1. Calculate torsioned tibia the same way thigh is calculated
% 2. Find tibial torsion degrees. 
% 3. Use tibial torsion degrees to rotate the torsioned tibia around its z
% axis.

tibialTorsion(1)= calcTibialTorsion(lkjc.y,lajc.y);


% untorsioned
lajcU.origin = lajc.origin;
lajcU.z = lajc.z; % vector from AJC to KJC, same as torsioned
lajcU.x = lkjc.x; % normal to plane defined by HJC,THI,KJC... same as knee!
lajcU.y = cross(lajcU.z,lajcU.x); % cross product between ankle z and x

% right ankle joint - torsioned tibia
rajc = calcJointCenter(ankleWidth,legLength(2),rkjc,rtib,rank,'right');

tibialTorsion(2)=calcTibialTorsion(rkjc.y,rajc.y);

% untorsioned
rajcU.origin = rajc.origin;
rajcU.z = rajc.z; % vector from AJC to KJC, same as torsioned
rajcU.x = rkjc.x; % normal to plane defined by HJC,THI,KJC... same as knee!
rajcU.y = cross(rajcU.z,rajcU.x); % cross product between ankle z and x

% foot
% left foot
[lfoot,lalpha,lbeta] = calcFoot(lajc.origin,lhee,ltoe,lkjc.origin,lajcU.y,1);

% right foot
[rfoot,ralpha,rbeta] = calcFoot(rajc.origin,rhee,rtoe,rkjc.origin,rajcU.y,1);

alpha=[lalpha ralpha];
beta=[lbeta rbeta];

end
% \\\\\\\\\\\\\\\\\\\\\\\\\\\\SUB FUNCTIONS\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
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

rowEnd=0;
while isnan(num(row,1))==0 && row<size(num,1)
    frame=frame+1;
    row=row+1;
end
if rowEnd==0
    rowEnd=rowStart;
else
    rowEnd=row-1;
end

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

function tibialTorsion = calcTibialTorsion(kjc,ajc)
tibTor=zeros(size(ajc,1),1);
for i=1:size(ajc,1)
    tibTor(i)=acos(dot(kjc(i,:),ajc(i,:)))*180/pi;
end
tibialTorsion=mean(tibTor);
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

function [foot,alpha,beta] = calcFoot(ajc,heel,toe,kjc,ajcUy,flatFlag)
% This code does not include the case where sole delta is different than
% zero
for i = 1:size(toe,1)%size(toe,1)= number of frames
    switch flatFlag % Flat Foot Option.  0 = No, 1 = Yes. In this case is 1 because we calibrate with feet flat on ground
        case 1 %Sole Delta = 0
            rf(1) = ajc(i,1);
            rf(2) = ajc(i,2);
            rf(3) = toe(i,3); %rf is the Heel marker moved along the global Zaxis to be the same height as TOE.
    
        case 0
            rf = heel(i,:);
    end
    
    
%  Define foot static reference frame z-axis
    footref.z(i,:) = (toe(i,:) - rf)./norm(toe(i,:)-rf);
    y = ajcUy(i,:);
    footref.x(i,:) = cross(footref.z(i,:),-y); %-y to get the desired direction of x as a result of the cross product
    footref.y(i,:) = cross(footref.x(i,:),footref.z(i,:));
    
%  Uncorrected foot
    foot.origin(i,:) = ajc(i,:);
    foot.z(i,:) = (toe(i,:) - ajc(i,:))./norm(toe(i,:)-ajc(i,:));
    foot.y(i,:) = cross(ajc(i,:) - toe(i,:),kjc(i,:) - toe(i,:))./norm(cross(ajc(i,:)-toe(i,:),kjc(i,:)-toe(i,:)));
    %foot.y(i,:) = ajcUy(i,:);
    foot.x(i,:) = cross(foot.y(i,:),foot.z(i,:));
    
    
        % Calculate Static Offsets:
        % 1. Plantar-Flexion Offset, alpha
        [alpha,projZ,~] = projAndCalcAngle(footref.z(i,:),foot.z(i,:),foot.y(i,:));
    
        % 2. Foot Rotation Offset, beta
        tempNorm = cross(projZ,foot.y(i,:));
        [beta,~,~] = projAndCalcAngle(footref.z(i,:),foot.z(i,:),tempNorm);
    
        % Apply static offset rotations to uncorrected reference frame
        Ry = [1 0 0;0 cosd(alpha) -sind(alpha);0 sind(alpha) cosd(alpha)];
        Rx = [cosd(beta) 0 sind(beta);0 1 0;-sind(beta) 0 cosd(beta)];
        P = [foot.y(i,:)' foot.x(i,:)' foot.z(i,:)']; %why is it y x z?
        Rg = P*Rx'*Ry; % orientation of rotated foot frame in global coordinates
    
%     footref.y(i,:) = Rg(:,1)'; footref.x(i,:) = Rg(:,2)'; footref.z(i,:) = -footref.z(i,:);
      foot.y(i,:) = Rg(:,1)'; foot.x(i,:) = Rg(:,2)'; foot.z(i,:) = Rg(:,3)';
end

end

function [ang,proj1,proj2] = projAndCalcAngle(vec1,vec2,planeNorm)
% Projects Vector 1 and Vector 2 onto the plane defined by normal
% vector planeNorm, then finds the angle between the two vectors
proj1 = vec1 - dot(vec1,planeNorm)./mean(vecMag(planeNorm))^2 * planeNorm;
proj1 = proj1./vecMag(proj1);

proj2 = vec2 - dot(vec2,planeNorm)./mean(vecMag(planeNorm))^2 * planeNorm;
proj2 = proj2./vecMag(proj2);

ang = acos(dot(proj1,proj2))*180/pi;
end

function normVec = vecMag(vec)
normVec = repmat(sqrt(sum(vec.^2,2)),1,3);
end

