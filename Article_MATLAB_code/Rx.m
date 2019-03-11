%Given angle alpha create the rotation matrix Rx
function Rx=Rx(alpha)
Rx=[1 0 0; 0 cosd(alpha) -sind(alpha); 0 sind(alpha) cosd(alpha)];
end
