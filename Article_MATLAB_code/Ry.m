%Given the angle beta creat the rotation matrix Ry
function Ry=Ry(beta)
Ry=[cosd(beta) 0 sind(beta); 0 1 0; -sind(beta) 0 cosd(beta)];
end
