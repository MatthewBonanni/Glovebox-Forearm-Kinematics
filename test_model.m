def_rpy();

config = struct('JointName', [], 'JointPosition', []);

config(1).JointName = 'bLink2';
config(2).JointName = 'link1';
config(3).JointName = 'link2';
config(4).JointName = 'link3';

config(1).JointPosition = 0.05 + bAct2.HomePosition;
config(2).JointPosition = 0 + act1.HomePosition;
config(3).JointPosition = deg2rad(10) + act2.HomePosition;
config(4).JointPosition = deg2rad(10) + act3.HomePosition;

%config(1).JointPosition = 0;
%config(2).JointPosition = act1.PositionLimits(1);
%config(3).JointPosition = act2.PositionLimits(1);
%config(4).JointPosition = act3.PositionLimits(1);

%config = ValkArm.homeConfiguration;

show(ValkArm, config);