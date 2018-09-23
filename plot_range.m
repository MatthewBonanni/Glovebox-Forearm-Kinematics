function [] = plot_range(endpts, bound)
%PLOT_RANGE Visualize mobility range data

hold on;
trisurf(bound, endpts(:,1), endpts(:,2), endpts(:,3), 'Facecolor','red','FaceAlpha',0.3);
axis equal;

end