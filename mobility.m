function [endpts, bound, vol] = mobility(ValkArm, box)
%MOBILITY Compute mobility of given arm model in the given glove box
%   ValkArm - RigidBodyTree model of arm

resolution = 20;

bAct2 = ValkArm.Bodies{2}.Joint;
act1 = ValkArm.Bodies{3}.Joint;
act2 = ValkArm.Bodies{4}.Joint;
act3 = ValkArm.Bodies{5}.Joint;

bAct2_pos = linspace(bAct2.PositionLimits(1), ...
                     bAct2.PositionLimits(2), ...
                     resolution);
act1_pos = linspace(act1.PositionLimits(1), ...
                    act1.PositionLimits(2), ...
                    resolution);
act2_pos = linspace(act2.PositionLimits(1), ...
                    act2.PositionLimits(2), ...
                    resolution);
act3_pos = linspace(act3.PositionLimits(1), ...
                    act3.PositionLimits(2), ...
                    resolution);

%config = ValkArm.randomConfiguration;
config = struct('JointName', [], 'JointPosition', []);
config(1).JointName = 'bLink2';
config(2).JointName = 'link1';
config(3).JointName = 'link2';
config(4).JointName = 'link3';

endpts = [];

f = waitbar(0, 'Computing mobility envelope...', 'Name', 'Progress');

for i = 1:length(bAct2_pos)
    config(1).JointPosition = bAct2_pos(i);
    %config(1).JointPosition = 0;
    
    for j = 1:length(act1_pos)
        config(2).JointPosition = act1_pos(j);
        
        for k = 1:length(act2_pos)
            config(3).JointPosition = act2_pos(k);
            
            for l = 1:length(act3_pos)
                config(4).JointPosition = act3_pos(l);
                
                % Calculate transform matrix
                tform = getTransform(ValkArm, config, 'linkE', 'base');
                
                % Add endpoint to array
                endpts = cat(1, endpts, tform2trvec(tform));
            end
        end
    end
    waitbar(i / resolution);
end

endpts = endpts(endpts(:,1) < (box.w/2 - box.x_collar),:); % remove points past side wall
endpts = endpts(endpts(:,2) < box.d,:); % remove points past rear wall
endpts = endpts(endpts(:,3) > -box.floor,:); % remove points below floor

endpts(:,1) = endpts(:,1) + box.x_collar; % shift points to box opening

[bound, vol] = boundary(endpts, 1); % determine boundary - maximum shrink

delete(f);

end