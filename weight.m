function [outPts] = weight(inPts, gbox)
%WEIGHT Calculate weighted point values for use in weighted volume
%calculation

period = 2 * gbox.h;
amp = 1/2;

outPts(:,1) = inPts(:,1);
outPts(:,2) = inPts(:,2);

height = inPts(:,3) + gbox.floor;

scaledHeight = height .* (amp * cos((2*pi/period) * height) + amp);

outPts(:,3) = scaledHeight - gbox.floor;

end