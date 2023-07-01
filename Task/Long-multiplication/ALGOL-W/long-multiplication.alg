begin
    % long multiplication of large integers                                 %
    % large integers are represented by arrays of integers whose absolute   %
    % values are in 0 .. ELEMENT_MAX - 1                                    %
    % negative large integers should have negative values in all non-zero   %
    % elements                                                              %
    % the least significant digits of the large integer are in element 1    %
    integer ELEMENT_DIGITS; % number of digits in an element of a large     %
                            % integer                                       %
    integer ELEMENT_MAX;    % max absolute value of an element of a large   %
                            % integer - must be 10^( ELEMENT_DIGITS + 1 )   %
    integer ELEMENT_COUNT;  % number of elements in each large integer      %
    % implements long multiplication, c is set to a * b                     %
    %     c can be the same array as a or b                                 %
    %     n is the number of elements in the large integers a, b and c      %
    procedure longMultiply( integer array a, b, c ( * )
                          ; integer value n
                          ) ;
    begin
        % multiplies the large integer in b by the integer a, the result    %
        %     is added to c, starting from offset                           %
        %     overflow is ignored                                           %
        procedure multiplyElement( integer value a
                                 ; integer array b, c ( * )
                                 ; integer value offset, n
                                 ) ;
        begin
            integer carry, cPos;
            carry := 0;
            cPos  := offset;
            for bPos := 1 until highestNonZeroElementPosition( b, ( n + 1 ) - offset ) do begin
                integer cElement;
                cElement := c( cPos ) + ( a * b( bPos ) ) + carry;
                if abs cElement < ELEMENT_MAX then carry := 0
                else begin
                    % have digits to carry                                  %
                    carry    := cElement div ELEMENT_MAX;
                    cElement := ( abs cElement ) rem ELEMENT_MAX;
                    if carry < 0 then cElement := - cElement
                end if_no_carry_ ;
                c( cPos ) := cElement;
                cPos := cPos + 1
            end for_aPos ;
            if cPos <= n then c( cPos ) := carry
        end multiplyElement ;
        integer array mResult ( 1 :: n );
        % the result will be computed in mResult, allowing a or b to be c   %
        for rPos := 1 until n do mResult( rPos ) := 0;
        % multiply and add each element to the result                       %
        for aPos := 1 until highestNonZeroElementPosition( a, n ) do begin
            if a( aPos ) not = 0 then multiplyElement( a( aPos ), b, mResult, aPos, n )
        end for_aPos ;
        % return the result in c                                            %
        for rPos := 1 until n do c( rPos ) := mResult( rPos )
    end longMultiply ;
    % writes the decimal value of a large integer a with n elements         %
    procedure writeonLargeInteger( integer array a ( * )
                                 ; integer value n
                                 ) ;
    begin
        integer aMax;
        aMax := highestNonZeroElementPosition( a, n );
        if aMax < 1 then writeon( "0" )
        else begin
            % the large integer is non-zero                                 %
            writeon( i_w := 1, s_w := 0, a( aMax ) ); % highest element     %
            % handle the remaining elements - show leading zeros            %
            for aPos := aMax - 1 step -1 until 1 do begin
                integer v;
                integer array digits ( 1 :: ELEMENT_DIGITS );
                v := abs a( aPos );
                for dPos := ELEMENT_DIGITS step -1 until 1 do begin
                    digits( dPos ) := v rem 10;
                    v              := v div 10
                end for_dPos;
                for dPos := 1 until ELEMENT_DIGITS do writeon( i_w := 1, s_w := 0, digits( dPos ) )
            end for_aPos
        end if_aMax_lt_1_
    end writeonLargeInteger ;
    % returns the position of the highest non-zero element of the large     %
    %     integer a with n elements                                         %
    integer procedure highestNonZeroElementPosition( integer array a ( * )
                                                   ; integer value n
                                                   ) ;
    begin
        integer aMax;
        aMax := n;
        while aMax > 0 and a( aMax ) = 0 do aMax := aMax - 1;
        aMax
    end highestNonZeroElementPosition ;
    % allow each element to contain 4 decimal digits, so element by element %
    % multiplication won't overflow 32-bits                                 %
    ELEMENT_DIGITS :=     4;
    ELEMENT_MAX    := 10000;
    ELEMENT_COUNT  :=    12; % allows up to 48 digits - enough for the task %
    begin
        integer array twoTo64, twoTo128 ( 1 :: ELEMENT_COUNT );
        integer pwr;
        % construct 2^64 in twoTo64                                         %
        for tPos := 2 until ELEMENT_COUNT do twoTo64( tPos ) := 0;
        twoTo64( 1 ) := 2;
        pwr          := 1;
        while pwr < 64 do begin
            longMultiply( twoTo64, twoTo64, twoTo64, ELEMENT_COUNT );
            pwr := pwr * 2
        end while_pwr_lt_64 ;
        % construct 2^128                                                   %
        longMultiply( twoTo64, twoTo64, twoTo128, ELEMENT_COUNT );
        write( "2^128: " );
        writeonLargeInteger( twoTo128, ELEMENT_COUNT )
    end
end.
