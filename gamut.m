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
is_end = 0;

% Loop through all positions
while ~is_end
    
    disp(pos);
    
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
    
    is_end = all(pos == resolution);
    
    if ~is_end
        pos = count_pos(pos);
    end
end

if arm.red
    theta_res = 5 * resolution;
    rot_endpts = endpts;
    
    for i = 1:(theta_res - 1)
        theta = (2 * pi / theta_res) * i;
        rotm = axang2rotm([0 1 0 theta]);
        rot_endpts = cat(1, rot_endpts, endpts * rotm);
    end
    
    endpts = rot_endpts;
end

endpts(:,1) = endpts(:,1) + gbox.x_collar; % shift points to gbox opening

endpts = endpts(endpts(:,1) < gbox.w/2,:); % remove points past side wall
endpts = endpts(endpts(:,2) > 0,:); % remove points behind front wall
endpts = endpts(endpts(:,2) < gbox.d,:); % remove points past rear wall
endpts = endpts(endpts(:,3) > -gbox.floor,:); % remove points below floor

[bound, vol] = boundary(endpts, 0.7); % determine boundary - maximum shrink

function posOut = count_pos(posIn)
    len = length(posIn);
    posOut = posIn;
    
    if posIn(len) < resolution
        posOut(len) = posIn(len) + 1;
    else
        posOut = [count_pos(posIn(1:len - 1)), 1];
    end
end

end