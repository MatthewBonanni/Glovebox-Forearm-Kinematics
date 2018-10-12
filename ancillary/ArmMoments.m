g = 9.81; % m/s^2
% ma = 0.62; % mass of actuator
ml1 = 0.4; % mass of link 1
ml2 = 0.059; % mass of link 2
ml3 = 0.100; % mass of link 3
mh = 0.750; % mass of hand
m = 0; % mass of carried load
ma = 0.135; % kg
ml1 = ml1*(1/3)*(0.4);
ml2 = ml2*(1/3)*(0.4);
ml3 = ml3*(1/3)*(0.4);
link1 = 0.1+0.020;
link2 = 0.2;
linkh = 0.2;
l_arm = link1+link2+linkh;

m_arm = 3*ma+ml1+ml2+ml3+mh; % mass of entire arm, not incl. load

T_pitch = (link2/2)*g*ml2+(link2)*g*ma+(link2+linkh/2)*g*ml3+(link2+linkh/2)*g*ma+(link2+linkh)*g*mh;

% T_pitch_max = 11.4; % Max torque FHA-11C actuator can apply
% Link 2 + Roll 2 + Link 3 + Hand + Carried Mass
% T_pitch = (0.055*g*ml2) + (0.080*g*ma) + (0.126*g*ml3) + ((0.121+0.085)*g*mh) + ((0.121+0.085)*g*m)
% SF_pitch = T_pitch_max/T_pitch % Safety factor for pitch actuator statically supporting load

% M_roll_max = 40; % Max bending moment on FHA-11C actuator
% Link 1 + Pitch + Link 2 + Roll 2 + Link 3 + Hand + Carried Mass
% M_roll = (ml1*(0.125)*0.5*g)+(ma*(0.091)*g)+(ml2*(0.146)*g)+(ma*(0.180)*g)+(ml3*0.220*g)+(mh*(0.220+0.080)*g)+(m*(0.220+0.080)*g)
% SF_roll = M_roll_max/M_roll % Safety factor for Roll 1 actuator statically supporting load