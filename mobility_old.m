forearm_upper = [0; 200; 0];
forearm_lower = [0; 200; 0];

s = 100; % step count

roll_1 = linspace(-180, 180, s);
pitch = linspace(-90, 90, s);
roll_2 = linspace(-180, 180, s);

[roll_1, pitch, roll_2] = ndgrid(roll_1, pitch, roll_2);

roll_1_mats = arrayfun(@(x) rotmat(x, [0 1 0]), roll_1, 'UniformOutput', false);
pitch_mats = arrayfun(@(x) rotmat(x, [1 0 0]), pitch, 'UniformOutput', false);

upper_pts = cell(s, s, s);
[upper_pts{:}] = deal(forearm_upper);

lower_pts = cell(s, s, s);
[lower_pts{:}] = deal(forearm_lower);

lower_pts = cellfun(@mtimes, pitch_mats, lower_pts, 'UniformOutput', false);
lower_pts = cellfun(@mtimes, roll_1_mats, lower_pts, 'UniformOutput', false);

endpts = cellfun(@plus, upper_pts, lower_pts, 'UniformOutput', false);

X = cellfun(@(x) x(1), endpts);
X = reshape(X, [], 1);

Y = cellfun(@(x) x(2), endpts);
Y = reshape(Y, [], 1);

Z = cellfun(@(x) x(3), endpts);
Z = reshape(Z, [], 1);

scatter3(X, Y, Z, 'k.');
xlabel('x');
ylabel('y');
zlabel('z');
axis('equal');