function flag = valid_lens(lens)
%GET_TFORM Compute transformation matrix for given configuration

g = 9.81;
m_link1 = 0.100;
m_link2 = 0.059;
m_link3 = 0.4;
m_hand = 0.750;
m_act1 = 0.135;
m_act2 = 0.077;
m_payload = 0;

Tmax_act1 = 3;
Tmax_act2 = 1.25;

T_required = m_act2 * g * lens(2) + ...
             m_hand * g * (lens(2) + lens(3)) + ...
             m_payload * g * (lens(2) + lens(3)) + ...
             m_link2 * g * (lens(2) / 2) + ...
             m_link3 * g * lens(2) + (lens(3) / 2);

if T_required > Tmax_act1
    flag = 0;
else
    flag = 1;
end

end