%Deriv is the mean across gait cycles of the derivative of the difference (Vicon-MVN) 
%Deriv variable is a structure where
%Deriv.raw is a 100X3 matrix; framesXplane 
%frames = 99
%Deriv.meanstd is a 2X3 matrix; [mean across gait cycles and then across frames; std across frames of the mean across gait cycles]
%RSref is a Matrix that contains the values of all the frames of all gait
%cycles of a given reference experimental condition from reference recording system
%RS nonideal is a Matrix that contains the values of all the frames of all
%gait cycles of a given experimental condition from recording system to be
%compared to the reference recording system


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