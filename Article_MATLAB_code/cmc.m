% Returns CMC1 and CMC2 (after removing offset)
%RSref is a Matrix that contains the values of all the frames of all gait
%cycles of a given reference experimental condition from reference recording system
%RS nonideal is a Matrix that contains the values of all the frames of all
%gait cycles of a given experimental condition from recording system to be
%compared to the reference recording system
%{
function [CMC1,CMC2]=cmc(RSref,RS) %W1: matrix containing waveforms of recording system1 w2: matrix containing waveforme of recording system2 
R=2; %number of recording systems
%CMC Between Gait Cycle
G=2; %number of gait cycles
Frg1=80; %number of frames measured for the gth gait cycle (RgaitCycle1)
Frg2=71; %number of frames measured for the gth gait cycle (RgaitCycle2)
Flg1=82; %number of frames measured for the gth gait cycle (LgaitCycle1)
Flg2=75; %number of frames measured for the gth gait cycle (LgaitCycle2)
%Note: It can also be a vector [length(x1) length (x2) length(x3) length (x4)]

%Ygrf: ordinate at frame f of the average provided by recording system r at gait cycle g
Yrg1=W1(1);
Yrg2=W1(2);
Ylg1=
Ylg2=
%}
function CMC = cmc(RSref,RS) 
 F=100; %number of frames
 P=2; %number of recording systmes
 %number of waveforms
 numOfTrial=size(RSref,2);
 numOfGC=size(RSref{1},2);
 axes=3;
 
  for t=1:numOfTrial
    numOfGC(t)=size(RSref{t},2);
 end
 
 GC=sum(numOfGC); %number of files times the number of cycles in each file
 p=1;
 
 %Reorganize RSref and RS
  for t=1:numOfTrial
     Y1(p:(numOfGC(t)+(p-1)))=RSref{t};
     Y2(p:(numOfGC(t)+(p-1)))=RS{t};
     p=p+numOfGC(t);
 end
  

 %Transform Cell 2 Array
 
 %Ordinate at frame f of the waveform provided by protocol P at gait cycle
 %g
 Ygp1f=Y1{1};
 Ygp2f=Y2{1};

 for gc=2:GC
     Ygp1f(:,:,gc)=Y1{gc};
     Ygp2f(:,:,gc)=Y2{gc};
 end
 
  %Zero signals
 MeanFunc1=mean(Ygp1f,1);
 MeanFunc2=mean(Ygp2f,1);
 
 for gc=1:GC
     for f=1:F
         Ygp1f(f,:,gc)=Ygp1f(f,:,gc)-MeanFunc1(1,:,gc);
         Ygp2f(f,:,gc)=Ygp2f(f,:,gc)-MeanFunc2(1,:,gc);
     end
 end
 
 
 %Find means
 meanYgf=(Ygp1f+Ygp2f)/2;
 
 meanYg=mean(meanYgf,1);
 
 %Find numerator
  for gc=1:GC
     for f=1:F
         numDiffSqrt1(f,:,gc)=(Ygp1f(f,:,gc)-meanYgf(f,:,gc)).^2;
         numDiffSqrt2(f,:,gc)=(Ygp2f(f,:,gc)-meanYgf(f,:,gc)).^2;
     end
  end
  
numerator=sum((sum(numDiffSqrt1,1)+sum(numDiffSqrt2,1))./(GC*F*(P-1)),3);


%Find denominator
for gc=1:GC
     for f=1:F
         denDiffSqrt1(f,:,gc)=(Ygp1f(f,:,gc)-meanYg(:,:,gc)).^2;
         denDiffSqrt2(f,:,gc)=(Ygp2f(f,:,gc)-meanYg(:,:,gc)).^2;
     end
 end

denominator=sum((sum(denDiffSqrt1,1)+sum(denDiffSqrt2,1))./(GC*(F*P-1)),3);

% CMC=real(sqrt(1-(numerator./denominator)));
CMC=sqrt(1-(numerator./denominator));

end %End of function





