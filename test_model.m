addpath("models", "output");

gbox.w = 1.16;
gbox.d = 0.74;
gbox.h = 0.9;
gbox.floor = 0.15;
gbox.x_collar = 0.3;
gbox.d_collar = 0.2;
gbox.t_collar = 0.02;

arm = ValkArm;
arm.red = 1;

% arm.lens = [0 0 0 0 0.155 0 0.05 0.163];
% arm.dias = [0 0 0 0 0.100 0 0.100 0.100];

arm.lens = [0 0 0 0 0.23 0 0.07 0];
arm.dias = [0 0 0 0 0.135 0 0.09 0];

arm.rbt = def_old(arm.lens, arm.red);

if arm.red
    bAct2 = arm.rbt.Bodies{2}.Joint;
    bAct3 = arm.rbt.Bodies{3}.Joint;
    act2 = arm.rbt.Bodies{6}.Joint;
else
    bAct2 = arm.rbt.Bodies{2}.Joint;
    bAct3 = arm.rbt.Bodies{3}.Joint;
    bAct4 = arm.rbt.Bodies{4}.Joint;
    act1 = arm.rbt.Bodies{5}.Joint;
    act2 = arm.rbt.Bodies{6}.Joint;
    act3 = arm.rbt.Bodies{7}.Joint;
end

acts = cellfun(@(x) ~strcmp(x.Joint.Type, 'fixed'), arm.rbt.Bodies);

numActs = sum(acts);

config = cell2struct(cellfun(@(x) x.Joint.Name, ...
                             arm.rbt.Bodies(acts), ...
                             'UniformOutput', false), ...
                     'JointName', 1)';

if arm.red
    config(1).JointPosition = 0 + bAct2.HomePosition;
    config(2).JointPosition = deg2rad(40) + bAct3.HomePosition;
    config(3).JointPosition = deg2rad(15) + act2.HomePosition;
else
    config(1).JointPosition = -0.1 + bAct2.HomePosition;
    config(2).JointPosition = deg2rad(10) + bAct3.HomePosition;
    config(3).JointPosition = deg2rad(10) + bAct4.HomePosition;
    config(4).JointPosition = deg2rad(-30) + act1.HomePosition;
    config(5).JointPosition = deg2rad(30) + act2.HomePosition;
    config(6).JointPosition = deg2rad(30) + act3.HomePosition;
end

%config = Valkarm.rbt.homeConfiguration;

figure
show(arm.rbt, config);
view(35, 30);

plot_arms(arm, config, gbox);