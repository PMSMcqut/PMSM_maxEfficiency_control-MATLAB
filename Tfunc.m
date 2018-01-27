function T = Tfunc( id, iq, Pn, Phia, Ld, Lq )
    T = ( Pn / 2 ) .* ( Phia .* iq + ( Ld - Lq ) .* id .* iq );
end