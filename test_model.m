arm = ValkArm;

arm.lens = [0.155 0.05 0.163];
arm.dias = [0 0 0 0 0.135 0 0.135 0.135];

arm.rbt = def_rpr(arm.lens);

bAct2 = arm.rbt.Bodies{2}.Joint;
bAct3 = arm.rbt.Bodies{3}.Joint;
bAct4 = arm.rbt.Bodies{4}.Joint;
act1 = arm.rbt.Bodies{5}.Joint;
act2 = arm.rbt.Bodies{6}.Joint;
act3 = arm.rbt.Bodies{7}.Joint;

acts = cellfun(@(x) ~strcmp(x.Joint.Type, 'fixed'), arm.rbt.Bodies);

numActs = sum(acts);

config = cell2struct(cellfun(@(x) x.Joint.Name, ...
                             arm.rbt.Bodies(acts), ...
                             'UniformOutput', false), ...
                     'JointName', 1)';

config(1).JointPosition = -0.16 + bAct2.HomePosition;
config(2).JointPosition = deg2rad(15) + bAct3.HomePosition;
config(3).JointPosition = deg2rad(15) + bAct4.HomePosition;
config(4).JointPosition = deg2rad(30) + act1.HomePosition;
config(5).JointPosition = deg2rad(30) + act2.HomePosition;
config(6).JointPosition = deg2rad(30) + act3.HomePosition;

% config(1).JointPosition = 0;
% config(2).JointPosition = act1.PositionLimits(1);
% config(3).JointPosition = act2.PositionLimits(1);
% config(4).JointPosition = act3.PositionLimits(1);

%config = Valkarm.rbt.homeConfiguration;

show(arm.rbt, config);
view(35, 30);

