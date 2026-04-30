begin % sleeping beauty problem - translated from the Wren sample, via Agena %

    integer seed;                        % seed for random number generation %

    % returns the next middle-square random number in [0..1)                 %
    real procedure random ;
    begin
        if seed = 0 then seed := time( -1 ) rem 10000;
        seed := ( ( seed * seed ) div 100 ) rem 10000;
        seed / 10000
    end random ;

    real procedure sleepingBeauty( integer value reps ) ;
    begin
        integer wakings, heads;
        wakings := heads := 0;
        for i := 1 until reps do begin
            wakings := wakings + 1;
            if random < 0.5 then begin
                heads   := 1 + heads                      % [0..0.5) = heads %
            end else begin
                wakings := 1 + wakings                    % [0.5..1) = tails %
            end if__random_lt_500000__
        end for_i ;
        write( i_w := 1, s_w := 0, "Wakings over ", reps, " repetitions = ", wakings );
        ( heads / wakings ) * 100
    end sleepingBeauty ;

    begin
        real pc;
        seed := 0;                  % initialise the random number generator %
        pc := sleepingBeauty( 1000000 );
        write( s_w := 0, "Percentage probability of heads on waking = ", pc, "%" )
    end
end.
