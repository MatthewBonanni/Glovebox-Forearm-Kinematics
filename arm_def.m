ValkArm = robotics.RigidBodyTree;

bLink1 = robotics.RigidBody('bLink1');
link1 = robotics.RigidBody('link1');
link2 = robotics.RigidBody('link2');
link3 = robotics.RigidBody('link3');
linkE = robotics.RigidBody('linkE'); % end effector

len1 = 0.3;
len2 = 0.03;
len3 = 0.3;

bAct1 = robotics.Joint('bLink1', 'prismatic');
act1 = robotics.Joint('link1', 'revolute');
act2 = robotics.Joint('link2', 'revolute');
act3 = robotics.Joint('link3', 'revolute');
actE = robotics.Joint('linkE', 'fixed'); % end effector

bAct1.PositionLimits = [-0.5 0.5];
act1.PositionLimits = [-pi pi];
act2.PositionLimits = [-pi/2 pi/2];
act3.PositionLimits = [-pi pi];

dhparams = [0   0     0     0;
            0   -pi/2 0     0;
            0   pi/2  0     0;
            0   0     len2  0;
            0   0     len3  0];

setFixedTransform(bAct1, dhparams(1,:), 'dh');
setFixedTransform(act1, dhparams(2,:), 'dh');
setFixedTransform(act2, dhparams(3,:), 'dh');
setFixedTransform(act3, dhparams(4,:), 'dh');
setFixedTransform(actE, dhparams(5,:), 'dh');

bLink1.Joint = bAct1;
link1.Joint = act1;
link2.Joint = act2;
link3.Joint = act3;
linkE.Joint = actE;

addBody(ValkArm, bLink1, 'base');
addBody(ValkArm, link1, 'bLink1');
addBody(ValkArm, link2, 'link1');
addBody(ValkArm, link3, 'link2');
addBody(ValkArm, linkE, 'link3');

config = ValkArm.randomConfiguration;
tform = getTransform(ValkArm, config, 'linkE', 'base');

showdetails(ValkArm);
show(ValkArm, config);