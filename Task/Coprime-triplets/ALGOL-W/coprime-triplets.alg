begin % find a sequence of coprime triplets, each element is coprime to the  %
      % two predeccessors and hasn't appeared in the list yet, the first two %
      % elements are 1 and 2                                                 %
    integer procedure gcd ( integer value m, n ) ;
    begin
        integer a, b;
        a := abs m;
        b := abs n;
        while b not = 0 do begin
            integer newA;
            newA := b;
            b    := a rem b;
            a    := newA
        end while_b_ne_0 ;
        a
    end gcd ;
    % construct the sequence %
    integer array seq ( 1 :: 49 );
    integer sCount;
    seq( 1 ) := 1; seq( 2 ) := 2; for i := 3 until 49 do seq( i ) := 0;
    for i := 3 until 49 do begin
        integer s1, s2, lowest;
        s1     := seq( i - 1 );
        s2     := seq( i - 2 );
        lowest := 2;
        while begin logical candidate;
                    lowest    := lowest + 1;
                    candidate := gcd( s1, lowest ) = 1 and gcd( s2, lowest ) = 1;
                    if candidate then begin
                        % lowest is coprime to the previous two elements %
                        % check it hasn't appeared already               %
                        for pos := 1 until i - 1 do begin
                            candidate := candidate and lowest not = seq( pos );
                        end for_pos ;
                        if candidate then seq( i ) := lowest;
                    end if_lowest_coprime_to_s1_and_s2 ;
                    not candidate and lowest < 50
        end do begin end while_not_found
    end for_i ;
    % show the sequence %
    sCount := 0;
    for i := 1 until 49 do begin
        if seq( i ) not = 0 then begin
            writeon( i_w := 2, s_w := 0, " ", seq( i ) );
            sCount := sCount + 1;
            if sCount rem 10 = 0 then write()
        end if_seq_i_ne_0
    end for_i ;
    write( i_w := 1, s_w := 0, sCount, " coprime triplets below 50" )
end.
