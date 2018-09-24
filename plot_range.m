function [] = plot_range(endpts, bound, box)
%PLOT_RANGE Visualize mobility range data

figure();

hold on;

%% Plot glovebox

x = [0 0 0 0 0 1; 1 0 1 1 1 1; 1 0 1 1 1 1; 0 0 0 0 0 1];
y = [0 0 0 0 1 0; 0 1 0 0 1 1; 0 1 1 1 1 1; 0 0 1 1 1 0];
z = [0 0 1 0 0 0; 0 0 1 0 0 0; 1 1 1 0 1 1; 1 1 1 0 1 1];

x = box.w * (x - 0.5) + 0;
y = box.d * (y - 0.5) + box.d/2;
z = box.h * (z - 0.5) + box.h/2 - box.floor;

fill3(x, y, z, 'black', 'FaceAlpha', 0.1);    % draw cube

%% Plot collars

%% Plot envelopes

trisurf(bound, endpts(:,1), endpts(:,2), endpts(:,3), ...
        'Facecolor', 'blue', ...
        'FaceAlpha', 0.5, ...
        'EdgeAlpha', 0.6);
trisurf(bound, -endpts(:,1), endpts(:,2), endpts(:,3), ...
        'Facecolor', 'blue', ...
        'FaceAlpha', 0.5, ...
        'EdgeAlpha', 0.6);

view(37.5, 30);
axis equal;
set(gcf, 'Position', [0 0 1000 1000]);

end