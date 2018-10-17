function [] = plot_gamut(endpts, bound, gbox)
%PLOT_RANGE Visualize gamut data

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

%% Plot envelopes

trisurf(bound, endpts(:,1), endpts(:,2), endpts(:,3), ...
        'Facecolor', 'blue', ...
        'FaceAlpha', 0.5, ...
        'EdgeAlpha', 0.6);
trisurf(bound, -endpts(:,1), endpts(:,2), endpts(:,3), ...
        'Facecolor', 'blue', ...
        'FaceAlpha', 0.5, ...
        'EdgeAlpha', 0.6);

%% Misc. config

view(37.5, 30);
axis equal;
set(gcf, 'Position', [0 0 1000 1000]);

end