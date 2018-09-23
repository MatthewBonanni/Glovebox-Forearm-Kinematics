def_old();

resolution = 20;

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

for i = 1:length(bAct2_pos)
    %config(1).JointPosition = bAct2_pos(i);
    config(1).JointPosition = 0;
    
    for j = 1:length(act1_pos)
        config(2).JointPosition = act1_pos(j);
        
        for k = 1:length(act2_pos)
            config(3).JointPosition = act2_pos(k);
            
            % This joint only affects orientation of end effector -
            % ignoring for now
            config(4).JointPosition = act3_pos(1);
            
            % Calculate transform matrix
            tform = getTransform(ValkArm, config, 'linkE', 'base');
            
            % Add endpoint to array
            endpts = cat(1, endpts, tform2trvec(tform));
        end
    end
end

plot_range;

%showdetails(ValkArm);
%show(ValkArm, config);