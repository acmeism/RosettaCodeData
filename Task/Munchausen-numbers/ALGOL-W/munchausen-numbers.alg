% Find Munchausen Numbers between 1 and 5000                                         %
% note that 6^6 is 46 656 so we only need to consider numbers consisting of 0 to 5   %
begin

    % table of nth Powers - note 0^0 is 0 for Munchausen numbers, not 1              %
    integer array nthPower( 0 :: 5 );
    integer d1, d2, d3, d4, d1Part, d2Part, d3Part;
    nthPower( 0 ) := 0;             nthPower( 1 ) := 1;
    nthPower( 2 ) := 2 * 2;         nthPower( 3 ) := 3 * 3 * 3;
    nthPower( 4 ) := 4 * 4 * 4 * 4; nthPower( 5 ) := 5 * 5 * 5 * 5 * 5;
    d1 := d2 := d3 := d1Part := d2Part := d3Part := 0;
    d4 := 1;
    while d1 < 6 do begin
        integer number, digitPowerSum;
        number        := d1Part + d2Part + d3Part + d4;
        digitPowerSum := nthPower( d1 )
                       + nthPower( d2 )
                       + nthPower( d3 )
                       + nthPower( d4 );
        if digitPowerSum = number then begin
            write( i_w := 1, number )
        end;
        d4 := d4 + 1;
        if d4 > 5 then begin
            d4     := 0;
            d3     := d3 + 1;
            d3Part := d3Part + 10;
            if d3 > 5 then begin
                d3     := 0;
                d3Part := 0;
                d2     := d2 + 1;
                d2Part := d2Part + 100;
                if d2 > 5 then begin
                    d2     := 0;
                    d2Part := 0;
                    d1     := d1 + 1;
                    d1Part := d1Part + 1000;
                end
            end
        end
    end

end.
