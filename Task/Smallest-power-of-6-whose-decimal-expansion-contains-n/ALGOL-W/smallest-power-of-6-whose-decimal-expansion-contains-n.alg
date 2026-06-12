begin % find the smallest power of 6 that contains n for 0 <= n <= 21           %
    % we assume that powers of 6 upto 6^32 will be sufficient                   %
    % as Algol W does not have integers longer than 32 bits, the powers         %
    % will be held in an array where each element is a single digit of the      %
    % power, the least significant digit of 6^n is in powers( n, 1 )            %
    % powers( n, 0 ) holds the number of digits in the nth power                %
    integer array powers ( 0 :: 32, 0 :: 32 ); % the powers                     %
    integer array lowest ( 0 :: 21 ); % the lowest power containing the idx     %

    % store the dPos'th digit (dVal) in power( p ), also set the lowest power   %
    % containing dVal or dVal * 10 + power( p, dVal - 1 ), if not already known %
    procedure store( integer value p, dPos, dVal ) ;
    begin
        integer d2;
        powers( p, dPos ) := dVal;
        if lowest( dVal ) < 0 then lowest( dVal ) := p;
        if dPos > 1 then begin
            d2 := ( dVal * 10 ) + powers( p, dPos - 1 );
            if d2 <= 21 and lowest( d2 ) < 0 then lowest( d2 ) := p
        end if_dPos_gt_1
    end store;

    for n := 0 until 21 do lowest( n ) := -1;
    store( 0, 1, 1 );         % 6^0 = 1, which is the lowest power containing 1 %
    powers( 0, 0 ) := 1;
    for d := 2 until 32 do powers( 0, d ) := 0;
    % calculate the remaining powers and find the numbers 0..21                 %
    for p := 1 until 32 do begin
        integer carry, dPos, dMax;
        dPos  := 1;
        dMax  := powers( p - 1, 0 );
        carry := 0;
        % compute the power p and find the numbers                              %
        while dPos <= dMax do begin
            integer d;
            d     := carry + ( powers( p - 1, dPos ) * 6 );
            carry := d div 10;
            d     := d rem 10;
            store( p, dPos, d );
            dPos  := dPos + 1
        end while_dPos_le_dMax ;
        if   carry = 0
        then powers( p, 0 ) := dMax
        else begin
             % the power p has one more digit than the previous                 %
             powers( p, 0 ) := dPos;
             store( p, dPos, carry )
        end if_carry_eq_0__ ;
    end for_p ;
    % show the lowest powers that contain the numbers 0..21                     %
    for n := 0 until 21 do begin
        integer p;
        p := lowest( n );
        write( i_w := 2, s_w := 0, n, " in 6^", p, ": " );
        for d := powers( p, 0 ) step -1 until 1 do writeon( i_w := 1, s_w := 0, powers( p, d ) )
    end for_n
end.
