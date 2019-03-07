%NormalizeGiatCycles
%Takes UnnormalizedData matrix (a matrix where rows are frames and columns are the joint angles about the 3 axes of all the gait cycles) and 
%frames vector (a vector that contains the beginning and end of each gait
%cycle) and returns a cell NormData whose elements are 100 by 3 matrix (each matrix is a gait cycle whose rows are frames and columns the motion about each of the 3 axis).


function NormData=NormGaitCycles(UnnormalizedData,frames)

%Make sure that UnnormalizedData is longer than the last frame
if length(UnnormalizedData)<frames(length(frames))
frames=frames(1:length(frames)-1);
end

szFrames=size(frames);

%Number of gait cycles in the file
gaitCyclesCount=szFrames(2)-1; 

%To understand algorithm %See LTN.m file for reference
%target number of frames
Nn=100;

%Original;ilu number of frames in each measured trajectory
%Each element of n is the length of each of the gait cycles
n=zeros(1,gaitCyclesCount);

for gc=1:gaitCyclesCount
    n(gc)=(frames(gc+1)-frames(gc))+1;
end

%Extract UnnormalizedData that conform each right Gait Cycle
GC=cell(1,gaitCyclesCount);


for gc=1:gaitCyclesCount
    GC{gc}=UnnormalizedData(frames(gc):frames(gc+1),:);
end

%original time vectors

t=cell(1,gaitCyclesCount);

for gc=1:gaitCyclesCount
    t{gc}=linspace(1,n(gc),n(gc));
end

%new time vectors
Nt=zeros(gaitCyclesCount,Nn);

for gc=1:gaitCyclesCount
    Nt(gc,:)=linspace(1,n(gc),Nn);
end

%y1 data interpolated to n points.

NormData=cell(1,gaitCyclesCount);

axes=3;

for gc=1:gaitCyclesCount
    for a=1:axes
        NormData{gc}(:,a)=interp1(t{gc},GC{gc}(:,a),Nt(gc,:),'linear');
    end
end

end