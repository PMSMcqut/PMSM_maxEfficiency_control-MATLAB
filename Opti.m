% 目標トルク
desiredTorque = 5.0;

% 目標電流
Ia = ( ( 2 * desiredTorque ) / ( Pn * Phia ) );

% id, iqの描画範囲
idRange = ( -100:1:100 )';
iqRange = ( -100:1:100 )';

%% 2D描画（最大トルク制御）
figure(1); hold on;

% 角度 ( 0 -> 2 * pi )
th = linspace( 0, 2 * pi, 100 )';

xConst = Ia * cos( th );
yConst = Ia * sin( th );
plot( xConst, yConst, 'Color', [0.0,1.0,0.0] );

% 目標トルク断面でのトルク曲線
TorqueRange = linspace( 0.5, 10, 20 )';
for cnt = 1:length( TorqueRange )
    iqout = iqFunc( idRange, TorqueRange(cnt), Pn, Phia, Ld, Lq );
    plot( idRange, iqout, 'Color', [0.5,0.5,0.5] ); hold on;
end

% 最適電流位相
beta = asin( ( -Phia + sqrt( Phia^2 + 8 * ( Ld - Lq )^2 * Ia^2 ) ) / ( 4 * ( Lq - Ld ) * Ia ) );

% 最大トルクベクトルの描画
var = [ -Ia * sin( beta );Ia * cos( beta ) ]; % d軸電流，q軸電流
scatter( var(1), var(2), 'MarkerFaceColor', [0,1,0], 'MarkerEdgeColor', 'None' );
sqrt( var(1)^2 + var(2)^2 )

% 目標トルク断面でのトルク曲線(id=0)
iqout = iqFunc( idRange, desiredTorque, Pn, Phia, Ld, Lq );
plot( idRange, iqout, 'Color', [0,0,1] );

% buff = (Pn/2) * ( Phia * var(2) + ( Lq - Ld ) * var(1) * var(2) );
MaxTorque = ( Pn / 2 ) * Phia * Ia * cos( beta ) + ( Pn / 2 ) * ( Lq - Ld ) * Ia^2 * sin( 2 * beta ) / 2;

iqout = iqFunc( idRange, MaxTorque, Pn, Phia, Ld, Lq );
plot( idRange, iqout, 'Color', [0.0,0.0,1.0] ); hold on;

% 最適ベクトルの描画
r = 0:1:100;
th = atan2( var(2), var(1) );
x = r * cos( th );
y = r * sin( th );
plot( x, y, 'Color', [0,1,0] );

% id=0ベクトルの描画
r = 0:1:100;
th = pi / 2;
x = r * cos( th );
y = r * sin( th );
plot( x, y, 'Color', [1,0,0] );
scatter( 0, ( ( 2 * desiredTorque ) / ( Pn * Phia ) ), 'MarkerFaceColor', [1,0,0], 'MarkerEdgeColor', 'None' );
sqrt( 0^2 + ( ( 2 * desiredTorque ) / ( Pn * Phia ) )^2 )

axis( [min(idRange), max(idRange), min(iqRange), max(iqRange) ] );
axis equal;

%% 2D描画（最大効率制御）
figure(2); hold on;

% 角度 ( 0 -> 2 * pi )
th = linspace( 0, 2 * pi, 50 )';

% 同心円の間隔
rRange = ( 0:5:100 )';

% 電流の同心円
for cnt = 1:length( rRange )
    xConst = rRange(cnt) * cos( th );
    yConst = rRange(cnt) * sin( th );
    plot( xConst, yConst, 'Color', [0.5,0.5,0.5] );
end

% 目標トルク断面でのトルク曲線
iqout = iqFunc( idRange, desiredTorque, Pn, Phia, Ld, Lq );
plot( idRange, iqout, 'Color', [0,0,1] );

% ニュートン法での最高効率駆動
% 初期値 [ id, iq, lmd ]
var = [ 0;( ( 2 * desiredTorque ) / ( Pn * Phia ) );0; ];

for cnt = 1:3
    var = var - HessianMatrix( desiredTorque, var(1), var(2), var(3), Pn, Ld, Lq, Phia) \ GradVector( desiredTorque, var(1), var(2), var(3), Pn, Ld, Lq, Phia);
end

scatter( var(1), var(2), 'MarkerFaceColor', [0,1,0], 'MarkerEdgeColor', 'None' );
sqrt( var(1)^2 + var(2)^2 )

% 接円の描画
r = sqrt( var(1)^2 + var(2)^2 );
th = linspace( 0, 2 * pi, 100 )';
x = r * cos( th );
y = r * sin( th );
plot( x, y, 'Color', [0,1,0] );

% 最適ベクトルの描画
r = 0:1:100;
th = atan2( var(2), var(1) );
x = r * cos( th );
y = r * sin( th );
plot( x, y, 'Color', [0,1,0] );

% id=0ベクトルの描画
r = 0:1:100;
th = pi / 2;
x = r * cos( th );
y = r * sin( th );
plot( x, y, 'Color', [1,0,0] );
scatter( 0, ( ( 2 * desiredTorque ) / ( Pn * Phia ) ), 'MarkerFaceColor', [1,0,0], 'MarkerEdgeColor', 'None' );
sqrt( 0^2 + ( ( 2 * desiredTorque ) / ( Pn * Phia ) )^2 )

axis( [min(idRange), max(idRange), min(iqRange), max(iqRange) ] );
axis equal;

%% 3D描画
figure(3); hold on;

% トルクマップの描画
[ Id, Iq ] = meshgrid( idRange, iqRange );
T = Tfunc( Id, Iq, Pn, Phia, Ld, Lq );
surf( Id, Iq, T, 'LineStyle', 'none' ); hold on;

% 同心円の間隔
rRange = ( 0:5:100 )';
% 角度 ( 0 -> 2 * pi )
th = linspace( 0, 2 * pi, 50 )';

% 電流の同心円
for cnt = 1:length( rRange )
    xConst = rRange(cnt) * cos( th );
    yConst = rRange(cnt) * sin( th );
    plot3( xConst, yConst, desiredTorque * ones( size( th ) ), 'Color', [0.5,0.5,0.5] );
end


% ニュートン法での最大効率制御
% 動作点
% 初期値 [ id, iq, lmd ]
var = [ 0;0;0; ];
for cnt = 1:10
    var = var - HessianMatrix( desiredTorque, var(1), var(2), var(3), Pn, Ld, Lq, Phia) \ GradVector( desiredTorque, var(1), var(2), var(3), Pn, Ld, Lq, Phia);
end
scatter3( var(1), var(2), desiredTorque, 'MarkerFaceColor', [1,0,0], 'MarkerEdgeColor', 'None' );

% 接円
r = sqrt( var(1)^2 + var(2)^2 );
th = linspace( 0, 2 * pi, 100 )';
x = r * cos( th );
y = r * sin( th );
plot3( x, y, desiredTorque * ones( size( x ) ), 'Color', [1,0,0] );

% 接円中心から動作点までの線
r = 0:1:100;
th = atan2( var(2), var(1) );
x = r * cos( th );
y = r * sin( th );
plot3( x, y, desiredTorque * ones( size( x ) ),'Color', [1,0,0] );

% 目標トルク断面でのトルク曲線
iqout = iqFunc( idRange, desiredTorque, Pn, Phia, Ld, Lq );
plot3( idRange, iqout, desiredTorque * ones( size( idRange ) ), 'Color', [0,0,1] );


% 最大トルク制御
% 動作点
scatter3( -Ia * sin( beta ), Ia * cos( beta ), MaxTorque, 'MarkerFaceColor', [1,0,0], 'MarkerEdgeColor', 'None' )

% 接円
r = Ia;
th = linspace( 0, 2 * pi, 100 )';
x = r * cos( th );
y = r * sin( th );
plot3( x, y, MaxTorque * ones( size( x ) ), 'Color', [1,0,0] );

% 接円中心から動作点までの線
r = 0:1:100;
x = -r * sin( beta );
y = r * cos( beta );
plot3( x, y, MaxTorque * ones( size( x ) ), 'Color', [1,0,0] );

% 目標トルク断面でのトルク曲線
iqout = iqFunc( idRange, MaxTorque, Pn, Phia, Ld, Lq );
plot3( idRange, iqout, MaxTorque * ones( size( idRange ) ), 'Color', [0,0,1] );


% id=0制御
% 動作点
scatter3( 0, Ia, desiredTorque, 'MarkerFaceColor', [1,0,0], 'MarkerEdgeColor', 'None' )

% 接円は省略

% 接円中心から動作点までの線
r = 0:1:100;
th = pi / 2;
x = r * cos( th );
y = r * sin( th );
plot3( x, y, desiredTorque * ones( size( x ) ), 'Color', [1,0,0] );

% 目標トルク断面でのトルク曲線は省略

% 軸の設定
axis( [min(idRange), max(idRange), min(iqRange), max(iqRange) ] );

%% ラベル
figure(1);
xlabel('Current of d-axis i_d');
ylabel('Current of q-axis i_q');
axis( [min(idRange), max(idRange), min(iqRange), max(iqRange) ] );

figure(2);
xlabel('Current of d-axis i_d');
ylabel('Current of q-axis i_q');
axis( [min(idRange), max(idRange), min(iqRange), max(iqRange) ] );

figure(3);
xlabel('Current of d-axis i_d');
ylabel('Current of q-axis i_q');
zlabel('Torque T');
axis( [min(idRange), max(idRange), min(iqRange), max(iqRange) ] );

