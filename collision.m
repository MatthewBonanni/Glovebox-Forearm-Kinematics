function flag = collision(arm, config, gbox)
%COLLISION Detect collision between arm and gbox
%   arm - arm.rbt model of robotic arm

%% Determine which segment is currently in the collar

for i = 2:arm.rbt.NumBodies
    
    % Point A: beginning of segment
    A = tform2trvec(getTransform(arm.rbt, config, arm.rbt.Bodies{i-1}.Name, 'base'));
    
    % Point B: end of segment
    B = tform2trvec(getTransform(arm.rbt, config, arm.rbt.Bodies{i}.Name, 'base'));
    
    % Vector from A to B
    delta = B - A;
    
    % Angle between arm axis and y axis
    theta = acosd(dot(delta / norm(delta), [0 1 0]));
    
    % Edge of cylinder
    s = (arm.dias(i) / 2) * sind(theta);
    
    cyl_aft = A(2) - s;
    cyl_fwd = B(2) + s;
    
    y_limit = (gbox.t_collar / 2);
    
    if arm.lens(i) == 0
        continue
    elseif cyl_aft >= y_limit % Arm is fully inside box
        flag = 0;
        return
    elseif cyl_aft < y_limit && cyl_fwd >= y_limit % Segment straddles collar
        break
    end
end

if B(2) < 0 % Arm is fully outside box
    flag = 1;
    return
end

%% Determine whether arm intersects collar

% Point C: intersection of arm axis with outside plane of collar
C(2) = -gbox.t_collar / 2;
C(1) = (delta(1)/delta(2))*(C(2)-A(2)) + A(1);
C(3) = (delta(3)/delta(2))*(C(2)-A(2)) + A(3);

% Point D: intersection of arm axis with inside plane of collar
D(2) = gbox.t_collar / 2;
D(1) = (delta(1)/delta(2))*(D(2)-A(2)) + A(1);
D(3) = (delta(3)/delta(2))*(D(2)-A(2)) + A(3);

% r position of the arm axis at C and D
r_C = sqrt(C(1)^2 + C(3)^2);
r_D = sqrt(D(1)^2 + D(3)^2);

% Max of the two
r_axis = max(r_C, r_D);

% Angle-adjusted radius of arm
h = arm.dias(i) / (2 * cosd(theta));

% Furthest extent of arm body
r_total = r_axis + h;

if r_total > gbox.d_collar / 2
    flag = 1;
else
    flag = 0;
end

end