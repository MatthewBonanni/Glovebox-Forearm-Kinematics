len1 = 0.3;
len2 = 0.1;
len3 = 0.3;

current_arm();

config = struct('JointName', [], 'JointPosition', []);

config(1).JointName = 'bLink2';
config(2).JointName = 'link1';
config(3).JointName = 'link2';
config(4).JointName = 'link3';

config(1).JointPosition = 0.05 + bAct2.HomePosition;
config(2).JointPosition = 0 + act1.HomePosition;
config(3).JointPosition = deg2rad(10) + act2.HomePosition;
config(4).JointPosition = deg2rad(10) + act3.HomePosition;

show(ValkArm, config);