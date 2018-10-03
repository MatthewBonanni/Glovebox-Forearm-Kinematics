function [endpts, bound, vol] = gamut(arm, gbox, resolution)
%GAMUT Compute gamut of given arm model in the given glove gbox
%   arm - ValkArm model of robotic arm

rbt = arm.rbt;

% Determine which joints are non-fixed
acts = cellfun(@(x) ~strcmp(x.Joint.Type, 'fixed'), rbt.Bodies);

numActs = sum(acts);

% Create joint position arrays
posArrays = cellfun(@(x) linspace(x.Joint.PositionLimits(1), ...
                                  x.Joint.PositionLimits(2), ...
                                  resolution), ...
                    rbt.Bodies(acts), 'UniformOutput', false);

% Create config and fill joint names
config = cell2struct(cellfun(@(x) x.Joint.Name, ...
                             rbt.Bodies(acts), ...
                             'UniformOutput', false), ...
                     'JointName', 1)';

pos = ones(1, numActs);

endpts = [];

% Loop through all positions
while ~all(pos == resolution)
    
    % Set all joint positions
    for i = 1:numActs
        config(i).JointPosition = posArrays{i}(pos(i));
    end
    
    % Calculate transform matrix
    tform = getTransform(rbt, config, 'linkE', 'base');
    
    % If no conflict with gbox, add endpoint to list
    if ~collision(arm, config, gbox)
        endpts = cat(1, endpts, tform2trvec(tform));
    end
    
    disp(pos);
    pos = count_pos(pos);
end

function posOut = count_pos(posIn)
    len = length(posIn);
    posOut = posIn;
    
    if posIn(len) < resolution
        posOut(len) = posIn(len) + 1;
    else
        posOut = [count_pos(posIn(1:len - 1)), 1];
    end
end

endpts(:,1) = endpts(:,1) + gbox.x_collar; % shift points to gbox opening

[bound, vol] = boundary(endpts, 0.8); % determine boundary - maximum shrink

end