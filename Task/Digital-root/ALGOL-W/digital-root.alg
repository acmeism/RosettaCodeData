begin

    % calculates the digital root and persistence of an integer in base 10   %
    % in order to allow for numbers larger than 2^31, the number is passed   %
    % as the lower and upper digits e.g. 393900588225 can be processed by    %
    % specifying upper = 393900, lower = 58825                               %
    procedure findDigitalRoot( integer value  upper, lower
                             ; integer result digitalRoot, persistence
                             ) ;
    begin

        integer procedure sumDigits( integer value n ) ;
        begin
            integer digits, sum;

            digits := abs n;
            sum    := 0;

            while digits > 0
            do begin
                sum    := sum + ( digits rem 10 );
                digits := digits div 10
            end % while digits > 0 % ;

            % result: % sum
        end sumDigits;

        digitalRoot := sumDigits( upper ) + sumDigits( lower );
        persistence := 1;

        while digitalRoot > 9
        do begin
            persistence := persistence + 1;
            digitalRoot := sumDigits( digitalRoot );
        end % while digitalRoot > 9 % ;

    end findDigitalRoot ;

    % calculates and prints the digital root and persistence                 %
    procedure printDigitalRootAndPersistence( integer value upper, lower ) ;
    begin
        integer digitalRoot, persistence;
        findDigitalRoot( upper, lower, digitalRoot, persistence );
        write( s_w := 0  % set field saeparator width for this statement %
             , i_w := 8  % set integer field width for this statement    %
             , upper
             , ", "
             , lower
             , i_w := 2  % change integer field width %
             , ": digital root: "
             , digitalRoot
             , ", persistence: "
             , persistence
             )
    end printDigitalRootAndPersistence ;

    % test the digital root and persistence procedures %
    printDigitalRootAndPersistence(      0, 627615 );
    printDigitalRootAndPersistence(      0,  39390 );
    printDigitalRootAndPersistence(      0, 588225 );
    printDigitalRootAndPersistence( 393900, 588225 )

end.
