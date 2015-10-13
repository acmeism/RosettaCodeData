begin
    % calculates the shannon entropy of a string                          %
    % strings are fixed length in algol W and the length is part of the   %
    % type, so we declare the string parameter to be the longest possible %
    % string length (256 characters) and have a second parameter to       %
    % specify how much is actually used                                   %
    real procedure shannon_entropy ( string(256) value s
                                   ; integer     value stringLength
                                   );
    begin

        real    probability, entropy;

        % algol W assumes there are 256 possible characters %
        integer MAX_CHAR;
                MAX_CHAR := 256;

        % declarations must preceed statements, so we start a new         %
        % block here so we can use MAX_CHAR as an array bound             %
        begin

            % increment an integer variable                               %
            procedure incI ( integer value result a ) ; a := a + 1;

            integer array charCount( 1 :: MAX_CHAR );

            % count the occurances of each character in s                 %
            for charPos := 1 until MAX_CHAR do charCount( charPos ) := 0;
            for sPos := 0 until stringLength - 1 do incI( charCount( decode( s( sPos | 1 ) ) ) );

            % calculate the entropy, we use log base 10 and then convert  %
            % to log base 2 after calculating the sum                     %

            entropy := 0.0;
            for charPos := 1 until MAX_CHAR do
            begin
                if charCount( charPos ) not = 0
                then begin
                    % have a character that occurs in the string          %
                    probability := charCount( charPos ) / stringLength;
                    entropy     := entropy - ( probability * log( probability ) )
                end
            end charPos

        end;

        entropy / log( 2 )
    end shannon_entropy ;

    % test the shannon entropy routine                                    %
    r_format := "A"; r_w := 12; r_d := 6; % set output to fixed format    %
    write( shannon_entropy( "1223334444", 10 ) )

end.
