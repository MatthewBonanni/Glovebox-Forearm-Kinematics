function matrix = rotmat(theta, u)
%ROT_MATRIX Generates rotation matrix about given vector

% Cross product matrix
% https://en.wikipedia.org/wiki/Cross_product#Conversion_to_matrix_multiplication
u_cross = [0    -u(3)  u(2);
           u(3)  0    -u(1);
          -u(2)  u(1)  0];

% Generalized rotation matrix
% https://en.wikipedia.org/wiki/Rotation_matrix#Rotation_matrix_from_axis_and_angle
matrix = cosd(theta)*eye(3) + sind(theta)*u_cross + (1-cosd(theta))*(u'*u);

end