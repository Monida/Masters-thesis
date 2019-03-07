%Takes a single quaternion and returns a single rotation Matrix
function  R=quaternion2matrix(q)
R=[1-2*q(3)^2-2*q(4)^2      2*q(2)*q(3)-2*q(1)*q(4)   2*q(2)*q(4)+2*q(1)*q(3);   
   2*q(2)*q(3)+2*q(1)*q(4)  1-2*q(2)^2-2*q(4)^2       2*q(3)*q(4)-2*q(1)*q(2);    
   2*q(2)*q(4)-2*q(1)*q(3)  2*q(3)*q(4)+2*q(1)*q(2)   1-2*q(2)^2-2*q(3)^2];
end
