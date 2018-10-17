function flag = valid_lens(lens)
%VALID_LENS Determine whether the actuators and structure are capable of
%bearing the mass of the arm with the given lengths

g = 9.81;

% Note: Assume len(2) fixed at 0.082

elbowToPlate = 0.065;
plateToAct1 = 0.05;
YHbaseToPalm = 0.075;

% Measured from elbow

m_act1 = 0.370;
l_act1_COM = 0.03 + elbowToPlate;

m_link1 = 0.153;
l_link1_COM = (lens(1) - elbowToPlate - plateToAct1) / 2 + plateToAct1 + elbowToPlate;

m_act2 = 0.135;
l_act2_COM = lens(1) - 0.016;

% Measured from pitch axis

m_link2 = 0.064;
l_link2_COM = lens(2) - 0.055;

m_act3 = 0.082;
l_act3_COM = lens(2) - 0.021;

m_link3 = 0.289;
l_link3_COM = (lens(3) - YHbaseToPalm) / 2;

m_hand = 0.740;
l_hand_COM = lens(3) - (YHbaseToPalm / 2);

m_payload = 0;
l_payload = lens(3);

Tmax_act1 = 3;
Tmax_act2 = 3;
Tmax_act3 = 1.25;

T_required = m_act3 * g * l_act3_COM + ...
             m_link3 * g * l_link3_COM + ...
             m_hand * g * l_hand_COM + ...
             m_payload * g * l_payload;

if T_required > Tmax_act1
    flag = 0;
else
    flag = 1;
end

end

% m_act1 = 0.370;
% y_act1_COM = 0.03 + elbowToPlate;
% 
% m_link1 = 0.153;
% y_link1_COM = 0.096 + elbowToPlate;
% 
% m_act2 = 0.135;
% y_act2_COM = 0.145 + elbowToPlate;
% 
% m_link2 = 0.064;
% y_link2_COM = 0.188 + elbowToPlate;
% 
% m_act3 = 0.082;
% y_act3_COM = 0.222 + elbowToPlate;
% 
% m_link3 = 0.289;
% y_link3_COM = 0.290 + elbowToPlate;
% 
% m_hand = 0.740;
% y_hand_COM = 0.373 + elbowToPlate;
