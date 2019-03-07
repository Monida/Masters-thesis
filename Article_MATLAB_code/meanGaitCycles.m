%Takes the NormGaitData cell array where
%NormGaitData{trial}{gc}(frame,axis)
%and returns the mean across all gait cycles
%gaitDataMean(numOfFrames,axesCount,{1=mean,2=upperLimit,3=lowerLimit})
function gaitDataMean=meanGaitCycles(NormGaitData)
numOfFrames=100; 
trialCount=size(NormGaitData,2);
GaitCycleCount=zeros(trialCount,1);

for t=1:trialCount
    GaitCycleCount(t)=size(NormGaitData{t},2);
end
 
 totalGaitCycleCount=sum(GaitCycleCount); %number of gait cycles in each trial
 axesCount=3;
 p=1;
 
 for t=1:trialCount
     gaitDataCell(p:(GaitCycleCount(t)+(p-1)))=NormGaitData{t};
     p=p+GaitCycleCount(t);
 end
  
 %Transform Cell 2 Array
 gaitDataArray=gaitDataCell{1};
 
 for gc=2:totalGaitCycleCount
     gaitDataArray(:,:,gc)=gaitDataCell{gc};
 end
 
 gaitDataMean=mean(gaitDataArray,3);
 gaitDataDiff=zeros(numOfFrames,axesCount,GaitCycleCount);
 
 for gc=1:GaitCycleCount
     gaitDataDiff(:,:,gc)=(gaitDataArray(:,:,gc)-gaitDataMean).^2;
 end
     gaitDataSum=sum(gaitDataDiff,3);
     gaitDataVar=gaitDataSum/totalGaitCycleCount;
     gaitDataStd=gaitDataVar.^(1/2);
  
%  gaitDataStd=std(gaitDataArray,3);



 %{
 maxGaitData=zeros(numOfFrames,axesCount);
 minGaitData=zeros(numOfFrames,axesCount);
 %Find upper limits
 for a=1:axesCount
     for f=1:numOfFrames
         maxGaitData(f,a)=max(gaitDataArray(f,a,:));
         minGaitData(f,a)=min(gaitDataArray(f,a,:));
     end
 end
 gaitDataMean(:,:,2)=maxGaitData;
 gaitDataMean(:,:,3)=minGaitData;
 %}
 
 gaitDataMean(:,:,2)=gaitDataMean(:,:,1)+gaitDataStd;
 gaitDataMean(:,:,3)=gaitDataMean(:,:,1)-gaitDataStd;
end