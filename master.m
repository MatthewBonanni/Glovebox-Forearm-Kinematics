% MASTER SCRIPT

resolution = 5;

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
rpr.lens = [0.155 0.05 0.163];
rpr.dias = [0 0 0 0 0.135 0 0.135 0.135];
rpr.rbt = def_rpr(rpr.lens);
[rpr.endpts, rpr.bound, rpr.vol] = gamut(rpr, gbox, resolution);
disp("DONE: RPR");
disp(strcat("RPR envelope volume: ", num2str(rpr.vol * 10^6), " cm^3"))

disp("");

disp("Calculating RPY Gamut...");
rpy = ValkArm;
rpy.lens = [0.155 0.05 0.163];
rpy.dias = [0 0 0 0 0.135 0 0.135 0.135];
rpy.rbt = def_rpy(rpy.lens);
[rpy.endpts, rpy.bound, rpy.vol] = gamut(rpy, gbox, resolution);
disp("DONE: RPY");
disp(strcat("RPY envelope volume: ", num2str(rpy.vol * 10^6), " cm^3"))

disp("");

disp("Calculating Old Gamut...");
old = ValkArm;
old.lens = [0.23 0 0.07];
old.dias = [0 0 0 0 0.135 0 0 0.09];
old.rbt = def_old(old.lens);
[old.endpts, old.bound, old.vol] = gamut(old, gbox, resolution);
disp("DONE: Old");
disp(strcat("Old envelope volume: ", num2str(old.vol * 10^6), " cm^3"))

%% Plot output

plot_range(rpr.endpts, rpr.bound, gbox);
saveas(gcf, 'output/gamut_rpr.png');
plot_range(rpy.endpts, rpy.bound, gbox);
saveas(gcf, 'output/gamut_rpy.png');
plot_range(old.endpts, old.bound, gbox);
saveas(gcf, 'output/gamut_old.png');

save('output/output.mat', 'gbox', 'old', 'rpr', 'rpy');