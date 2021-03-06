% MASTER SCRIPT

addpath("models", "output", "misc");

resolution = 15; % step count
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
rpr.lens = [0 0 0 0 0.225 0 0.080 0.175];
rpr.dias = [0 0 0 0 0.077 0 0.069 0.070];
rpr.rbt = def_rpr(rpr.lens, rpr.red);
[rpr.endpts, rpr.bound, rpr.vol, rpr.wVol] = gamut(rpr, gbox, resolution);
disp("DONE: RPR");
disp(strcat("RPR envelope volume: ", num2str(rpr.vol * 10^6), " cm^3"));

disp("");

disp("Calculating Old Gamut...");
old = ValkArm;
old.red = red;
old.lens = [0 0 0 0 0.295 0 0.068 0];
old.dias = [0 0 0 0 0.135 0 0.09 0];
old.rbt = def_old(old.lens, old.red);
[old.endpts, old.bound, old.vol, old.wVol] = gamut(old, gbox, resolution);
disp("DONE: Old");
disp(strcat("Old envelope volume: ", num2str(old.vol * 10^6), " cm^3"));

disp("");

disp(strcat("Gamut improvement factor: ", num2str(rpr.vol / old.vol)));

%% Plot output

plot_gamut(rpr.endpts, rpr.bound, gbox);
saveas(gcf, 'output/gamut_rpr.png');
plot_gamut(old.endpts, old.bound, gbox);
saveas(gcf, 'output/gamut_old.png');

save('output/gamut_output.mat', 'gbox', 'old', 'rpr');