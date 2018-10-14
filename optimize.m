gbox.w = 1.16;
gbox.d = 0.74;
gbox.h = 0.9;
gbox.floor = 0.15;
gbox.x_collar = 0.3;
gbox.d_collar = 0.2;
gbox.t_collar = 0.02;

res_optimization = 5;
res_model = 10;

rpr = ValkArm;
rpr.red = red;
rpr.lens = [0 0 0 0 0.155 0 0.082 0.250];
rpr.dias = [0 0 0 0 0.100 0 0.100 0.100];

lensLimits = cell(1,2);

lensLimits{1} = [0.155 0.5];
lensLimits{2} = [0.150 0.5];

paramSets = cellfun(@(x) linspace(x(1), x(2), res_optimization), ...
                    lensLimits, ...
                    'UniformOutput', false);

currentSet = ones(1, length(lensLimits));

vol = zeros(res_optimization, res_optimization);
is_end = 0;

while ~is_end
    disp(currentSet);
    
    rpr.lens = [0 0 0 0 paramSets{1}(currentSet(1)) ...
                0 0.82 paramSets{2}(currentSet(2)) - 0.82];
    
    rpr.rbt = def_rpr(rpr.lens, rpr.red);
    [~, ~, vol(currentSet(1), currentSet(2))] = gamut(rpr, gbox, res_model);
    
    is_end = all(currentSet == res_optimization);
    
    if ~is_end
        currentSet = count_array(currentSet, res_optimization);
    end
end

maxVolume = max(vol(:));

[iOpt1, iOpt2] = find(vol == maxVolume);

opt1 = paramSets{1}(iOpt1);
opt2 = paramSets{2}(iOpt2);

optLens = [opt1, 0.082, opt2 - 0.082];

disp("Optimal link lengths:");
disp(optLens); 