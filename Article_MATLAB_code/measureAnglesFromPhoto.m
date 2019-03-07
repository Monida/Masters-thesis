%measureAnglesFromPhoto
%--------------------------------------------------------------------------
% Call the function:
%[hip,knee,ankle]=measureAnglesFromPhoto(plane)
%where plane refers to the plane where angle are going to be measured it can be
%the strigns Sagittal of Frontal 

% 1. Load photo
% The software will prompt you to select the photo to analyze

% 2. Get marker position
%Get markers in the following order when side=sagittal
% 1. ASI
% 2. PSI
% 3. HIP
% 4. KNE
% 5. ANK
% 6. HEE
% 7. TOE
%The following order when side=frontal
% 1. RASI
% 2. RLKN
% 3. RMKN
% 4. RLAN
% 5. RMAN
% 6. LASI
% 7. LLKN
% 8. LMKN
% 9. LLAN
% 10. LMAN
% To select the maker click on it:
% -If you are happy with the selection hit enter
% -If you want to reselect the marker just left click with the mouse and try to select again
% Each of the following variables contain the 2D coordenates of the marker in
% the photos

% 3. Define segments
% The function defines the coordinate system of the segment in the sagittal
% plane according to the PiG model
% z = vertical axis
% x = antero-posterior axis
% Then defines the segments 

% 4. Draw segments
% Draws the segments on the image

% 5. Measure angles
% Measure the angle between the two vectors used to calculate the clinical
% FE angles
%--------------------------------------------------------------------------
function [hip,knee,ankle]=measureAnglesFromPhoto(plane)
%% 1. Load photo
[fileName,pathName]=uigetfile('.jpg');
cd(pathName)
image=imread(strcat(pathName,fileName));
imshow(image)
hip=0;
knee=0;
ankle=0;

%% 2. Get marker position
switch plane
    case 'Sagittal'
        ASI=getMarker(1);
        PSI=getMarker(1);
        HIP=getMarker(1);
        KNE=getMarker(1);
        ANK=getMarker(1);
        HEE=getMarker(1);
        TOE=getMarker(1);
        
        %% 3. Define segments
        %X axis of pelvis reference frame
        pelvis_x=ASI-PSI;
        %Slope of the pelvis_x axis
        m=(ASI(2)-PSI(2))/(ASI(1)-PSI(1));
        minv=-1/m;
        %Find the line equation y-y1=m*(x-x1)
        %endPoint(2)-PSI(1)=minv*(endPoint(1)-PSI(2));
        endPoint(1)=PSI(1)+(abs(PSI(1)-ASI(1))/5);%to find the x value for endpoint
        endPoint(2)=minv*(endPoint(1)-PSI(1))+PSI(2);
        
        %Z axis of pelvis reference frame
        pelvis_z=(endPoint-PSI);
        
        %Z axis of femur reference frame
        femur=HIP-KNE;
        
        %Z axis of femur reference frame
        shank_z=KNE-ANK;
        mshank=(KNE(2)-ANK(2))/(KNE(1)-ANK(1));
        mshankinv=-1/mshank;
        endPointShank(2)=ANK(2)+(abs(KNE(2)-ANK(2))/5);
        endPointShank(1)=(endPointShank(2)-KNE(2)+mshankinv*KNE(1))/mshankinv;
        
        %X axis of femur reference frame
        shank_x=(endPointShank-ANK);
        
       
        %Find flexion offset
%         rf=[ANK(1) TOE(2)]; %Ankle marker at the same hight of TOE
        
%         alpha=acos(dot(TOE-ANK,TOE-rf)/(norm(TOE-ANK)*norm(TOE-rf)))*180/pi;
         %X axis of foot reference frame
         foot=TOE-HEE;

        %% Draw segments
        %Pelvis
        line([PSI(1) ASI(1)],[PSI(2) ASI(2)],'LineWidth',2)
        line([PSI(1) endPoint(1)],[PSI(2) endPoint(2)],'LineWidth',2)
        
        %Femur
        line([HIP(1) KNE(1)],[HIP(2) KNE(2)],'LineWidth',2)
        
        %Shank
        line([KNE(1) ANK(1)],[KNE(2) ANK(2)],'LineWidth',2)
        
        %Foot
        line([HEE(1) TOE(1)],[HEE(2) TOE(2)],'LineWidth',2)
        
        %% Measure angles
        
        hip=calcAng(pelvis_x,femur)-90;
        knee=calcAng(femur,shank_z);
%         ankle=90-calcAng(shank_z,foot);
        ankle=90-calcAng(shank_z,foot);
        
     
    case 'Frontal'
        RASI=getMarker(1);
        RLKN=getMarker(1); 
        RMKN=getMarker(1);
        RLAN=getMarker(1);
        RMAN=getMarker(1);
        
        LASI=getMarker(1);
        LLKN=getMarker(1); 
        LMKN=getMarker(1);
        LLAN=getMarker(1);
        LMAN=getMarker(1);
        
        pelvis_y=LASI-RASI;
        
        m=(LASI(2)-RASI(2))/(LASI(1)-RASI(1));
        minv=-1/m;
        
        endPoint(1)= (RASI (1))+(LASI/RASI)/10;
        endPoint(2)= minv*(endPoint(1)-RASI(1))+RASI(2);
        pelvis_z=endPoint-RASI;
        
        RKJC=(RLKN+RMKN)/2;
        Rfemur=RKJC-RASI;
        
        RAJC=(RMAN+RLAN)/2;
        Rshank=RAJC-RKJC;
        
        LKJC=(LLKN+LMKN)/2;
        Lfemur=LKJC-LASI;
        
        LAJC=(LMAN+LLAN)/2;
        Lshank=LAJC-LKJC;
        
         %% Draw segments
        %Pelvis
        line([RASI(1) LASI(1)],[RASI(2) LASI(2)],'LineWidth',2)
        line([RASI(1) endPoint(1)],[RASI(2) endPoint(2)],'LineWidth',2)
        
        %RFemur
        line([RASI(1) RKJC(1)],[RASI(2) RKJC(2)],'LineWidth',2)
        
        %LShank
        line([RKJC(1) RAJC(1)],[RKJC(2) RAJC(2)],'LineWidth',2)
        
        %RFemur
        line([LASI(1) LKJC(1)],[LASI(2) LKJC(2)],'LineWidth',2)
        
        %LShank
        line([LKJC(1) LAJC(1)],[LKJC(2) LAJC(2)],'LineWidth',2)
        %% Measure angles
        Rhip=calcAng(pelvis_z,Rfemur)-180;
        Rknee=calcAng(Rfemur,Rshank);
        Lhip=calcAng(pelvis_z,Lfemur)-180;
        Lknee=calcAng(Lfemur,Lshank);
        hip=[Rhip Lhip];
        knee=[-Rknee -Lknee];
end
end
%//////////////////////////Sub functions//////////////////////////////
%Following Kadaba Flexion-Extension
%{
    function angle=calcAng(I,K3)
        I=norm(I);
        K3=norm(K3);
        angle=asin(dot(K3,I))*180/pi;
    end
%}

function angle=calcAng(v1,v2)
angle = acos(dot(v1,v2)/(norm(v1)*norm(v2)))*180/pi;
end
%}

%Accept of reject selected marker
function marker=getMarker(varargin)
switch nargin
case 0
  h=gca;
case 1
  h=gca;
  measure=varargin{1};
  axes(h);
otherwise
  disp('Too many input arguments.');
end

cudata=get(gcf,'UserData'); %current UserData
hold on;
while measure== 1
k=waitforbuttonpress;
marker=get(h,'Currentpoint');       %get point
marker=marker(1,1:2);           
%extract x and y
lh=plot(marker(1),marker(2),'+:');  
key=waitforbuttonpress;
if key==1
    set(gcf,'UserData',cudata,'WindowButtonMotionFcn','','DoubleBuffer','off'); %reset UserData, etc..
    measure=0;
else
    delete(lh);
    measure=1;
end
end
end

