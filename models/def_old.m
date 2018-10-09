function [ValkArm] = def_old(lens, red)
%DEF_OLD Model definition of Valkyrie current arm
%   lens - array of link lengths

ValkArm = robotics.RigidBodyTree;

bLink1 = robotics.RigidBody('bLink1');
bLink2 = robotics.RigidBody('bLink2');
bLink3 = robotics.RigidBody('bLink3');
bLink4 = robotics.RigidBody('bLink4');
link1 = robotics.RigidBody('link1');
link2 = robotics.RigidBody('link2');
link3 = robotics.RigidBody('link3');
linkE = robotics.RigidBody('linkE'); % end effector

if red
    bAct1 = robotics.Joint('bLink1', 'fixed');
    bAct2 = robotics.Joint('bLink2', 'prismatic');
    bAct3 = robotics.Joint('bLink3', 'revolute');
    bAct4 = robotics.Joint('bLink4', 'fixed');
    act1 = robotics.Joint('link1', 'fixed');
    act2 = robotics.Joint('link2', 'revolute');
    act3 = robotics.Joint('link3', 'fixed');
    actE = robotics.Joint('linkE', 'fixed'); % end effector
    
    bAct2.HomePosition = 0;
    bAct3.HomePosition = -pi/2;
    act2.HomePosition = -pi/2;
    
    bAct2.PositionLimits = bAct2.HomePosition + [-sum(lens) 0];
    bAct3.PositionLimits = bAct3.HomePosition + [0 pi/2];
    act2.PositionLimits = act2.HomePosition + [0 deg2rad(17)];
else
    bAct1 = robotics.Joint('bLink1', 'fixed');
    bAct2 = robotics.Joint('bLink2', 'prismatic');
    bAct3 = robotics.Joint('bLink3', 'revolute');
    bAct4 = robotics.Joint('bLink4', 'revolute');
    act1 = robotics.Joint('link1', 'revolute');
    act2 = robotics.Joint('link2', 'revolute');
    act3 = robotics.Joint('link3', 'revolute');
    actE = robotics.Joint('linkE', 'fixed'); % end effector

    bAct2.HomePosition = 0;
    bAct3.HomePosition = -pi/2;
    bAct4.HomePosition = pi/2;
    act1.HomePosition = -pi/2;
    act2.HomePosition = -pi/2;
    act3.HomePosition = 0;
    
    bAct2.PositionLimits = bAct2.HomePosition + [-sum(lens) 0];
    bAct3.PositionLimits = bAct3.HomePosition + [-pi/2 pi/2];
    bAct4.PositionLimits = bAct4.HomePosition + [-pi/2 pi/2];
    act1.PositionLimits = act1.HomePosition + [-pi pi];
    act2.PositionLimits = act2.HomePosition + [deg2rad(-17) deg2rad(17)];
    act3.PositionLimits = act3.HomePosition + [deg2rad(-17) deg2rad(17)];
end

dhparams = [0        pi/2  0        pi;
            0        pi/2  0       -pi/2;
            0        pi/2  0        0;
            0       -pi/2  0        pi/2;
            0       -pi/2  lens(5) -pi/2;
            lens(6) -pi/2  0        0;
            lens(7)  pi/2  0        0;
            0        0     0        0];

setFixedTransform(bAct1, dhparams(1,:), 'dh');
setFixedTransform(bAct2, dhparams(2,:), 'dh');
setFixedTransform(bAct3, dhparams(3,:), 'dh');
setFixedTransform(bAct4, dhparams(4,:), 'dh');
setFixedTransform(act1, dhparams(5,:), 'dh');
setFixedTransform(act2, dhparams(6,:), 'dh');
setFixedTransform(act3, dhparams(7,:), 'dh');
setFixedTransform(actE, dhparams(8,:), 'dh');

bLink1.Joint = bAct1;
bLink2.Joint = bAct2;
bLink3.Joint = bAct3;
bLink4.Joint = bAct4;
link1.Joint = act1;
link2.Joint = act2;
link3.Joint = act3;
linkE.Joint = actE;

addBody(ValkArm, bLink1, 'base');
addBody(ValkArm, bLink2, 'bLink1');
addBody(ValkArm, bLink3, 'bLink2');
addBody(ValkArm, bLink4, 'bLink3');
addBody(ValkArm, link1, 'bLink4');
addBody(ValkArm, link2, 'link1');
addBody(ValkArm, link3, 'link2');
addBody(ValkArm, linkE, 'link3');

end