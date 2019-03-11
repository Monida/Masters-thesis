%Compare Experimental Data to Reference
%This MATLAB file imports the experimental data and compares it to the Reference.
%You can use this file to plot compare and analyze different gait data

%% 1 Extract Vicon and Xsens Data
%{
%% Align Signals
%% Uncoment this section when you need to alignSignals
%We Do Knee First becuase is the easiest one to find delay, and the rest
%can have the same delay
[RKneeRef, RKneeComp] = alignSignals(ViconJointAngles(:,16:18),XsensJointAngles(:,XsensJointsColumnIdx{16}));
[LKneeRef, LKneeComp] = alignSignals(ViconJointAngles(:,4:6),XsensJointAngles(:,XsensJointsColumnIdx{20}));

[RHipRef,RHipComp] = alignSignals(ViconJointAngles(:,13:15),XsensJointAngles(:,XsensJointsColumnIdx{15}));
[LHipRef,LHipComp] = alignSignals(ViconJointAngles(:,1:3),XsensJointAngles(:,XsensJointsColumnIdx{19}));

[RAnkleRef,RAnkleComp] = alignSignals(ViconJointAngles(:,19:21),XsensJointAngles(:,XsensJointsColumnIdx{17}));
[LAnkleRef,LAnkleComp] = alignSignals(ViconJointAngles(:,7:9),XsensJointAngles(:,XsensJointsColumnIdx{21}));
%}


%% Indicate ExperimentalCondition
ExperimentalCondition='BK+BKW';
trialCount=3;
%% Select the first folder corresponding to that ExperimentalCondition
    %MAKE SURE THAT THE FILES ARE STORED WITH THE NAMEFORMAT: Trial-001,...,Trial-010,...Trial-020, etc.
    %So that when using dir to import the files they are in order
    [FileNameXsens,PathNameXsens,~] = uigetfile('.mvnx');
    listXsens=dir(strcat(PathNameXsens,'*.mvnx'));
    filesCountXsens=length(listXsens);
    
    [FileNameVicon,PathNameVicon,~] = uigetfile('.csv');
    listVicon=dir(strcat(PathNameVicon,'*.csv'));
    filesCountVicon=length(listVicon);
    
    %Identify the file where the trials for this Experimental condition
    %starts
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
   
%Get Vicon Data 
FileNameVicon=listVicon((startFileVicon-1)+t).name;
[~,~,ViconJointAngles]=getViconData(PathNameVicon,FileNameVicon);

filename=strcat(PathNameXsens,'Frames.xlsx');
trial=t;

[framesR,framesL]=findFrame(filename,ExperimentalCondition,trial);

%Normalize ViconJointAngles

NormRHipVic{t}=NormGaitCycles(ViconJointAngles(:,13:15),framesR.');
NormLHipVic{t}=NormGaitCycles(ViconJointAngles(:,1:3),framesL.');

NormRKneeVic{t}=NormGaitCycles(ViconJointAngles(:,16:18),framesR.');
NormLKneeVic{t}=NormGaitCycles(ViconJointAngles(:,4:6),framesL.');

NormRAnkleVic{t}=NormGaitCycles(ViconJointAngles(:,19:21),framesR.');
NormLAnkleVic{t}=NormGaitCycles(ViconJointAngles(:,7:9),framesL.');


%Get Xsens Data
   FileNameXsens=listXsens((startFileXsens-1)+t).name;
   [PathNameXsens,~,~,~,XsensJointAngles]=getXsensData(PathNameXsens,FileNameXsens);
   XsensJointsColumnIdx={1:3;4:6;7:9;10:12;13:15;16:18;19:21;22:24;25:27;28:30;31:33;34:36;37:39;40:42;43:45;46:48;49:51;52:54;55:57;58:60;61:63;64:66};
   
filename=strcat(PathNameXsens,'Frames.xlsx');
trial=t;

%% Align Xsens data to Vicon Data based on knee angle

%Make the signals the same length
% XsensJointAngles=XsensJointAngles(1:size(ViconJointAngles,1),:);

%Extract just the knee angles to do the alignment
s1R=ViconJointAngles(:,18)-mean(ViconJointAngles(:,18));
s2R=XsensJointAngles(:,XsensJointsColumnIdx{16}(3))-mean(XsensJointAngles(:,XsensJointsColumnIdx{16}(3)));
s1L=ViconJointAngles(:,6)-mean(ViconJointAngles(:,6));
s2L=XsensJointAngles(:,XsensJointsColumnIdx{20}(3))-mean(XsensJointAngles(:,XsensJointsColumnIdx{20}(3)));

gcLength=70;

[acor,lag]=xcorr(s1R,s2R);
inds = abs(lag) <= gcLength;    % limits the lags to be within one gait
                                % cycle of the start of x1

lag2 = lag(inds);               % select the lag values of interest
acor2 = acor(inds);             % select the corresponding xcorr values

[~,I] = max(abs(acor2));        % identify the maximum xcorr value within
                                % the range-of-interest
delay = lag2(I); 

if delay>0
    XsensJointAnglesR=[zeros(delay,size(XsensJointAngles,2));XsensJointAngles];
else if delay<0
        XsensJointAnglesR=XsensJointAngles(abs(delay)+1:end,:);
    end
end
% 
% figure,plot(s1R)                                    
% hold,plot(XsensJointAnglesR(:,XsensJointsColumnIdx{16}(3)),'r')

[acor,lag]=xcorr(s1L,s2L);
inds = abs(lag) <= gcLength;    % limits the lags to be within one gait
                                % cycle of the start of x1

lag2 = lag(inds);               % select the lag values of interest
acor2 = acor(inds);             % select the corresponding xcorr values

[~,I] = max(abs(acor2));        % identify the maximum xcorr value within
                                % the range-of-interest

delay = lag2(I); 

if delay>0
    XsensJointAnglesL=[zeros(delay,size(XsensJointAngles,2));XsensJointAngles];
else if delay<0
        XsensJointAnglesL=XsensJointAngles(abs(delay)+1:end,:);
    end
end
% 
% figure,plot(s1L)                                    
% hold,plot(XsensJointAnglesL(:,XsensJointsColumnIdx{20}(3)),'r')

% Normalize XsensJointAngles
   NormRHipRef{t}=NormGaitCycles(XsensJointAnglesR(:,XsensJointsColumnIdx{15}),framesR.');
   NormLHipRef{t}=NormGaitCycles(XsensJointAnglesL(:,XsensJointsColumnIdx{19}),framesL.');
   
   NormRKneeRef{t}=NormGaitCycles(XsensJointAnglesR(:,XsensJointsColumnIdx{16}),framesR.');
   NormLKneeRef{t}=NormGaitCycles(XsensJointAnglesL(:,XsensJointsColumnIdx{20}),framesL.');
   
   NormRAnkleRef{t}=NormGaitCycles(XsensJointAnglesR(:,XsensJointsColumnIdx{17}),framesR.');
   NormLAnkleRef{t}=NormGaitCycles(XsensJointAnglesL(:,XsensJointsColumnIdx{21}),framesL.');   
   
   %% Align Corrected data to Vicon Data based on knee angle
   
CorrectedAnglesColumnIdx={1:3;4:6;7:9;10:12;13:15;16:18};   
%Extract just the knee angles to do the alignment
s1R=ViconJointAngles(:,18)-mean(ViconJointAngles(:,18));
s2R=CorrectedAngles{t}(:,CorrectedAnglesColumnIdx{2}(3))-mean(CorrectedAngles{t}(:,CorrectedAnglesColumnIdx{2}(3)));
s1L=ViconJointAngles(:,6)-mean(ViconJointAngles(:,6));
s2L=CorrectedAngles{t}(:,CorrectedAnglesColumnIdx{5}(3))-mean(CorrectedAngles{t}(:,CorrectedAnglesColumnIdx{5}(3)));

gcLength=70;

[acor,lag]=xcorr(s1R,s2R);
inds = abs(lag) <= gcLength;    % limits the lags to be within one gait
                                % cycle of the start of x1

lag2 = lag(inds);               % select the lag values of interest
acor2 = acor(inds);             % select the corresponding xcorr values

[~,I] = max(abs(acor2));        % identify the maximum xcorr value within
                                % the range-of-interest
delay = lag2(I); 

if delay>0
    CorrectedAnglesR=[zeros(delay,size(CorrectedAngles{t},2));CorrectedAngles{t}];
else if delay<0
        CorrectedAnglesR=CorrectedAngles{t}(abs(delay)+1:end,:);
    end
end

% figure,plot(s1R)                                    
% hold on
% plot(CorrectedAnglesR(:,CorrectedAnglesColumnIdx{2}(3)),'r')

[acor,lag]=xcorr(s1L,s2L);
inds = abs(lag) <= gcLength;    % limits the lags to be within one gait
                                % cycle of the start of x1

lag2 = lag(inds);               % select the lag values of interest
acor2 = acor(inds);             % select the corresponding xcorr values

[~,I] = max(abs(acor2));        % identify the maximum xcorr value within
                                % the range-of-interest

delay = lag2(I); 

if delay>0
    CorrectedAnglesL=[zeros(delay,size(CorrectedAngles{t},2));CorrectedAngles{t}];
else if delay<0
        CorrectedAnglesL=CorrectedAngles{t}(abs(delay)+1:end,:);
    end
end

% figure,plot(s1L)                                    
% hold on
% plot(CorrectedAnglesL(:,CorrectedAnglesColumnIdx{5}(3)),'r')

% Normalize CorrectedAngles
   NormRHipCorr{t}=NormGaitCycles(CorrectedAnglesR(:,CorrectedAnglesColumnIdx{1}),framesR.');
   NormLHipCorr{t}=NormGaitCycles(CorrectedAnglesL(:,CorrectedAnglesColumnIdx{4}),framesL.');
   
   NormRKneeCorr{t}=NormGaitCycles(CorrectedAnglesR(:,CorrectedAnglesColumnIdx{2}),framesR.');
   NormLKneeCorr{t}=NormGaitCycles(CorrectedAnglesL(:,CorrectedAnglesColumnIdx{5}),framesL.');
   
   NormRAnkleCorr{t}=NormGaitCycles(CorrectedAnglesR(:,CorrectedAnglesColumnIdx{3}),framesR.');
   NormLAnkleCorr{t}=NormGaitCycles(CorrectedAnglesL(:,CorrectedAnglesColumnIdx{6}),framesL.');
     
 end

%% Select the folder for The NPose Trial

    %MAKE SURE THAT THE FILES ARE STORED WITH THE NAME FORMAT: Trial-001,...,Trial-010,...Trial-020, etc.
    %So that when using dir to import the files they are in order
    ExperimentalCondition='NPose+NW';
    [FileNameXsens,PathNameXsens,~] = uigetfile('.mvnx');
    listXsens=dir(strcat(PathNameXsens,'*.mvnx'));
    filesCountXsens=length(listXsens);
    trialCount=3;
    
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

%Get Vicon Data 
FileNameVicon=listVicon((startFileVicon-1)+t).name;
[~,~,ViconJointAngles]=getViconData(PathNameVicon,FileNameVicon);

filename=strcat(PathNameXsens,'Frames.xlsx');
trial=t;

[framesR,framesL]=findFrame(filename,ExperimentalCondition,trial);

NormRHipVicR{t}=NormGaitCycles(ViconJointAngles(:,13:15),framesR.');
NormLHipVicR{t}=NormGaitCycles(ViconJointAngles(:,1:3),framesL.');

NormRKneeVicR{t}=NormGaitCycles(ViconJointAngles(:,16:18),framesR.');
NormLKneeVicR{t}=NormGaitCycles(ViconJointAngles(:,4:6),framesL.');

NormRAnkleVicR{t}=NormGaitCycles(ViconJointAngles(:,19:21),framesR.');
NormLAnkleVicR{t}=NormGaitCycles(ViconJointAngles(:,7:9),framesL.');

%Get Xsens Data
    FileNameXsens=listXsens((startFileXsens-1)+t).name;
   [PathNameXsens,~,~,~,XsensJointAngles]=getXsensData(PathNameXsens,FileNameXsens);
   XsensJointsColumnIdx={1:3;4:6;7:9;10:12;13:15;16:18;19:21;22:24;25:27;28:30;31:33;34:36;37:39;40:42;43:45;46:48;49:51;52:54;55:57;58:60;61:63;64:66};
   
filename=strcat(PathNameXsens,'Frames.xlsx');
trial=t;

%% Align Xsens data to Vicon Data based on knee angle

%Make the signals the same length
XsensJointAngles=XsensJointAngles(1:size(ViconJointAngles,1),:);

%Extract just the knee angles to do the alignment
s1R=ViconJointAngles(:,18)-mean(ViconJointAngles(:,18));
s2R=XsensJointAngles(:,XsensJointsColumnIdx{16}(3))-mean(XsensJointAngles(:,XsensJointsColumnIdx{16}(3)));
s1L=ViconJointAngles(:,6)-mean(ViconJointAngles(:,6));
s2L=XsensJointAngles(:,XsensJointsColumnIdx{20}(3))-mean(XsensJointAngles(:,XsensJointsColumnIdx{20}(3)));

gcLength=70;

[acor,lag]=xcorr(s1R,s2R);
inds = abs(lag) <= gcLength;    % limits the lags to be within one gait
                                % cycle of the start of x1

lag2 = lag(inds);               % select the lag values of interest
acor2 = acor(inds);             % select the corresponding xcorr values

[~,I] = max(abs(acor2));        % identify the maximum xcorr value within
                                % the range-of-interest
delay = lag2(I); 

if delay>0
    XsensJointAnglesR=[zeros(delay,size(XsensJointAngles,2));s2R];
else if delay<0
        XsensJointAnglesR=XsensJointAngles(abs(delay)+1:end,:);
    end
end
% 
% figure,plot(s1R)                                    
% hold,plot(XsensJointAnglesR(:,XsensJointsColumnIdx{16}(3)),'r')

[acor,lag]=xcorr(s1L,s2L);
inds = abs(lag) <= gcLength;    % limits the lags to be within one gait
                                % cycle of the start of x1

lag2 = lag(inds);               % select the lag values of interest
acor2 = acor(inds);             % select the corresponding xcorr values

[~,I] = max(abs(acor2));        % identify the maximum xcorr value within
                                % the range-of-interest

delay = lag2(I); 

if delay>0
    XsensJointAnglesL=[zeros(delay,size(XsensJointAngles,2));s2L];
else if delay<0
        XsensJointAnglesL=XsensJointAngles(abs(delay)+1:end,:);
    end
end
% 
% figure,plot(s1L)                                    
% hold,plot(XsensJointAnglesL(:,XsensJointsColumnIdx{20}(3)),'r')


% Normalize gait cycles

NormRHipComp{t}=NormGaitCycles(XsensJointAnglesR(:,XsensJointsColumnIdx{15}),framesR.');
NormLHipComp{t}=NormGaitCycles(XsensJointAnglesL(:,XsensJointsColumnIdx{19}),framesL.');

NormRKneeComp{t}=NormGaitCycles(XsensJointAnglesR(:,XsensJointsColumnIdx{16}),framesR.');
NormLKneeComp{t}=NormGaitCycles(XsensJointAnglesL(:,XsensJointsColumnIdx{20}),framesL.');

NormRAnkleComp{t}=NormGaitCycles(XsensJointAnglesR(:,XsensJointsColumnIdx{17}),framesR.');
NormLAnkleComp{t}=NormGaitCycles(XsensJointAnglesL(:,XsensJointsColumnIdx{21}),framesL.');    
   
end

    %% Change the sign of AA Xsens (Ref) and XsensCorrected (Corr) angles
%This is done because when calculating the angles AA Xsens Angles and AA
%Vicon Angles are inverse from each other, 
%therefore we multiply AA Ref and Corr angles (-1) to match them to AA Xsens
%angles
%Norm variable is a 1X3 cell with substructure {1 2 3}{1 2 GC}(100,3);
%where {trial}{gait cycle}(frame, plane)
NormRHipRef=neg(NormRHipRef);
NormLHipRef=neg(NormLHipRef);
        
NormRKneeRef=neg(NormRKneeRef);
NormLKneeRef=neg(NormLKneeRef);

NormRAnkleRef=neg(NormRAnkleRef);
NormLAnkleRef=neg(NormLAnkleRef);

NormRHipCorr=neg(NormRHipCorr);
NormLHipCorr=neg(NormLHipCorr);

NormRKneeCorr=neg(NormRKneeCorr);
NormLKneeCorr=neg(NormLKneeCorr);

NormRAnkleCorr=neg(NormRAnkleCorr);
NormLAnkleCorr=neg(NormLAnkleCorr);

NormRHipComp=neg(NormRHipComp);
NormLHipComp=neg(NormLHipComp);

NormRKneeComp=neg(NormRKneeComp);
NormLKneeComp=neg(NormLKneeComp);

NormRAnkleComp=neg(NormRAnkleComp);
NormLAnkleComp=neg(NormLAnkleComp);


%% Find means
%Returns and array gaitDataMean(numOfFrames,axesCount,{1=mean,2=upperLimit,3=lowerLimit})
%Mean variables are a 100X3X3 array; frameXplaneX(mean,+sd,-sd)
MeanRHipVic=meanGaitCycles(NormRHipVic);
MeanLHipVic=meanGaitCycles(NormLHipVic);
MeanRKneeVic=meanGaitCycles(NormRKneeVic);
MeanLKneeVic=meanGaitCycles(NormLKneeVic);
MeanRAnkleVic=meanGaitCycles(NormRAnkleVic);
MeanLAnkleVic=meanGaitCycles(NormLAnkleVic);

MeanRHipRef=meanGaitCycles(NormRHipRef);
MeanLHipRef=meanGaitCycles(NormLHipRef);
MeanRKneeRef=meanGaitCycles(NormRKneeRef);
MeanLKneeRef=meanGaitCycles(NormLKneeRef);
MeanRAnkleRef=meanGaitCycles(NormRAnkleRef);
MeanLAnkleRef=meanGaitCycles(NormLAnkleRef);

MeanRHipCorr=meanGaitCycles(NormRHipCorr);
MeanLHipCorr=meanGaitCycles(NormLHipCorr);
MeanRKneeCorr=meanGaitCycles(NormRKneeCorr);
MeanLKneeCorr=meanGaitCycles(NormLKneeCorr);
MeanRAnkleCorr=meanGaitCycles(NormRAnkleCorr);
MeanLAnkleCorr=meanGaitCycles(NormLAnkleCorr);

MeanRHipComp=meanGaitCycles(NormRHipComp);
MeanLHipComp=meanGaitCycles(NormLHipComp);
MeanRKneeComp=meanGaitCycles(NormRKneeComp);
MeanLKneeComp=meanGaitCycles(NormLKneeComp);
MeanRAnkleComp=meanGaitCycles(NormRAnkleComp);
MeanLAnkleComp=meanGaitCycles(NormLAnkleComp);


MeanRHipVicR=meanGaitCycles(NormRHipVicR);
MeanLHipVicR=meanGaitCycles(NormLHipVicR);
MeanRKneeVicR=meanGaitCycles(NormRKneeVicR);
MeanLKneeVicR=meanGaitCycles(NormLKneeVicR);
MeanRAnkleVicR=meanGaitCycles(NormRAnkleVicR);
MeanLAnkleVicR=meanGaitCycles(NormLAnkleVicR);
%}

%% Find difference vector (just for plotting purposes)
%DIFF variables are a 100X3X3 array; frameXplaneX(mean,+sd,-sd)

DIFFRHipVicRef=MeanRHipVic-MeanRHipRef;
DIFFRKneeVicRef=MeanRKneeVic-MeanRKneeRef;
DIFFRAnkleVicRef=MeanRAnkleVic-MeanRAnkleRef;
DIFFLHipVicRef=MeanLHipVic-MeanLHipRef;
DIFFLKneeVicRef=MeanLKneeVic-MeanLKneeRef;
DIFFLAnkleVicRef=MeanLAnkleVic-MeanLAnkleRef;

DIFFRHipVicCorr=MeanRHipVic-MeanRHipCorr;
DIFFRKneeVicCorr=MeanRKneeVic-MeanRKneeCorr;
DIFFRAnkleVicCorr=MeanRAnkleVic-MeanRAnkleCorr;
DIFFLHipVicCorr=MeanLHipVic-MeanLHipCorr;
DIFFLKneeVicCorr=MeanLKneeVic-MeanLKneeCorr;
DIFFLAnkleVicCorr=MeanLAnkleVic-MeanLAnkleCorr;

% DIFFRHipVicComp=MeanRHipVic-MeanRHipComp;
% DIFFRKneeVicComp=MeanRKneeVic-MeanRKneeComp;
% DIFFRAnkleVicComp=MeanRAnkleVic-MeanRAnkleComp;
% DIFFLHipVicComp=MeanLHipVic-MeanLHipComp;
% DIFFLKneeVicComp=MeanLKneeVic-MeanLKneeComp;
% DIFFLAnkleVicComp=MeanLAnkleVic-MeanLAnkleComp;
% 
% DIFFRHipVicRRef=MeanRHipVicR-MeanRHipRef;
% DIFFRKneeVicRRef=MeanRKneeVicR-MeanRKneeRef;
% DIFFRAnkleVicRRef=MeanRAnkleVicR-MeanRAnkleRef;
% DIFFLHipVicRRef=MeanLHipVicR-MeanLHipRef;
% DIFFLKneeVicRRef=MeanLKneeVicR-MeanLKneeRef;
% DIFFLAnkleVicRRef=MeanLAnkleVicR-MeanLAnkleRef;

DIFFRHipVicRComp=MeanRHipVicR-MeanRHipComp;
DIFFRKneeVicRComp=MeanRKneeVicR-MeanRKneeComp;
DIFFRAnkleVicRComp=MeanRAnkleVicR-MeanRAnkleComp;
DIFFLHipVicRComp=MeanLHipVicR-MeanLHipComp;
DIFFLKneeVicRComp=MeanLKneeVicR-MeanLKneeComp;
DIFFLAnkleVicRComp=MeanLAnkleVicR-MeanLAnkleComp;

%{
DIFFRHipRefComp=MeanRHipRef-MeanRHipComp;
DIFFRKneeRefComp=MeanRKneeRef-MeanRKneeComp;
DIFFRAnkleRefComp=MeanRAnkleRef-MeanRAnkleComp;
DIFFLHipRefComp=MeanLHipRef-MeanLHipComp;
DIFFLKneeRefComp=MeanLKneeRef-MeanLKneeComp;
DIFFLAnkleRefComp=MeanLAnkleRef-MeanLAnkleComp;

%}
%% Find normalized difference mean and SD
%DiffNorm variable is a structure where
%DiffNorm.raw is a 100X3 matrix; framesXplane; mean across gait cycles of the normalized difference (Vic-Ref)/Vic
%DiffNorm.meanstd is a 2X3 matrix; [mean across gait cycles and then across frames; std across frames of the mean across gait cycles]

DiffNormRHipVicRef=differGaitCyclesNorm(NormRHipVic,NormRHipRef);
DiffNormRKneeVicRef=differGaitCyclesNorm(NormRKneeVic,NormRKneeRef);
DiffNormRAnkleVicRef=differGaitCyclesNorm(NormRAnkleVic,NormRAnkleRef);
DiffNormLHipVicRef=differGaitCyclesNorm(NormLHipVic,NormLHipRef);
DiffNormLKneeVicRef=differGaitCyclesNorm(NormLKneeVic,NormLKneeRef);
DiffNormLAnkleVicRef=differGaitCyclesNorm(NormLAnkleVic,NormLAnkleRef);
DiffVicRef=[DiffRHipVicRef.meanstd' DiffLHipVicRef.meanstd'; DiffRKneeVicRef.meanstd' DiffLKneeVicRef.meanstd'; DiffRAnkleVicRef.meanstd' DiffLAnkleVicRef.meanstd'];
DiffVicRefRaw=[DiffRHipVicRef.raw DiffRKneeVicRef.raw DiffRAnkleVicRef.raw DiffLHipVicRef.raw DiffLKneeVicRef.raw DiffLAnkleVicRef.raw];

DiffNormRHipVicCorr=differGaitCyclesNorm(NormRHipVic,NormRHipCorr);
DiffNormRKneeVicCorr=differGaitCyclesNorm(NormRKneeVic,NormRKneeCorr);
DiffNormRAnkleVicCorr=differGaitCyclesNorm(NormRAnkleVic,NormRAnkleCorr);
DiffNormLHipVicCorr=differGaitCyclesNorm(NormLHipVic,NormLHipCorr);
DiffNormLKneeVicCorr=differGaitCyclesNorm(NormLKneeVic,NormLKneeCorr);
DiffNormLAnkleVicCorr=differGaitCyclesNorm(NormLAnkleVic,NormLAnkleCorr);
DiffVicCorr=[DiffRHipVicCorr.meanstd' DiffLHipVicCorr.meanstd'; DiffRKneeVicCorr.meanstd' DiffLKneeVicCorr.meanstd'; DiffRAnkleVicCorr.meanstd' DiffLAnkleVicCorr.meanstd'];
DiffVicCorrRaw=[DiffRHipVicCorr.raw DiffRKneeVicCorr.raw DiffRAnkleVicCorr.raw DiffLHipVicCorr.raw DiffLKneeVicCorr.raw DiffLAnkleVicCorr.raw];

DiffNormRHipVicRComp=differGaitCyclesNorm(NormRHipVicR,NormRHipComp);
DiffNormRKneeVicRComp=differGaitCyclesNorm(NormRKneeVicR,NormRKneeComp);
DiffNormRAnkleVicRComp=differGaitCyclesNorm(NormRAnkleVicR,NormRAnkleComp);
DiffNormLHipVicRComp=differGaitCyclesNorm(NormLHipVicR,NormLHipComp);
DiffNormLKneeVicRComp=differGaitCyclesNorm(NormLKneeVicR,NormLKneeComp);
DiffNormLAnkleVicRComp=differGaitCyclesNorm(NormLAnkleVicR,NormLAnkleComp);
DiffVicRComp=[DiffRHipVicRComp.meanstd' DiffLHipVicRComp.meanstd'; DiffRKneeVicRComp.meanstd' DiffLKneeVicRComp.meanstd'; DiffRAnkleVicRComp.meanstd' DiffLAnkleVicRComp.meanstd'];
DiffVicRCompRaw=[DiffRHipVicRComp.raw DiffRKneeVicRComp.raw DiffRAnkleVicRComp.raw DiffLHipVicRComp.raw DiffLKneeVicRComp.raw DiffLAnkleVicRComp.raw];

%% Find difference mean and SD
%Diff is the non-normalized difference Vic-Ref
%Diff variables is a structure where
%Diff.raw is a 100X3 matrix; framesXplane
%Diff.meanstd is a 2X3 matrix; [mean across gait cycles and then across frames; std across frames of the mean across gait cycles]

DiffRHipVicRef=differGaitCycles(NormRHipVic,NormRHipRef);
DiffRKneeVicRef=differGaitCycles(NormRKneeVic,NormRKneeRef);
DiffRAnkleVicRef=differGaitCycles(NormRAnkleVic,NormRAnkleRef);
DiffLHipVicRef=differGaitCycles(NormLHipVic,NormLHipRef);
DiffLKneeVicRef=differGaitCycles(NormLKneeVic,NormLKneeRef);
DiffLAnkleVicRef=differGaitCycles(NormLAnkleVic,NormLAnkleRef);
DiffVicRef=[DiffRHipVicRef.meanstd' DiffLHipVicRef.meanstd'; DiffRKneeVicRef.meanstd' DiffLKneeVicRef.meanstd'; DiffRAnkleVicRef.meanstd' DiffLAnkleVicRef.meanstd'];
DiffVicRefRaw=[DiffRHipVicRef.raw DiffRKneeVicRef.raw DiffRAnkleVicRef.raw DiffLHipVicRef.raw DiffLKneeVicRef.raw DiffLAnkleVicRef.raw];

DiffRHipVicCorr=differGaitCycles(NormRHipVic,NormRHipCorr);
DiffRKneeVicCorr=differGaitCycles(NormRKneeVic,NormRKneeCorr);
DiffRAnkleVicCorr=differGaitCycles(NormRAnkleVic,NormRAnkleCorr);
DiffLHipVicCorr=differGaitCycles(NormLHipVic,NormLHipCorr);
DiffLKneeVicCorr=differGaitCycles(NormLKneeVic,NormLKneeCorr);
DiffLAnkleVicCorr=differGaitCycles(NormLAnkleVic,NormLAnkleCorr);
DiffVicCorr=[DiffRHipVicCorr.meanstd' DiffLHipVicCorr.meanstd'; DiffRKneeVicCorr.meanstd' DiffLKneeVicCorr.meanstd'; DiffRAnkleVicCorr.meanstd' DiffLAnkleVicCorr.meanstd'];
DiffVicCorrRaw=[DiffRHipVicCorr.raw DiffRKneeVicCorr.raw DiffRAnkleVicCorr.raw DiffLHipVicCorr.raw DiffLKneeVicCorr.raw DiffLAnkleVicCorr.raw];

DiffRHipVicRComp=differGaitCycles(NormRHipVicR,NormRHipComp);
DiffRKneeVicRComp=differGaitCycles(NormRKneeVicR,NormRKneeComp);
DiffRAnkleVicRComp=differGaitCycles(NormRAnkleVicR,NormRAnkleComp);
DiffLHipVicRComp=differGaitCycles(NormLHipVicR,NormLHipComp);
DiffLKneeVicRComp=differGaitCycles(NormLKneeVicR,NormLKneeComp);
DiffLAnkleVicRComp=differGaitCycles(NormLAnkleVicR,NormLAnkleComp);
DiffVicRComp=[DiffRHipVicRComp.meanstd' DiffLHipVicRComp.meanstd'; DiffRKneeVicRComp.meanstd' DiffLKneeVicRComp.meanstd'; DiffRAnkleVicRComp.meanstd' DiffLAnkleVicRComp.meanstd'];
DiffVicRCompRaw=[DiffRHipVicRComp.raw DiffRKneeVicRComp.raw DiffRAnkleVicRComp.raw DiffLHipVicRComp.raw DiffLKneeVicRComp.raw DiffLAnkleVicRComp.raw];



%{
DiffRHipRefComp=differGaitCycles(NormRHipRef,NormRHipComp);
DiffRKneeRefComp=differGaitCycles(NormRKneeRef,NormRKneeComp);
DiffRAnkleRefComp=differGaitCycles(NormRAnkleRef,NormRAnkleComp);
DiffLHipRefComp=differGaitCycles(NormLHipRef,NormLHipComp);
DiffLKneeRefComp=differGaitCycles(NormLKneeRef,NormLKneeComp);
DiffLAnkleRefComp=differGaitCycles(NormLAnkleRef,NormLAnkleComp);
DiffRefComp=[DiffRHipRefComp.meanstd' DiffLHipRefComp.meanstd'; DiffRKneeRefComp.meanstd' DiffLKneeRefComp.meanstd'; DiffRAnkleRefComp.meanstd' DiffLAnkleRefComp.meanstd'];
DiffRefCompRaw=[DiffRHipRefComp.raw DiffRKneeRefComp.raw DiffRAnkleRefComp.raw DiffLHipRefComp.raw DiffLKneeRefComp.raw DiffLAnkleRefComp.raw];
%}
%% Find the derivative of the difference
DerivRHipVicRef=Deriv(NormRHipVic,NormRHipRef);
DerivRKneeVicRef=Deriv(NormRKneeVic,NormRKneeRef);
DerivRAnkleVicRef=Deriv(NormRAnkleVic,NormRAnkleRef);
DerivLHipVicRef=Deriv(NormLHipVic,NormLHipRef);
DerivLKneeVicRef=Deriv(NormLKneeVic,NormLKneeRef);
DerivLAnkleVicRef=Deriv(NormLAnkleVic,NormLAnkleRef);
DerivVicRef=[DerivRHipVicRef.meanstd' DerivLHipVicRef.meanstd'; DerivRKneeVicRef.meanstd' DerivLKneeVicRef.meanstd'; DerivRAnkleVicRef.meanstd' DerivLAnkleVicRef.meanstd'];
DerivVicRefRaw=[DerivRHipVicRef.raw DerivRKneeVicRef.raw DerivRAnkleVicRef.raw DerivLHipVicRef.raw DerivLKneeVicRef.raw DerivLAnkleVicRef.raw];

DerivRHipVicCorr=Deriv(NormRHipVic,NormRHipCorr);
DerivRKneeVicCorr=Deriv(NormRKneeVic,NormRKneeCorr);
DerivRAnkleVicCorr=Deriv(NormRAnkleVic,NormRAnkleCorr);
DerivLHipVicCorr=Deriv(NormLHipVic,NormLHipCorr);
DerivLKneeVicCorr=Deriv(NormLKneeVic,NormLKneeCorr);
DerivLAnkleVicCorr=Deriv(NormLAnkleVic,NormLAnkleCorr);
DerivVicCorr=[DerivRHipVicCorr.meanstd' DerivLHipVicCorr.meanstd'; DerivRKneeVicCorr.meanstd' DerivLKneeVicCorr.meanstd'; DerivRAnkleVicCorr.meanstd' DerivLAnkleVicCorr.meanstd'];
DerivVicCorrRaw=[DerivRHipVicCorr.raw DerivRKneeVicCorr.raw DerivRAnkleVicCorr.raw DerivLHipVicCorr.raw DerivLKneeVicCorr.raw DerivLAnkleVicCorr.raw];

DerivRHipVicRComp=Deriv(NormRHipVicR,NormRHipComp);
DerivLAnkleVicRComp=Deriv(NormLAnkleVicR,NormLAnkleComp);
DerivVicRComp=[DerivRHipVicRComp.meanstd' DerivLHipVicRComp.meanstd'; DerivRKneeVicRComp.meanstd' DerivLKneeVicRComp.meanstd'; DerivRAnkleVicRComp.meanstd' DerivLAnkleVicRComp.meanstd'];
DerivVicRCompRaw=[DerivRHipVicRComp.raw DerivRKneeVicRComp.raw DerivRAnkleVicRComp.raw DerivLHipVicRComp.raw DerivLKneeVicRComp.raw DerivLAnkleVicRComp.raw];
%{
DerivRHipRefComp=Deriv(NormRHipRef,NormRHipComp);
DerivRKneeRefComp=Deriv(NormRKneeRef,NormRKneeComp);
DerivRAnkleRefComp=Deriv(NormRAnkleRef,NormRAnkleComp);
DerivLHipRefComp=Deriv(NormLHipRef,NormLHipComp);
DerivLKneeRefComp=Deriv(NormLKneeRef,NormLKneeComp);
DerivLAnkleRefComp=Deriv(NormLAnkleRef,NormLAnkleComp);
DerivRefComp=[DerivRHipRefComp' DerivLHipRefComp'; DerivRKneeRefComp' DerivLKneeRefComp'; DerivRAnkleRefComp' DerivLAnkleRefComp'];
DerivRefCompRaw=[DerivRHipRefComp.raw DerivRKneeRefComp.raw DerivRAnkleRefComp.raw DerivLHipRefComp.raw DerivLKneeRefComp.raw DerivLAnkleRefComp.raw];
%}
%% Find CMC WD
%{
CMCwdRHipVicRef=cmc_wd(NormRHipVic,NormRHipRef);
CMCwdRKneeVicRef=cmc_wd(NormRKneeVic,NormRKneeRef);
CMCwdRAnkleVicRef=cmc_wd(NormRAnkleVic,NormRAnkleRef);
CMCwdLHipVicRef=cmc_wd(NormLHipVic,NormLHipRef);
DerivRKneeVicRComp=Deriv(NormRKneeVicR,NormRKneeComp);
DerivRAnkleVicRComp=Deriv(NormRAnkleVicR,NormRAnkleComp);
DerivLHipVicRComp=Deriv(NormLHipVicR,NormLHipComp);
DerivLKneeVicRComp=Deriv(NormLKneeVicR,NormLKneeComp);
CMCwdLKneeVicRef=cmc_wd(NormLKneeVic,NormLKneeRef);
CMCwdLAnkleVicRef=cmc_wd(NormLAnkleVic,NormLAnkleRef);
CMCwdVicRef=[CMCwdRHipVicRef' CMCwdLHipVicRef'; CMCwdRKneeVicRef' CMCwdLKneeVicRef'; CMCwdRAnkleVicRef' CMCwdLAnkleVicRef'];

CMCwdRHipVicCorr=cmc_wd(NormRHipVic,NormRHipCorr);
CMCwdRKneeVicCorr=cmc_wd(NormRKneeVic,NormRKneeCorr);
CMCwdRAnkleVicCorr=cmc_wd(NormRAnkleVic,NormRAnkleCorr);
CMCwdLHipVicCorr=cmc_wd(NormLHipVic,NormLHipCorr);
CMCwdLKneeVicCorr=cmc_wd(NormLKneeVic,NormLKneeCorr);
CMCwdLAnkleVicCorr=cmc_wd(NormLAnkleVic,NormLAnkleCorr);
CMCwdVicCorr=[CMCwdRHipVicCorr' CMCwdLHipVicCorr'; CMCwdRKneeVicCorr' CMCwdLKneeVicCorr'; CMCwdRAnkleVicCorr' CMCwdLAnkleVicCorr'];


CMCwdRHipVicComp=cmc_wd(NormRHipVic,NormRHipComp);
CMCwdRKneeVicComp=cmc_wd(NormRKneeVic,NormRKneeComp);
CMCwdRAnkleVicComp=cmc_wd(NormRAnkleVic,NormRAnkleComp);
CMCwdLHipVicComp=cmc_wd(NormLHipVic,NormLHipComp);
CMCwdLKneeVicComp=cmc_wd(NormLKneeVic,NormLKneeComp);
CMCwdLAnkleVicComp=cmc_wd(NormLAnkleVic,NormLAnkleComp);
CMCwdVicComp=[CMCwdRHipVicComp' CMCwdLHipVicComp'; CMCwdRKneeVicComp' CMCwdLKneeVicComp'; CMCwdRAnkleVicComp' CMCwdLAnkleVicComp'];

CMCwdRHipRefComp=cmc_wd(NormRHipRef,NormRHipComp);
CMCwdRKneeRefComp=cmc_wd(NormRKneeRef,NormRKneeComp);
CMCwdRAnkleRefComp=cmc_wd(NormRAnkleRef,NormRAnkleComp);
CMCwdLHipRefComp=cmc_wd(NormLHipRef,NormLHipComp);
CMCwdLKneeRefComp=cmc_wd(NormLKneeRef,NormLKneeComp);
CMCwdLAnkleRefComp=cmc_wd(NormLAnkleRef,NormLAnkleComp);
CMCwdRefComp=[CMCwdRHipRefComp' CMCwdLHipRefComp'; CMCwdRKneeRefComp' CMCwdLKneeRefComp'; CMCwdRAnkleRefComp' CMCwdLAnkleRefComp'];
%}

%% Find CMC IP
%CMC variable is a 1X3 matrix; 1Xplane
CMCRHipVicRef=cmc(NormRHipVic,NormRHipRef);
CMCRKneeVicRef=cmc(NormRKneeVic,NormRKneeRef);
CMCRAnkleVicRef=cmc(NormRAnkleVic,NormRAnkleRef);
CMCLHipVicRef=cmc(NormLHipVic,NormLHipRef);
CMCLKneeVicRef=cmc(NormLKneeVic,NormLKneeRef);
CMCLAnkleVicRef=cmc(NormLAnkleVic,NormLAnkleRef);
CMCVicRef=[CMCRHipVicRef' CMCLHipVicRef'; CMCRKneeVicRef' CMCLKneeVicRef'; CMCRAnkleVicRef' CMCLAnkleVicRef'];

CMCRHipVicCorr=cmc(NormRHipVic,NormRHipCorr);
CMCRKneeVicCorr=cmc(NormRKneeVic,NormRKneeCorr);
CMCRAnkleVicCorr=cmc(NormRAnkleVic,NormRAnkleCorr);
CMCLHipVicCorr=cmc(NormLHipVic,NormLHipCorr);
CMCLKneeVicCorr=cmc(NormLKneeVic,NormLKneeCorr);
CMCLAnkleVicCorr=cmc(NormLAnkleVic,NormLAnkleCorr);
CMCVicCorr=[CMCRHipVicCorr' CMCLHipVicCorr'; CMCRKneeVicCorr' CMCLKneeVicCorr'; CMCRAnkleVicCorr' CMCLAnkleVicCorr'];

CMCRHipVicRComp=cmc(NormRHipVicR,NormRHipComp);
CMCRKneeVicRComp=cmc(NormRKneeVicR,NormRKneeComp);
CMCRAnkleVicRComp=cmc(NormRAnkleVicR,NormRAnkleComp);
CMCLHipVicRComp=cmc(NormLHipVicR,NormLHipComp);
CMCLKneeVicRComp=cmc(NormLKneeVicR,NormLKneeComp);
CMCLAnkleVicRComp=cmc(NormLAnkleVicR,NormLAnkleComp);
CMCVicRComp=[CMCRHipVicRComp' CMCLHipVicRComp'; CMCRKneeVicRComp' CMCLKneeVicRComp'; CMCRAnkleVicRComp' CMCLAnkleVicRComp'];

%% Cell differences
%DiffCell is the difference between two kinematic data variables of all gait
%cycles
%DiffCell variable is a 1X3 cell with substructure {1 2 3}{1 2 GC}(100,3);
%where {trial}{gait cycle}(frame, plane)

DiffCellRHipVicRef=differenceCell(NormRHipVic,NormRHipRef);
DiffCellRKneeVicRef=differenceCell(NormRKneeVic,NormRKneeRef);
DiffCellRAnkleVicRef=differenceCell(NormRAnkleVic,NormRAnkleRef);
DiffCellLHipVicRef=differenceCell(NormLHipVic,NormLHipRef);
DiffCellLKneeVicRef=differenceCell(NormLKneeVic,NormLKneeRef);
DiffCellLAnkleVicRef=differenceCell(NormLAnkleVic,NormLAnkleRef);

DiffCellRHipVicCorr=differenceCell(NormRHipVic,NormRHipCorr);
DiffCellRKneeVicCorr=differenceCell(NormRKneeVic,NormRKneeCorr);
DiffCellRAnkleVicCorr=differenceCell(NormRAnkleVic,NormRAnkleCorr);
DiffCellLHipVicCorr=differenceCell(NormLHipVic,NormLHipCorr);
DiffCellLKneeVicCorr=differenceCell(NormLKneeVic,NormLKneeCorr);
DiffCellLAnkleVicCorr=differenceCell(NormLAnkleVic,NormLAnkleCorr);

DiffCellRHipVicRComp=differenceCell(NormRHipVicR,NormRHipComp);
DiffCellRKneeVicRComp=differenceCell(NormRKneeVicR,NormRKneeComp);
DiffCellRAnkleVicRComp=differenceCell(NormRAnkleVicR,NormRAnkleComp);
DiffCellLHipVicRComp=differenceCell(NormLHipVicR,NormLHipComp);
DiffCellLKneeVicRComp=differenceCell(NormLKneeVicR,NormLKneeComp);
DiffCellLAnkleVicRComp=differenceCell(NormLAnkleVicR,NormLAnkleComp);

%% Baseline error vs Postural error
% CMCError is the CMC values between two difference-type data
% CMCError variable is a 1X3 matrix; 1Xplane
CMCLHipBaseError=cmcError(DiffCellRHipVicRComp,DiffCellRHipVicRef);
CMCLKneeBaseError=cmcError(DiffCellRKneeVicRComp,DiffCellRKneeVicRef);
CMCLAnkleBaseError=cmcError(DiffCellRAnkleVicRComp,DiffCellRAnkleVicRef);
CMCRHipBaseError=cmcError(DiffCellRHipVicRComp,DiffCellRHipVicRef);
CMCRKneeBaseError=cmcError(DiffCellRKneeVicRComp,DiffCellRKneeVicRef);
CMCRAnkleBaseError=cmcError(DiffCellRAnkleVicRComp,DiffCellRAnkleVicRef);
CMCBaseError=[CMCRHipBaseError' CMCLHipBaseError'; CMCRKneeBaseError' CMCLKneeBaseError'; CMCRAnkleBaseError' CMCLAnkleBaseError'];

%% Baseline error vs OC error
% CMCError is the CMC values between two difference-type data
% CMCError variable is a 1X3 matrix; 1Xplane
CMCLHipOC=cmcError(DiffCellRHipVicRComp,DiffCellRHipVicCorr);
CMCLKneeOC=cmcError(DiffCellRKneeVicRComp,DiffCellRKneeVicCorr);
CMCLAnkleOC=cmcError(DiffCellRAnkleVicRComp,DiffCellRAnkleVicCorr);
CMCRHipOC=cmcError(DiffCellRHipVicRComp,DiffCellRHipVicCorr);
CMCRKneeOC=cmcError(DiffCellRKneeVicRComp,DiffCellRKneeVicCorr);
CMCRAnkleOC=cmcError(DiffCellRAnkleVicRComp,DiffCellRAnkleVicCorr);
CMCBaseOC=[CMCRHipOC' CMCLHipOC'; CMCRKneeOC' CMCLKneeOC'; CMCRAnkleOC' CMCLAnkleOC'];

%% Baseline error vs PAC error
% CMCError is the CMC values between two difference-type data
% CMCError variable is a 1X3 matrix; 1Xplane
CMCLHipPAC=cmcError(DiffCellRHipVicRComp,DiffCellRHipVicCorr);
CMCLKneePAC=cmcError(DiffCellRKneeVicRComp,DiffCellRKneeVicCorr);
CMCLAnklePAC=cmcError(DiffCellRAnkleVicRComp,DiffCellRAnkleVicCorr);
CMCRHipPAC=cmcError(DiffCellRHipVicRComp,DiffCellRHipVicCorr);
CMCRKneePAC=cmcError(DiffCellRKneeVicRComp,DiffCellRKneeVicCorr);
CMCRAnklePAC=cmcError(DiffCellRAnkleVicRComp,DiffCellRAnkleVicCorr);
CMCBasePAC=[CMCRHipPAC' CMCLHipPAC'; CMCRKneePAC' CMCLKneePAC'; CMCRAnklePAC' CMCLAnklePAC'];
