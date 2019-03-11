%Given the angle gamma create rotation matrix Rz
function Rz=Rz(gamma)
Rz=[cosd(gamma) -sind(gamma) 0; sind(gamma) cosd(gamma) 0; 0 0 1];
end
