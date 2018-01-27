function [ torque, Ia ] = generateTorqueMap( IaMin, IaMax, div, Pn, Phia, Ld, Lq )
    % マップ化する電流範囲
    Ia = linspace( IaMin, IaMax, div )';
    
    % ゼロ割回避
    Ia( abs( Ia ) < eps ) = eps;
    
    % 最適電流位相
    beta = asin( ( -Phia + sqrt( Phia.^2 + 8 * ( Ld - Lq ).^2 .* Ia.^2 ) ) ./ ( 4 * ( Lq - Ld ) .* Ia ) );

    % Iaごとの最大トルク
    torque = ( Pn / 2 ) * Phia .* Ia .* cos( beta ) + ( Pn / 2 ) * ( Lq - Ld ) * Ia.^2 .* sin( 2 * beta ) ./ 2;
end