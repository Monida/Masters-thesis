function [p1,p3]=rbline(varargin)
%function to draw a rubberband line and return the start and end points
%Usage: [p1,p2]=rbline;     uses current axes
% or    [p1,p2]=rbline(h);  uses axes refered to by handle, h

% Created by Sandra Martinka March 2002
disp('Click on the markers that define the segment')
switch nargin
case 0
  h=gca;
case 1
  h=varargin{1};
  axes(h);
otherwise
  disp('Too many input arguments.');
end
cudata=get(gcf,'UserData'); %current UserData
hold on;
k=waitforbuttonpress;
p1=get(h,'CurrentPoint');       %get starting point
p1=p1(1,1:2);                   %extract x and y
lh1=plot(p1(1),p1(2),'+:');  
%plot starting point
udata.p1=p1;
udata.h=h;
udata.lh1=lh1;
set(gcf,'UserData',udata,'WindowButtonMotionFcn','wbmf','DoubleBuffer','on');
%{
k=waitforbuttonpress;
p2=get(h,'CurrentPoint');       %get middle point
p2=p2(1,1:2);                   %extract x and y
lh2=plot(p2(1),p2(2),'+:');  
%plot starting point
udata.p2=p2;
udata.h=h;
udata.lh2=lh2;
set(gcf,'UserData',udata,'WindowButtonMotionFcn','wbmf2','DoubleBuffer','on');
%}
k=waitforbuttonpress;
p3=get(h,'Currentpoint');       %get end point
p3=p3(1,1:2);                   %extract x and y
set(gcf,'UserData',cudata,'WindowButtonMotionFcn','','DoubleBuffer','off'); %reset UserData, etc..

accept=input('Accept Measurement?','s');
if strcmp(accept,'yes')==1
    
else
    delete(lh1);
    %delete(lh2);
end
    


function wbmf
%window motion callback function
utemp=get(gcf,'UserData');
ptemp=get(utemp.h,'CurrentPoint');
ptemp=ptemp(1,1:2);
set(utemp.lh1,'XData',[utemp.p1(1),ptemp(1)],'YData',[utemp.p1(2),ptemp(2)]);
%{
function wbmf2
%window motion callback function
utemp=get(gcf,'UserData');
ptemp=get(utemp.h,'CurrentPoint');
ptemp=ptemp(1,1:2);
set(utemp.lh2,'XData',[utemp.p2(1),ptemp(1)],'YData',[utemp.p2(2),ptemp(2)]);
%}