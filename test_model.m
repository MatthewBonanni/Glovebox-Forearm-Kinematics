lens = [0.155 0.05 0.163];

ValkArm = def_rpr(lens);

bAct2 = ValkArm.Bodies{2}.Joint;
bAct3 = ValkArm.Bodies{3}.Joint;
bAct4 = ValkArm.Bodies{4}.Joint;
act1 = ValkArm.Bodies{5}.Joint;
act2 = ValkArm.Bodies{6}.Joint;
act3 = ValkArm.Bodies{7}.Joint;

acts = cellfun(@(x) ~strcmp(x.Joint.Type, 'fixed'), ValkArm.Bodies);

numActs = sum(acts);

config = cell2struct(cellfun(@(x) x.Joint.Name, ...
                             ValkArm.Bodies(acts), ...
                             'UniformOutput', false), ...
                     'JointName', 1)';



config(1).JointPosition = 0.25 + bAct2.HomePosition;
config(2).JointPosition = deg2rad(10) + bAct3.HomePosition;
config(3).JointPosition = deg2rad(10) + bAct4.HomePosition;
config(4).JointPosition = deg2rad(30) + act1.HomePosition;
config(5).JointPosition = deg2rad(30) + act2.HomePosition;
config(6).JointPosition = deg2rad(30) + act3.HomePosition;

% config(1).JointPosition = 0;
% config(2).JointPosition = act1.PositionLimits(1);
% config(3).JointPosition = act2.PositionLimits(1);
% config(4).JointPosition = act3.PositionLimits(1);

%config = ValkArm.homeConfiguration;

show(ValkArm, config);
view(35, 30);

