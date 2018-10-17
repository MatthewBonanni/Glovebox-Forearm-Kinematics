function [] = plot_arms(arm, config, gbox)
%PLOT_ARM Visualize arm inside glovebox

figure();

hold on;

%% Plot glovegbox

x = [0 0 0 0 0 1; 1 0 1 1 1 1; 1 0 1 1 1 1; 0 0 0 0 0 1];
y = [0 0 0 0 1 0; 0 1 0 0 1 1; 0 1 1 1 1 1; 0 0 1 1 1 0];
z = [0 0 1 0 0 0; 0 0 1 0 0 0; 1 1 1 0 1 1; 1 1 1 0 1 1];

x = gbox.w * (x - 0.5) + 0;
y = gbox.d * (y - 0.5) + gbox.d/2;
z = gbox.h * (z - 0.5) + gbox.h/2 - gbox.floor;

fill3(x, y, z, 'black', 'FaceAlpha', 0.1);    % draw cube

%% Plot collars

[collar.x, collar.y, collar.z] = cylinder(gbox.d_collar / 2);

collar.z = collar.z * gbox.t_collar;

ringOld1 = [collar.x(1,:)', collar.y(1,:)', collar.z(1,:)'];
ringOld2 = [collar.x(2,:)', collar.y(2,:)', collar.z(2,:)'];

rot = axang2rotm([1 0 0 pi/2]);

ringNew1 = ringOld1 * rot;
ringNew2 = ringOld2 * rot;

collar.x = [ringNew1(:,1), ringNew2(:,1)];
collar.y = [ringNew1(:,2), ringNew2(:,2)];
collar.z = [ringNew1(:,3), ringNew2(:,3)];

collar.x = collar.x + gbox.x_collar;
collar.y = collar.y - gbox.t_collar / 2;

surf(collar.x, collar.y, collar.z, 'FaceColor', 'black');
surf(-collar.x, collar.y, collar.z, 'FaceColor', 'black');

%% Plot arm cylinders

for i = 5:length(arm.dias)
    
    if arm.lens(i) == 0
        continue
    end
    
    [x, y, z] = cylinder(arm.dias(i) / 2);
    
    z = z * arm.lens(i);
    
    ringOld1 = [x(1,:)', y(1,:)', z(1,:)', ones(size(x(1,:)'))];
    ringOld2 = [x(2,:)', y(2,:)', z(2,:)', ones(size(x(2,:)'))];
    
    basePt = tform2trvec(getTransform(arm.rbt, ...
                                      config, ...
                                      arm.rbt.BodyNames{i-1}, ...
                                      'base'));
    endPt = tform2trvec(getTransform(arm.rbt, ...
                                     config, ...
                                     arm.rbt.BodyNames{i}, ...
                                     'base'));
    segAxis = endPt - basePt;
    segAxis = segAxis / norm(segAxis);
    cylAxis = [0 0 1];
    
    n = cross(cylAxis, segAxis); % normal vector between cylinder axis and segment axis
    theta = acos(dot(cylAxis, segAxis));
    
    rotm = axang2rotm([n theta]);
    
    tform = trvec2tform(basePt);
    tform(1:3, 1:3) = rotm;
    
    ringNew1 = (tform * ringOld1')';
    ringNew2 = (tform * ringOld2')';
    
    x = [ringNew1(:,1), ringNew2(:,1)] + gbox.x_collar;
    y = [ringNew1(:,2), ringNew2(:,2)];
    z = [ringNew1(:,3), ringNew2(:,3)];
    
    surf(x, y, z, 'FaceColor', 'blue');
    surf(-x, y, z, 'FaceColor', 'blue');
end

%% Plot end effector sphere

endPt = tform2trvec(getTransform(arm.rbt, config, 'linkE', 'base'));

r = 0.04;

[endEff.x, endEff.y, endEff.z] = sphere;

endEff.x = r * endEff.x + endPt(1) + gbox.x_collar;
endEff.y = r * endEff.y + endPt(2);
endEff.z = r * endEff.z + endPt(3);

surf(endEff.x, endEff.y, endEff.z, 'FaceColor', 'red');
surf(-endEff.x, endEff.y, endEff.z, 'FaceColor', 'red');

%% Misc. config

view(37.5, 30);
axis equal;
set(gcf, 'Position', [0 0 1000 1000]);

end