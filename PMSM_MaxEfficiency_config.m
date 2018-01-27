close all;
clear;

% Electrical characteristics
% Resistance (Ohm)
R = 0.1197;

% Inductance of d-axis (H)
Ld = 0.97e-3;

% Inductance of q-axis (H)
Lq = 2.03e-3;

% EMF constant (Wb)
Ke = 0.0432;
Phia = Ke;

% Pole pairs number (-)
Pn = 3;

% Mechanical characteristics
% Inertia of moment
J = 1;

% Damping coefficient
D = 1;

% トルクマップの作成
[ torque_vec, Ia_vec ] = generateTorqueMap( -100, 100, 51, Pn, Phia, Ld, Lq );

% シミューレーション実行
sim( 'PMSM_MaxEfficiency' );

% 最大トルク制御の可視化
Opti