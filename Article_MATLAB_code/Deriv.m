function DerivStruct=Deriv(RSref,RS)
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
 %differenciate each gait cycle
 diffy=zeros(F-1,axes,totalGaitCycleCount);
 for gc=1:totalGaitCycleCount
     for f=1:F-1
         diffy(f,:,gc)=differ(f+1,:,gc)-differ(f,:,gc);
     end
 end
 DerivStruct.raw=(mean(diffy,3));
 DerivStruct.meanstd=[mean(mean(diffy,3));std(mean(diffy,3))];
end