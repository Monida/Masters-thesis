%From Grood and Suntay (1983)
function angles=GroodSuntayAngles(Rp,Rd,joint,side)
%Rp = Rotation matrix of proximal segment
%Rd = Rotation matrix of distal segment
I=Rp(:,1);
J=Rp(:,2);
K=Rp(:,3);
i=Rd(:,1);
j=Rd(:,2);
k=Rd(:,3);
e1=J;
e3=k;
e2=cross(e1,e3);

%Calculate angles according to Grood and Suntay(1983)
flexion=asin(dot(-e2,K))*180/pi;

beta=acos(dot(J,k))*180/pi;

 if strcmp('R', side)==1
     adduction=beta-90;
 else
     adduction=90-beta;
 end
 
 if strcmp('R', side)==1
     internal=asin(dot(-e2,j))*180/pi;
 else
     internal=asin(dot(e2,j))*180/pi;
 end
 
 %Modify angles according to joint and side
 if strcmp('Hip',joint)==1
     if strcmp('R', side)==1
         angles = [-adduction internal -flexion];
     else if strcmp('L',side)==1
             angles = [-adduction internal -flexion];
         end
     end
     else if strcmp('Knee',joint)==1
             if strcmp('R',side) ==1
                 angles = [-adduction internal flexion];
             else if strcmp('L',side)==1
                     angles = [-adduction internal flexion];
                 end
             end
         else if strcmp('Ankle',joint)==1
                 if strcmp('R',side)==1
                     angles = [-adduction internal -flexion];        
                 else if strcmp ('L',side)==1
                         angles = [-adduction internal -flexion];
                     end
                 end
             end
         end
 end
 
end
