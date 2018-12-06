function [] = plot_optimization(paramSets, wVol)
%PLOT_OPTIMIZATION Visualize optimization data

figure;
hold on;

for i = 1:length(wVol)
    [X,Y] = meshgrid(paramSets{i}{1}, paramSets{i}{2});
    surf(X, Y, wVol{i}');
end

xlabel("Link 1 Length (m)");
ylabel("Link 2 + Link 3 Length (m)");
zlabel("Gamut Envelope Weighted Volume");

view(-37.5, 30);
set(gcf, 'Position', [0 0 500 500]);

end

