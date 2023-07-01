begin
    % decodes a roman numeral into an integer                                %
    % there must be at least one blank after the numeral                     %
    % This takes a lenient view on roman numbers so e.g. IIXX is 18 - see    %
    % the Discussion                                                         %
    integer procedure romanToDecimal ( string(32) value roman ) ;
    begin
        integer   decimal, rPos, currDigit, nextDigit, seqValue;
        string(1) rDigit;

        % the roman number is a sequence of sequences of roman digits        %
        % if the previous sequence is of higher value digits than the next,  %
        %    the higher value is added to the overall value                  %
        % if the previous seequence is of lower value, it is subtracted      %
        % e.g. MCMLXII                                                       %
        %      the sequences are M, C, M, X, II                              %
        %          M is added, C subtracted, M added, X added and II added   %

        % get the value of a sequence of roman digits                        %
        integer procedure getSequence ;
            if rDigit = " " then begin
                % end of the number                                          %
                0
                end
            else begin
                % have another sequence                                      %
                integer sValue;
                sValue := 0;
                while roman( rPos // 1 ) = rDigit do begin
                    sValue := sValue + currDigit;
                    rPos   := rPos + 1;
                end while_have_same_digit ;
                % remember the next digit                                    %
                rDigit     := roman( rPos // 1 );
                % result is the sequence value                               %
                sValue
             end getSequence ;

        % convert a roman digit into its decimal equivalent                  %
        % an invalid digit will terminate the program, " " is 0              %
        integer procedure getValue( string(1) value romanDigit ) ;
            if      romanDigit = "m" or romanDigit = "M" then 1000
            else if romanDigit = "d" or romanDigit = "D" then  500
            else if romanDigit = "c" or romanDigit = "C" then  100
            else if romanDigit = "l" or romanDigit = "L" then   50
            else if romanDigit = "x" or romanDigit = "X" then   10
            else if romanDigit = "v" or romanDigit = "V" then    5
            else if romanDigit = "i" or romanDigit = "I" then    1
            else if romanDigit = " "                     then    0
            else begin
                write( s_w := 0, "Invalid roman digit: """, romanDigit, """" );
                assert false;
                0
            end getValue ;

        % get the first sequence                                             %
        decimal   := 0;
        rPos      := 0;
        rDigit    := roman( rPos // 1 );
        currDigit := getValue( rDigit );
        seqValue  := getSequence;

        % handle the sequences                                               %
        while rDigit not = " " do begin
            % have another sequence                                          %
            nextDigit := getValue( rDigit );
            if currDigit < nextDigit
            then % prev digit is lower  % decimal := decimal - seqValue
            else % prev digit is higher % decimal := decimal + seqValue
            ;
            currDigit := nextDigit;
            seqValue  := getSequence;
        end while_have_a_roman_digit ;

        % add the final sequence                                             %
        decimal + seqValue
    end roman ;

    % test the romanToDecimal routine                                        %

    procedure testRoman ( string(32) value romanNumber ) ;
        write( i_w := 5, romanNumber, romanToDecimal( romanNumber ) );

    testRoman( "I"        );    testRoman( "II"       );
    testRoman( "III"      );    testRoman( "IV"       );
    testRoman( "V"        );    testRoman( "VI"       );
    testRoman( "VII"      );    testRoman( "VIII"     );
    testRoman( "IX"       );    testRoman( "IIXX"     );
    testRoman( "XIX"      );    testRoman( "XX"       );
    write( "..." );
    testRoman( "MCMXC"    );
    testRoman( "MMVIII"   );
    testRoman( "MDCLXVI"  );

end.
