% MASTER SCRIPT

%% Glove box parameters

box.w = 1.16;
box.d = 0.74;
box.h = 0.9;
box.floor = 0.15;
box.x_collar = 0.3;
box.r_collar = 0.1;

%% Compute mobility for arm models

rpr.lens = [0.3 0.05 0.25];
rpr.ValkArm = def_rpr(rpr.lens);
[rpr.endpts, rpr.bound, rpr.vol] = mobility(rpr.ValkArm, box);
disp("DONE: RPR");
disp(strcat("RPR envelope volume: ", num2str(rpr.vol * 10^6), " cm^3"))

rpy.lens = [0.3 0.15 0.15];
rpy.ValkArm = def_rpy(rpy.lens);
[rpy.endpts, rpy.bound, rpy.vol] = mobility(rpy.ValkArm, box);
disp("DONE: RPY");
disp(strcat("RPY envelope volume: ", num2str(rpy.vol * 10^6), " cm^3"))

old.lens = [0.23 0 0.07];
old.ValkArm = def_old(old.lens);
[old.endpts, old.bound, old.vol] = mobility(old.ValkArm, box);
disp("DONE: Old");
disp(strcat("Old envelope volume: ", num2str(old.vol * 10^6), " cm^3"))

%% Plot output

plot_range(rpr.endpts, rpr.bound, box);
saveas(gcf, 'output/mobility_rpr.png');
plot_range(rpy.endpts, rpy.bound, box);
saveas(gcf, 'output/mobility_rpy.png');
plot_range(old.endpts, old.bound, box);
saveas(gcf, 'output/mobility_old.png');

save('output.mat', 'box', 'old', 'rpr', 'rpy');