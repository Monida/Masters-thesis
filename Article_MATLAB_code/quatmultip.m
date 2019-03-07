%Takes 2 quaternions and performs quaterion multiplication
function q=quatmultip(q1,q2)
v1=q1(2:4);
v2=q2(2:4);
q(1)= q1(1)*q2(1)-dot(v1,v2);
q(2:4)=q1(1)*v2+q2(1)*v1+cross(v1,v2);
end