% MASTER SCRIPT

%% Compute mobility for arm models

lens_rpr = [0.3 0.03 0.3];
ValkArm_rpr = def_rpr(lens_rpr);
[endpts_rpr, bound_rpr, vol_rpr] = mobility(ValkArm_rpr);
disp("DONE: RPR");
disp(strcat("RPR envelope volume: ", num2str(vol_rpr * 10^6), " cm^3"))

lens_rpy = [0.3 0.15 0.15];
ValkArm_rpy = def_rpy(lens_rpy);
[endpts_rpy, bound_rpy, vol_rpy] = mobility(ValkArm_rpy);
disp("DONE: RPY");
disp(strcat("RPY envelope volume: ", num2str(vol_rpy * 10^6), " cm^3"))

lens_old = [0.23 0 0.07];
ValkArm_old = def_old(lens_old);
[endpts_old, bound_old, vol_old] = mobility(ValkArm_old);
disp("DONE: Old");
disp(strcat("Old envelope volume: ", num2str(vol_old * 10^6), " cm^3"))

%% Plot output

figure(1);
plot_range(endpts_rpr, bound_rpr);
figure(2);
plot_range(endpts_rpy, bound_rpy);
figure(3);
plot_range(endpts_old, bound_old);