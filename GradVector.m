%% 勾配ベクトル
% df/did
% df/diq
% df/dlmd
function ret = GradVector( desiredTorque, id, iq, lmd, Pn, Ld, Lq, Phia)
    ret = [
        2 * id + lmd * ( ( Pn / 2 ) * ( Ld - Lq ) * iq );
        2 * iq + lmd * ( ( Pn / 2 ) * ( Phia + ( Ld - Lq ) * id ) );
        ( Pn / 2 ) * ( Phia * iq + ( Ld - Lq ) * id * iq ) - desiredTorque;
    ];
end