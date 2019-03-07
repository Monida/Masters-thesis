%CMC  Within Day
%Ferrari et. al Jan, (2010)
function CMC=cmc_wd(RSref,RS)
 F=100; %number of frames
 S=2; %number of recording systmes
 %number of waveforms
 trialCount=size(RSref,2);
 GaitCycleCount=size(RSref{1},2);
 W=trialCount*GaitCycleCount; %number of trials times the number of cycles in each file
 axes=3;
 
 %Reorganize RSref and RS
 for t=1:trialCount
     Y1((t*GaitCycleCount)-(GaitCycleCount-1):t*GaitCycleCount)=RSref{t};
     Y2((t*GaitCycleCount)-(GaitCycleCount-1):t*GaitCycleCount)=RS{t};
 end

 %Transform Cell 2 Array
 Ys1wf=Y1{1};
 Ys2wf=Y2{1};
 
 for w=2:W
     Ys1wf(:,:,w)=Y1{w};
     Ys2wf(:,:,w)=Y2{w};
 end
 
 %Find means
 meanYs1f=mean(Ys1wf,3);
 meanYs2f=mean(Ys2wf,3);
 
 meanYs1=mean(meanYs1f,1);
 meanYs2=mean(meanYs2f,1);
 
 %Find numerator
 for w=1:W
     for f=1:F
         numDiffSqrt1(f,:,w)=(Ys1wf(f,:,w)-meanYs1f(f,:)).^2;
         numDiffSqrt2(f,:,w)=(Ys2wf(f,:,w)-meanYs2f(f,:)).^2;
     end
 end
 
 sumaNum=sum([sum(numDiffSqrt1,1); sum(numDiffSqrt2,1)],3);
 numerator=sum(sumaNum,1)/(S*F*(W-1));
 
%Find denominator

for w=1:W
     for f=1:F
         denDiffSqrt1(f,:,w)=(Ys1wf(f,:,w)-meanYs1).^2;
         denDiffSqrt2(f,:,w)=(Ys2wf(f,:,w)-meanYs2).^2;
     end
end
 sumaDen=sum([sum(denDiffSqrt1,1); sum(denDiffSqrt2,1)],3);
 denominator=sum(sumaDen,1)/(S*(F*W-1));
 
 CMC=sqrt(1-(numerator./denominator));
end