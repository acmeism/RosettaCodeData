begin % implements packed BCD arithmetic                                     %
    integer X99;                        % maximum unsigned 2-digit BCD value %
    % structure to hold BCD values                                           %
    record BCD ( integer dValue             % signed BCD value:  -x99 to x99 %
               ; logical dCarry             % TRUE if the value overflowed,  %
               );                           % FALSE otherwise                %
    reference(BCD) bcd99, bcd1;
    % constructs a BCD value from a, assuming it is in the correct format    %
    % if the value has overflowed, it is truncated to a valid value and      %
    % carry is set                                                           %
    reference(BCD) procedure asBcd ( integer value a ) ;
    begin
        integer v;
        logical carry;
        v     := abs a;
        carry := v > X99;
        if carry then v := ( ( ( v div 16 ) rem 10 ) * 16 ) + ( v rem 16 );
        BCD( if a < 0 then - v else v, carry )
    end asBcd ;
    % returns a converted to BCD format, truncating and setting carry        %
    %         if necessary                                                   %
    reference(BCD) procedure toBcd ( integer value a ) ;
        if   a < 0
        then negateBcd( toBcd( abs a ) )
        else BCD( ( ( ( a div 10 ) rem 10 ) * 16 ) + ( a rem 10 ), a > X99 )
        ;
    % returns the value of b negated, carry is preserved                     %
    reference(BCD) procedure negateBcd ( reference(BCD) value a ) ; BCD( - dValue(a), dCarry(a) );
    % writes a two-digit string representation of the BCD value a            %
    procedure writeOnBcd ( reference(BCD) value a ) ;
    begin
        if dValue(a) < 0 then writeon( s_w := 0, "-" );
        writeon( i_w := 1, s_w := 0
               , abs dValue(a) div 16
               , abs dValue(a) rem 16
               )
    end writeOnBcd;
    % writes a BCD value with a preceeding newline                           %
    procedure writeBcd ( reference(BCD) value a ) ; begin write(); writeOnBcd( a ) end;
    % writes an array of BCD values - the bounds should be 1 :: ub           %
    procedure showBcd ( reference(BCD) array a ( * ); integer value ub ) ;
        for i := 1 until ub do writeOnBcd( a( i ) );

    % returns the sum of a and b, a and b can be positive or negative        %
    reference(BCD) procedure addBcd ( reference(BCD) value a, b ) ;
    begin
        integer av, bv, a2, b2, bcdResult;
        logical ap, bp;
        av := abs dValue(a);      bv := abs dValue(b);
        ap :=     dValue(a) >= 0; bp :=     dValue(b) >= 0;
        a2 := av rem 16;          b2 := bv rem 16;
        if    ap = bp then begin
            bcdResult := av + bv;
            if a2 + b2 > 9 then bcdResult :=   bcdResult + 6;
            if not ap      then bcdResult := - bcdResult
            end
        else if av >= bv then begin
            bcdResult := av - bv;
            if a2 < b2 then bcdResult :=   bcdResult - 6;
            if not ap  then bcdResult := - bcdResult
            end
        else begin
            bcdResult := bv - av;
            if b2 < a2 then bcdResult :=   bcdResult - 6;
            if ap      then bcdResult := - bcdResult
        end if_ap_eq_bp__av_ge_bv__;
        if bcdResult >= 0 then begin                    % result is positive %
            asBcd( bcdResult )
            end
        else begin                       % negative result - tens complement %
            reference(BCD) sum;
            sum := addBcd( addBcd( bcd99, asBcd( bcdResult ) ), bcd1 );
            dCarry(sum) := true;
            sum
        end if_bcdResult_ge_0__
    end addBcd;
    % returns the difference of a and b, a and b can be positive or negative %
    reference(BCD) procedure subtractBcd ( reference(BCD) value a, b ) ; addBcd( a, negateBcd( b ) );

    X99   := ( 9 * 16 ) + 9;
    bcd99 := toBcd( 99 );
    bcd1  := toBcd(  1 );

    begin % task test cases                                                  %
        reference(BCD) r;
        writeBcd( addBcd(      toBcd( 19 ), toBcd( 1 ) ) );
        writeBcd( subtractBcd( toBcd( 30 ), toBcd( 1 ) ) );
        r := addBcd(           toBcd( 99 ), toBcd( 1 ) );
        if dCarry(r) then write( s_w := 0, "1" );
        writeOnBcd( r );
    end;

    begin % use the 2-digit BCD to add/subtract larger numbers               %
        reference(BCD) array d12, a12 ( 1 :: 6 );
        integer dPos;
        write();
        dPos := 0;
        for v := 1, 23, 45, 67, 89, 01 do begin
            dPos := dPos + 1;
            d12( dPos ) := toBcd( v )
        end for_v ;
        dPos := 0;
        for v := 1, 11, 11, 11, 11, 11 do begin
            dPos := dPos + 1;
            a12( dPos ) := toBcd( v )
        end for_v ;
        for i := 1 until 10 do begin             % repeatedly add a12 to d12 %
            logical carry;
            write();showBcd( d12, 6 );writeon( " + " );showBcd( a12, 6 );writeon( " = " );
            carry := false;
            for bPos := 6 step -1 until 1 do begin
                logical needCarry;
                d12( bPos ) := addBcd( d12( bPos ), a12( bPos ) );
                needCarry := dCarry(d12( bPos ));
                if carry then d12( bPos ) := addBcd( d12( bPOs ), bcd1 );
                carry := needCarry or dCarry(d12( bPos ))
            end for_bPos ;
            showBcd( d12, 6 )
        end for_i;
        for i := 1 until 10 do begin      % repeatedly subtract a12 from d12 %
            logical carry;
            write();showBcd( d12, 6 );writeon( " - " );showBcd( a12, 6 );writeon( " = " );
            carry := false;
            for bPos := 6 step -1 until 1 do begin
                logical needCarry;
                d12( bPos ) := subtractBcd( d12( bPos ), a12( bPos ) );
                needCarry := dCarry(d12( bPos ));
                if carry then d12( bPos ) := subtractBcd( d12( bPOs ), bcd1 );
                carry := needCarry or dCarry(d12( bPos ))
            end for_bPos ;
            showBcd( d12, 6 )
        end for_i;
    end

end.
