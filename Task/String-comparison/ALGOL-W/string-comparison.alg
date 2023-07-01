begin
    string(10) a;
    string(12) b;

    a := "abc";
    b := "ABC";

    % when comparing strings, Algol W ignores trailing blanks                 %
    % so e.g. "a" = "a " is true                                              %

    % equality?                                                               %
    if a = b then write( "a = b" );
    % inequality?                                                             %
    if a not = b then write( "a not = b" );

    % lexically ordered before?                                               %
    if a < b then write( "a < b" );

    % lexically ordered after?                                                %
    if a > b then write( "a > b" );

    % Algol W string comparisons are case-sensitive. To perform case          %
    % insensitive comparisons, procedures would need to be written            %
    % e.g. as in the following block (assuming the character set is ASCII)    %
    begin

        % convert a character to upper-case                                   %
        integer procedure toupper( integer value c ) ;
            if c < decode( "a" ) or c > decode( "z" ) then c
            else ( c - decode( "a" ) ) + decode( "A" );

        % compare two strings, ignoring case                                  %
        % note that strings can be at most 256 characters long in Algol W     %
        integer procedure caselessComparison ( string(256) value a, b ) ;
            begin
                integer comparisonResult, pos;
                comparisonResult := pos := 0;
                while pos < 256 and comparisonResult = 0 do begin
                    comparisonResult := toupper( decode( a(pos//1) ) )
                                      - toupper( decode( b(pos//1) ) );
                    pos := pos + 1
                end;
                if      comparisonResult < 0 then -1
                else if comparisonResult > 0 then  1
                else                               0
            end caselessComparison ;

        % compare two strings for equality, ignoring case                     %
        logical procedure equalIgnoringCase ( string(256) value a, b ) ;
            ( caselessComparison( a, b ) = 0 );

        % similar procedures for inequality and lexical ording ...           %

        if equalIgnoringCase( a, b ) then write( "a = b (ignoring case)" )
    end caselessComparison ;

    % Algol W is strongly typed - strings cannot be compared to e.g. integers %
    % e.g. "if a = 23 then ..." would be a syntax error                       %

    % Algol W also has <= and >= comparison operators for testing for         %
    % "lexically before or equal" and "lexically after or equal"              %
    if a <= b then write( "a <= b" );
    if a >= b then write( "a >= b" );

    % there are no other forms of string comparison builtin to Algol W        %

end.
