begin % generate random numbers by the middle-square method %
    integer seed;
    % returns the next middle-square random number          %
    integer procedure msRandom ;
    begin
        real realSeed;
        realSeed := seed;
        realSeed := ( realSeed * realSeed ) / 1000;
        seed := entier( realSeed ) rem 1000000;
        seed
    end msRandom ;
    % test the ms random procedure                          %
    seed := 675248;
    for i := 1 until 5 do write( msRandom )
end.
