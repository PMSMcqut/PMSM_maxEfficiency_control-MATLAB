function iq = iqFunc( id, T, Pn, Phia, Ld, Lq )
    iq = ( 2 .* T ) ./ ( Pn .* ( Phia + ( Ld - Lq ) .* id ) );
end