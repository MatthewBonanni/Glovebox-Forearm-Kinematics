function [endpts, bound, vol] = mobility(ValkArm, box)
%MOBILITY Compute mobility of given arm model in the given glove box
%   ValkArm - RigidBodyTree model of arm

resolution = 20;

% Determine which joints are non-fixed
acts = cellfun(@(x) ~strcmp(x.Joint.Type, 'fixed'), ValkArm.Bodies);

numActs = sum(acts);

% Create joint position arrays
posArrays = cellfun(@(x) linspace(x.Joint.PositionLimits(1), ...
                                  x.Joint.PositionLimits(2), ...
                                  resolution), ...
                    ValkArm.Bodies(acts), 'UniformOutput', false);

% Create config and fill joint names
config = cell2struct(cellfun(@(x) x.Joint.Name, ...
                             ValkArm.Bodies(acts), ...
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
    tform = getTransform(ValkArm, config, 'linkE', 'base');
    
    % Add endpoint to array
    endpts = cat(1, endpts, tform2trvec(tform));
    
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

endpts = endpts(endpts(:,1) < (box.w/2 - box.x_collar),:); % remove points past side wall
endpts = endpts(endpts(:,2) < box.d,:); % remove points past rear wall
endpts = endpts(endpts(:,3) > -box.floor,:); % remove points below floor

endpts(:,1) = endpts(:,1) + box.x_collar; % shift points to box opening

[bound, vol] = boundary(endpts, 0.8); % determine boundary - maximum shrink

end