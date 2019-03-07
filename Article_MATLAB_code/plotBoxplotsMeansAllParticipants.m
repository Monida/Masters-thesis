% Plot difference means for all participants
%For Vic Uncorrected OC and PAC
% rightMeans=xlsread('C:\Users\gomezorozcom\Dropbox\Thesis\Results\Summary Results.xlsx','DiffVicRefNPose-BK','B33:AK36');
% rightStds=xlsread('C:\Users\gomezorozcom\Dropbox\Thesis\Results\Summary Results.xlsx','DiffVicRefNPose-BK','B42:AK45');
% leftMeans=xlsread('C:\Users\gomezorozcom\Dropbox\Thesis\Results\Summary Results.xlsx','DiffVicRefNPose-BK','B52:AK55');
% leftStds=xlsread('C:\Users\gomezorozcom\Dropbox\Thesis\Results\Summary Results.xlsx','DiffVicRefNPose-BK','B61:AK64');

%For Vic Uncorrected and PAC and PAC-Photos
rightMeans=xlsread('C:\Users\gomezorozcom\Dropbox\Thesis\Results\Summary Results.xlsx','DiffVicRefNPose-BK','B72:AK74');
rightStds=xlsread('C:\Users\gomezorozcom\Dropbox\Thesis\Results\Summary Results.xlsx','DiffVicRefNPose-BK','B79:AK81');
leftMeans=xlsread('C:\Users\gomezorozcom\Dropbox\Thesis\Results\Summary Results.xlsx','DiffVicRefNPose-BK','B87:AK89');
leftStds=xlsread('C:\Users\gomezorozcom\Dropbox\Thesis\Results\Summary Results.xlsx','DiffVicRefNPose-BK','B94:AK96');

%For Vic Uncorrected only
% rightMeans=xlsread('C:\Users\gomezorozcom\Dropbox\Thesis\Results\Summary Results.xlsx','DiffVicRefNPose-BK','B33:AK36');
% rightStds=xlsread('C:\Users\gomezorozcom\Dropbox\Thesis\Results\Summary Results.xlsx','DiffVicRefNPose-BK','B42:AK43');
% leftMeans=xlsread('C:\Users\gomezorozcom\Dropbox\Thesis\Results\Summary Results.xlsx','DiffVicRefNPose-BK','B52:AK53');
% leftStds=xlsread('C:\Users\gomezorozcom\Dropbox\Thesis\Results\Summary Results.xlsx','DiffVicRefNPose-BK','B61:AK62');

red=[192 0 0]/255;
green=[108 206 66]/255;
purple=[136 49 143]/255;
orange=[221 114 26]/255;
blue=[92 128 208]/255;

participantCount=3;
groupNames={'1','2','3','4'};
axesCount=3;
columnIdx={1:4,5:8,9:12,13:16,17:20,21:24,25:28,29:32,33:36};
titles={'Abd - Add','Ext - Int','Ext - Flex'};
Joint={'Hip (degrees)';'Knee (degrees)';'Ankle (degrees)'};
sup=suptitle('Mean and std (DIFF_D) of all participants (Right)');
set(sup,'FontSize', 25)
%% Plot

% RHip
for a=1:axesCount
    subplot(3,3,a)
    handles = barweb(rightMeans(:,columnIdx{a})', rightStds(:,columnIdx{a})', [], groupNames, [], [], [], [], [], [], [], []);
    tit=title(titles{a});
    if a==1
        joint=ylabel(Joint(1));
        set(joint,'FontSize',14)
    end
    
    set(tit,'FontSize',14)
    set(gca,'FontSize',12)
end

% RKnee
for a=1:axesCount
    subplot(3,3,a+3)
    handles = barweb(rightMeans(:,columnIdx{a+3})', rightStds(:,columnIdx{a+3})', [], groupNames, [], [], [], [], [], [], [], []);
    if a==1
        joint=ylabel(Joint(2));
        set(joint,'FontSize',14)
    end 
    set(gca,'FontSize',12)
end

% RAnkle
for a=1:axesCount
    subplot(3,3,a+6)
    handles = barweb(rightMeans(:,columnIdx{a+6})', rightStds(:,columnIdx{a+6})', [], groupNames, [], [], [], [], [], [], [], []);
    
    ID=xlabel('Participant ID');
    if a==1
        joint=ylabel(Joint(3));
        set(joint,'FontSize',14)
    end
    set(ID,'FontSize',14)  
    set(gca,'FontSize',12)
end

%% Lengend

text('String','    -  Ideal Calibration',...
    'Position',[110 80 0],...
    'FontSize',16,...
    'EdgeColor',[0 0 0],...
    'Color',green,...
    'BackgroundColor',[1 1 1]);
text('String','    -  Crouch Gait (Uncorrected)',...
    'Position',[110 80 0],...
    'FontSize',16,...
    'EdgeColor',[0 0 0],...
    'Color',blue,...
    'BackgroundColor',[1 1 1]);
text('String','    -  OC',...
    'Position',[110 65 0],...
    'FontSize',16,...
    'EdgeColor',[0 0 0],...
    'Color',orange,...
    'BackgroundColor',[1 1 1]);
text('String','    -  PAC',...
    'Position',[110 65 0],...
    'FontSize',16,...
    'EdgeColor',[0 0 0],...
    'Color',purple,...
    'BackgroundColor',[1 1 1]);