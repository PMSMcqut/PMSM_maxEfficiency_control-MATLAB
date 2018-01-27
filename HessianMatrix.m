%% ÉwÉbÉZçsóÒ
% df/did.did, df/did.diq, df/did.dlmd
% df/diq.did, df/diq.diq, df/diq.dlmd
% df/dlmd.did, df/dlmd.diq, df/dlmd.dlmd
function ret = HessianMatrix( desiredTorque, id, iq, lmd, Pn, Ld, Lq, Phia)
    ret = [
        2, ( Pn / 2 ) * ( Ld - Lq ) * lmd, ( Pn / 2 ) * ( Ld - Lq ) * iq;
        ( Pn / 2 ) * ( Ld - Lq ) * lmd, 2, ( Pn / 2 ) * ( Phia + ( Ld - Lq ) * id );
        ( Pn / 2 ) * ( Ld - Lq ) * iq, ( Pn / 2 ) * ( Phia + ( Ld - Lq ) * id ), 0;
    ];
end