gbox.w = 1.16;
gbox.d = 0.74;
gbox.h = 0.9;
gbox.floor = 0.15;
gbox.x_collar = 0.3;
gbox.d_collar = 0.2;
gbox.t_collar = 0.02;

x = 1:100;
y = 1:100;
z = linspace(-gbox.floor, gbox.h - gbox.floor, 100);

inPts = [x' y' z'];

outPts = weight(inPts, gbox);

oldHeight = inPts(:,3) + gbox.floor;
newHeight = outPts(:,3) + gbox.floor;

w = newHeight ./ oldHeight;

plot(oldHeight, w, 'b-', 'LineWidth', 3);

xlabel("Height from Floor (m)");
ylabel("Weight");