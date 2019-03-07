%Returns the mean and std accross gait cycles of the difference between
%each gait cycle of the both recording systems
%Takes the NormGaitData of the reference Recording System(RSref) and the other
%recording system (RS) where
%RSref{trial}{gc}(frame,axis)

function [DIFFStruct]=differGaitCycles(RSref,RS)
F=100; 
trialCount=size(RSref,2);
 GaitCycleCount=size(RSref{1},2);
 axes=3;
 
 for t=1:trialCount
    GaitCycleCount(t)=size(RSref{t},2);
 end

totalGaitCycleCount=sum(GaitCycleCount); %number of gait cycles in each trial
  
p=1;
 
  for t=1:trialCount
     Yref(p:(GaitCycleCount(t)+(p-1)))=RSref{t};
     Y(p:(GaitCycleCount(t)+(p-1)))=RS{t};
     p=p+GaitCycleCount(t);
 end
 
 %Transform Cell 2 Array
 fref=Yref{1};
 f=Y{1};
 
 for gc=2:totalGaitCycleCount
     fref(:,:,gc)=Yref{gc};
     f(:,:,gc)=Y{gc};
 end
  
differ=fref-f;
DIFF=[mean(mean(differ,3));std(mean(differ,3))];
DIFFStruct.raw=mean(differ,3);
DIFFStruct.meanstd=DIFF;

end



