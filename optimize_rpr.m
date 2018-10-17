addpath("models", "output");

%% Glovebox parameters

gbox.w = 1.16;
gbox.d = 0.74;
gbox.h = 0.9;
gbox.floor = 0.15;
gbox.x_collar = 0.3;
gbox.d_collar = 0.2;
gbox.t_collar = 0.02;

%% Model performance parameters

res_optimization = 10;
res_model = 10 ;
zoomCount = 3;
shrink = 0.5;

%% Model physical parameters

rpr = ValkArm;
rpr.red = 1;
rpr.dias = [0 0 0 0 0.100 0 0.100 0.100];

len2 = 0.082;

numParams = 2;

lensLimits = cell(1,numParams);

lensLimits{1} = [0.155 1];
lensLimits{2} = [0.150 0.5];

%% Optimize

currentLimits = lensLimits;

currentSet = ones(1, length(lensLimits));

paramSets = cell(1, zoomCount);
wVol = cell(1, zoomCount);

paramSets{1} = cellfun(@(x) linspace(x(1), x(2), res_optimization), ...
                       lensLimits, ...
                       'UniformOutput', false);

is_end = 0;

accData = [];

figure();
hold on;

for i = 1:zoomCount
    
    disp(strcat("Iteration: ", num2str(i)));
    
    wVol{i} = zeros(res_optimization, res_optimization);
    
    while ~is_end
        disp(currentSet);
        
        if ~valid_lens([paramSets{i}{1}(currentSet(1)), ...
                len2, ...
                paramSets{i}{2}(currentSet(2)) - len2])
            wVol{i}(currentSet(1), currentSet(2)) = NaN;
        else
            rpr.lens = [0 0 0 0 paramSets{i}{1}(currentSet(1)) ...
                0 len2 paramSets{i}{2}(currentSet(2)) - len2];
            
            rpr.rbt = def_rpr(rpr.lens, rpr.red);
            [~, ~, ~, wVol{i}(currentSet(1), currentSet(2))] = gamut(rpr, gbox, res_model);
        end
        
        is_end = all(currentSet == res_optimization);
        
        if ~is_end
            currentSet = count_array(currentSet, res_optimization);
        end
    end
    
    maxwVolume = max(wVol{i}(:));
    
    [iOpt(1), iOpt(2)] = find(wVol{i} == maxwVolume);
    
    opt = zeros(1, numParams);
    for j = 1:numParams
        opt(j) = paramSets{i}{j}(iOpt(j));
        
        newRange = (currentLimits{j}(2) - currentLimits{j}(1)) * shrink;
        
        if opt(j) + newRange/2 > lensLimits{j}(2)
            currentLimits{j}(1) = opt(j) - newRange;
        elseif opt(j) - newRange/2 < lensLimits{j}(1)
            currentLimits{j}(2) = opt(j) + newRange;
        else
            currentLimits{j} = [opt(j) - newRange/2, opt(j) + newRange/2];
        end
    end
    
    paramSets{i+1} = cellfun(@(x) linspace(x(1), x(2), res_optimization), ...
                           currentLimits, ...
                           'UniformOutput', false);
    currentSet = ones(1, length(lensLimits));
    is_end = 0;
end

for i = 1:zoomCount
    [X,Y] = meshgrid(paramSets{i}{1}, paramSets{i}{2});
    surf(X, Y, wVol{i}');
end

xlabel("Link 1 Length");
ylabel("Link 2 + Link 3 Length");
zlabel("Gamut Envelope Weighted Volume");

view(-37.5, 30);
set(gcf, 'Position', [0 0 1000 1000]);
saveas(gcf, 'output/optimization.png');

optLens = [opt(1), len2, opt(2) - len2];

disp("Optimal link lengths:");
disp(optLens);

save('output/optimization_data.mat', 'wVol', 'paramSets', 'optLens', 'maxwVolume');