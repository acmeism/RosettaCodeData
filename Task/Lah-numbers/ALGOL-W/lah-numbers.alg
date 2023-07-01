begin % calculate Lah numbers upto L( 12, 12 )                                      %
    % sets lahNumber to L( n, k ), lahScale is returned as the power of 10          %
    % lahNumber should be multiplied by                                             %
    % f must be a table of factorials to at least n                                 %
    procedure L ( integer value n, k
                ; integer array f ( * )
                ; integer result lahNumber, lahScale
                ) ;
        if      n = k          then begin lahNumber := 1;      lahScale := 0 end
        else if n = 0 or k = 0 then begin lahNumber := 0;      lahScale := 0 end
        else if k = 1          then begin lahNumber := f( n ); lahScale := 0 end
        else if k > n          then begin lahNumber := 0;      lahScale := 0 end
        else begin
            % general case: ( n! * ( n - 1 )! ) / ( k! * ( k - 1 )! ) / ( n - k )!  %
            % Algol W has only 32 bit signed integers so we need to avoid overflow  %
            % we re-arrange the above to:                                           %
            %   ( n! / k! / ( n - k ) ! )  -- t1                                    %
            % * ( ( n - 1 )! / ( k - 1 )!  -- t2                                    %
            % and if necessary, reduce t1 and t2 by powers of 10                    %
            integer t1, t2, d1, d2, v;
            t1 := f( n     ) div f( k     ) div f( n - k );
            t2 := f( n - 1 ) div f( k - 1 );
            % calculate the number of digits for t1 and t2                          %
            lahScale := d1 := d2 := 0;
            v := t1; while v > 0 do begin d1 := d1 + 1; v := v div 10 end;
            v := t2; while v > 0 do begin d2 := d2 + 1; v := v div 10 end;
            if d1 + d2 > 8 then begin
                % the result will overflow reduce t1 and t2 by an appropriate power %
                % of 10 and set lahScale accordingly                                %
                while t1 rem 10 = 0 do begin lahScale := lahScale + 1; t1 := t1 div 10 end;
                while t2 rem 10 = 0 do begin lahScale := lahScale + 1; t2 := t2 div 10 end;
            end if_d1_plus_d2_gt_8;
            lahNumber := t1 * t2
        end L;
    % table of factorials up to 12                                 %
    integer array factorial ( 1 :: 12 );
    % compute the factorials                                       %
    begin
        integer f; f := 1;
        for i := 1 until 12 do begin f := f * i; factorial( i ) := f end
    end;
    % show the Lah numbers                                         %
    write( "Unsigned Lah numbers" );
    write( "n/k " );
    for i := 0 until 12 do writeon( i_w := 11, s_w := 0, i );
    for n := 0 until 12 do begin
        write( s_w := 2, i_w := 2, n );
        for k := 0 until n do begin
            integer lahNumber, lahScale;
            L( n, k, factorial, lahNumber, lahScale );
            writeon( S_W := 0, i_w := 11 - lahScale, lahNumber );
            for s := 1 until lahScale do writeon( s_w := 0, "0" )
        end for_k
    end for_n
end.
