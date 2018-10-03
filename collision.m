function flag = collision(arm, config, gbox)
%COLLISION Detect collision between arm and gbox
%   arm - arm.rbt model of robotic arm

%% Determine which segment is currently in the collar

for i = 2:arm.rbt.NumBodies
    
    % Point A: beginning of segment
    A = tform2trvec(getTransform(arm.rbt, config, arm.rbt.Bodies{i-1}.Name, 'base'));
    
    % Point B: end of segment
    B = tform2trvec(getTransform(arm.rbt, config, arm.rbt.Bodies{i}.Name, 'base'));
    
    y_limit = (gbox.t_collar / 2) + (arm.dias(i) / 2);
    
    if A(2) >= y_limit % Arm is fully inside box
        flag = 0;
        return
    elseif A(2) < y_limit && B(2) >= y_limit % Segment straddles collar
        break
    end
end

if B(2) < 0 % Arm is fully outside box
    flag = 1;
    return
end

%% Determine whether arm intersects collar

% Vector from A to B
delta = B - A;

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
r_axis = max(abs(r_C), abs(r_D));

% Angle between arm axis and y axis
theta = atand(sqrt(delta(1)^2 + delta(3)^2) / delta(2));

% Angle-adjusted radius of arm
h = arm.dias(1) / (2 * cosd(theta));

% Furthest extent of arm body
r_total = r_axis + h;

if r_total > gbox.d_collar / 2
    flag = 1;
    return
end

%% Check whether endpoint is outside box

endpt = tform2trvec(getTransform(arm.rbt, config, 'linkE', 'base'));

if endpt(1) > (gbox.w / 2) - gbox.x_collar % remove points past side wall
    flag = 1;
    return
elseif endpt(2) > gbox.d % remove points past rear wall
    flag = 1;
    return
elseif endpt(3) < -gbox.floor % remove points below floor
    flag = 1;
    return
else
    flag = 0;
end

end