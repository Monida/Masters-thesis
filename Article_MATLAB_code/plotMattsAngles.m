%Get vicon Data
[PathNameVicon,numOfFramesVicon,ViconJointAngles]=getViconData('','');

%Gel calculated orientations 
%For file XsensInsideVsOutside Trial-001
legLength =890;
kneeWidth = 110;
ankleWidth = 70;
interAsisDist = 235;
bodyDimensions=[legLength kneeWidth ankleWidth interAsisDist];
[~,orientArray,angles] = calculateOrientations(bodyDimensions,'');

%plotMattsAngles vs Vicon
ViconAnglesIdx={1:3,4:6,7:9,10:12,13:15,16:18,19:21};
% ViconColumnIdx meaning
%1 = LeftHip
%2 = LeftKnee
%3 = LeftAnkle
%4 = LAbsAnkleAngle
%5 = RightHip
%6 = RightKnee
%7 = RightAnkle

numOfFrames=size(ViconJointAngles,1);
%Plotted in following order
%FE
%IE
%AA
%% left
%Blue = Vicon
%Black = Kadaba
for j=1:3
figure
plot(1:numOfFrames,ViconJointAngles(:,ViconAnglesIdx{j}(:,3)))
hold on
plot(1:numOfFrames,angles{j}{2}(:,3),'black')
plot(1:numOfFrames,ViconJointAngles(:,ViconAnglesIdx{j}(:,3))-angles{j}{2}(:,3),'g')
figure
plot(1:numOfFrames,ViconJointAngles(:,ViconAnglesIdx{j}(:,2)))
hold on
plot(1:numOfFrames,angles{j}{2}(:,2),'black')
plot(1:numOfFrames,ViconJointAngles(:,ViconAnglesIdx{j}(:,2))-angles{j}{2}(:,2),'g')
figure
plot(1:numOfFrames,ViconJointAngles(:,ViconAnglesIdx{j}(:,1)))
hold on
plot(1:numOfFrames,angles{j}{2}(:,1),'black')
plot(1:numOfFrames,ViconJointAngles(:,ViconAnglesIdx{j}(:,1))-angles{j}{2}(:,1),'g')
end

%% Right

for j=4:6
figure
plot(1:numOfFrames,ViconJointAngles(:,ViconAnglesIdx{j+1}(:,3)))
hold on
plot(1:numOfFrames,angles{j}{2}(:,3),'black')
plot(1:numOfFrames,ViconJointAngles(:,ViconAnglesIdx{j+1}(:,3))-angles{j}{2}(:,3),'g')
figure
plot(1:numOfFrames,ViconJointAngles(:,ViconAnglesIdx{j+1}(:,2)))
hold on
plot(1:numOfFrames,angles{j}{2}(:,2),'black')
plot(1:numOfFrames,ViconJointAngles(:,ViconAnglesIdx{j+1}(:,2))-angles{j}{2}(:,2),'g')
figure
plot(1:numOfFrames,ViconJointAngles(:,ViconAnglesIdx{j+1}(:,1)))
hold on
plot(1:numOfFrames,angles{j}{2}(:,1),'black')
plot(1:numOfFrames,ViconJointAngles(:,ViconAnglesIdx{j+1}(:,1))-angles{j}{2}(:,1),'g')
end

%% Plot subplots of Left
%Blue = Vicon
%Black = Kadaba
for j=1:3
subplot (3,1,j)
plot(1:numOfFrames,ViconJointAngles(:,ViconAnglesIdx{j}(:,3)),'k','LineWidth',2)
hold on
plot(1:numOfFrames,angles{j}{2}(:,3),'k','LineStyle',':')
plot(1:numOfFrames,ViconJointAngles(:,ViconAnglesIdx{j}(:,3))-angles{j}{2}(:,3),'g')
end
axis tight
figure
for j=1:3
subplot(3,1,j)
plot(1:numOfFrames,ViconJointAngles(:,ViconAnglesIdx{j}(:,2)),'k','LineWidth',2)
hold on
plot(1:numOfFrames,angles{j}{2}(:,2),'k','LineStyle',':')
plot(1:numOfFrames,ViconJointAngles(:,ViconAnglesIdx{j}(:,2))-angles{j}{2}(:,2),'g')
end
axis tight
figure
for j=1:3
subplot(3,1,j)
plot(1:numOfFrames,ViconJointAngles(:,ViconAnglesIdx{j}(:,1)),'k','LineWidth',2)
hold on
plot(1:numOfFrames,angles{j}{2}(:,1),'k','LineStyle',':')
plot(1:numOfFrames,ViconJointAngles(:,ViconAnglesIdx{j}(:,1))-angles{j}{2}(:,1),'g')
end
axis tight
%% plot Kadaba vs Grood and Suntay
%angles{joint}{2=Kadaba; 3=grood and suntay}

%% left
for j=1:3
figure
plot(1:numOfFrames,angles{j}{3}(:,3))
hold on
plot(1:numOfFrames,angles{j}{2}(:,3),'black')
plot(1:numOfFrames,angles{j}{3}(:,3)-angles{j}{2}(:,3),'g')
figure
plot(1:numOfFrames,angles{j}{3}(:,2))
hold on
plot(1:numOfFrames,angles{j}{2}(:,2),'black')
plot(1:numOfFrames,angles{j}{3}(:,2)-angles{j}{2}(:,2),'g')
figure
plot(1:numOfFrames,angles{j}{3}(:,1))
hold on
plot(1:numOfFrames,angles{j}{2}(:,1),'black')
plot(1:numOfFrames,angles{j}{3}(:,1)-angles{j}{2}(:,1),'g')
end

%% Right

for j=4:6
figure
plot(1:numOfFrames,angles{j}{3}(:,3))
hold on
plot(1:numOfFrames,angles{j}{2}(:,3),'black')
plot(1:numOfFrames,angles{j}{3}(:,3)-angles{j}{2}(:,3),'g')
figure
plot(1:numOfFrames,angles{j}{3}(:,2))
hold on
plot(1:numOfFrames,angles{j}{2}(:,2),'black')
plot(1:numOfFrames,angles{j}{3}(:,2)-angles{j}{2}(:,2),'g')
figure
plot(1:numOfFrames,angles{j}{3}(:,1))
hold on
plot(1:numOfFrames,angles{j}{2}(:,1),'black')
plot(1:numOfFrames,angles{j}{3}(:,1)-angles{j}{2}(:,1),'g')
end

%% Plot subplots of Left Hip
for a=1:3
subplot (3,1,a)
%Grood and suntay
plot(1:numOfFrames,angles{1}{3}(:,a),'black')
hold on
%Kadaba
plot(1:numOfFrames,angles{1}{2}(:,a),'blue')
%DIFF_D
plot(1:numOfFrames,angles{1}{3}(:,a)-angles{1}{2}(:,a),'Color',[108 206 66]/255)
end

%% Normalize gait cycles
 framesR=[229 305 374 444];
 framesL=[268 339 409 483];
 
ViconLAnkle=NormGaitCycles(ViconJointAngles(:,ViconAnglesIdx{3}),framesL);
ViconRAnkle=NormGaitCycles(ViconJointAngles(:,ViconAnglesIdx{7}),framesR);

LAnkle=NormGaitCycles(angles{3}{3},framesL);
RAnkle=NormGaitCycles(angles{6}{3},framesR);


figure
for a=1:3
    subplot(3,1,a)
    for gc=1:3
        plot(1:100,ViconLAnkle{gc}(:,a));
        hold on
        plot(1:100,LAnkle{gc}(:,a),'black');
        hold on
    end
end
figure
for a=1:3
    subplot(3,1,a)
    for gc=1:3
        plot(1:100,ViconRAnkle{gc}(:,a));
        hold on
        plot(1:100,RAnkle{gc}(:,a),'black');
        hold on
    end
end