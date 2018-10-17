function [] = plot_cloud(endpts)
%PLOT_CLOUD Generate scatter plot of given point cloud

scatter3(endpts(:,1), endpts(:,2), endpts(:,3), 'b.')

view(37.5, 30);
axis equal;
set(gcf, 'Position', [0 0 1000 1000]);

end