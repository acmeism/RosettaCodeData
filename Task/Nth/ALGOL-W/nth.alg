begin % suffix number with st, nd, rd or th as appropriate                   %

    string(2) procedure ordinalSuffix ( integer value number ) ;
    begin
        integer numberRem100;
        numberRem100 := number rem 100;
        if numberRem100 >= 10 and numberRem100 <= 20 then begin
            % numbers in the range 10 .. 20 always have "th"                 %
            "th"
            end
        else begin
            % not in the range 10 .. 20, suffix is st, nd, rd or th          %
            % depending on the final digit                                   %
            integer numberRem10;
            numberRem10 := number rem 10;
            if      numberRem10 = 1 then "st"
            else if numberRem10 = 2 then "nd"
            else if numberRem10 = 3 then "rd"
            else                         "th"
        end if_numberRem100_in_10_to_20__
    end ordinalSuffix ;

    % tests ordinalSuffix, displays the suffix for all numbers in from .. to %
    procedure testSuffix ( integer value from, to ) ;
    begin
        integer count;
        count := 0;
        for testValue := from until to do begin
            writeon( i_w := 4, s_w := 0, " ", testValue, ordinalSuffix( testValue ) );
            count := count + 1;
            if count rem 8 = 0 then write()
        end for_testValue ;
        if count rem 8 not = 0 then write();
        write()
    end testSuffix ;

    begin % task                                                             %
        testSuffix(    0,   25 );
        testSuffix(  250,  265 );
        testSuffix( 1000, 1025 )
    end
end.
