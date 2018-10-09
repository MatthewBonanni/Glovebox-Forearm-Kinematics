% MASTER SCRIPT

addpath("models", "output");

resolution = 10; % step count
red = 1; % reduced complexity models

%% Glove gbox parameters

gbox.w = 1.16;
gbox.d = 0.74;
gbox.h = 0.9;
gbox.floor = 0.15;
gbox.x_collar = 0.3;
gbox.d_collar = 0.2;
gbox.t_collar = 0.02;

%% Compute gamut for arm models

disp("Calculating RPR Gamut...");
rpr = ValkArm;
rpr.red = red;
rpr.lens = [0 0 0 0 0.155 0 0.050 0.163];
rpr.dias = [0 0 0 0 0.100 0 0.100 0.100];
rpr.rbt = def_rpr(rpr.lens, rpr.red);
[rpr.endpts, rpr.bound, rpr.vol] = gamut(rpr, gbox, resolution);
disp("DONE: RPR");
disp(strcat("RPR envelope volume: ", num2str(rpr.vol * 10^6), " cm^3"))

disp("");

disp("Calculating RPY Gamut...");
rpy = ValkArm;
rpy.red = red;
rpy.lens = [0 0 0 0 0.155 0 0.050 0.163];
rpy.dias = [0 0 0 0 0.100 0 0.100 0.100];
rpy.rbt = def_rpy(rpy.lens, rpy.red);
[rpy.endpts, rpy.bound, rpy.vol] = gamut(rpy, gbox, resolution);
disp("DONE: RPY");
disp(strcat("RPY envelope volume: ", num2str(rpy.vol * 10^6), " cm^3"))

disp("");

disp("Calculating Old Gamut...");
old = ValkArm;
old.red = red;
old.lens = [0 0 0 0 0.23 0 0 0.07];
old.dias = [0 0 0 0 0.135 0 0 0.09];
old.rbt = def_old(old.lens, old.red);
[old.endpts, old.bound, old.vol] = gamut(old, gbox, resolution);
disp("DONE: Old");
disp(strcat("Old envelope volume: ", num2str(old.vol * 10^6), " cm^3"))

%% Plot output

plot_gamut(rpr.endpts, rpr.bound, gbox);
saveas(gcf, 'output/gamut_rpr.png');
plot_gamut(rpy.endpts, rpy.bound, gbox);
saveas(gcf, 'output/gamut_rpy.png');
plot_gamut(old.endpts, old.bound, gbox);
saveas(gcf, 'output/gamut_old.png');

save('output/output.mat', 'gbox', 'old', 'rpr', 'rpy');