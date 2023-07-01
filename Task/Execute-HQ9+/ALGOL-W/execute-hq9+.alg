begin

    procedure writeBottles( integer value bottleCount ) ;
        begin
            write( bottleCount, " bottle" );
            if bottleCount not = 1 then writeon( "s " ) else writeon( " " );
        end writeBottles ;

    procedure hq9 ( string(32) value code   % code to execute %
                  ; integer    value length % length of code  %
                  ) ;
        for i := 0 until length - 1 do begin
            string(1) op;

            % the increment-only accumulator %
            integer   hq9accumulator;

            hq9accumulator := 0;
            op             := code(i//1);

            if op = "Q" or op = "q" then write( code )
            else if op = "H" OR op = "h" then write( "Hello, World!" )
            else if op = "9" then begin
                % 99 bottles of beer %
                i_w := 1; s_w := 0;
                for bottles := 99 step -1 until 1 do begin
                    writeBottles( bottles ); writeon( "of beer on the wall" );
                    writeBottles( bottles ); writeon( "of beer" );;
                    write( "Take one down, pass it around," );
                    if bottles > 1 then begin
                        writeBottles( bottles - 1 ); writeon( "of beer on the wall." )
                    end;
                    write()
                end;
                write( "No more bottles of beer on the wall." )
                end
            else if op = "+" then hq9accumulator := hq9accumulator + 1
            else write( """", op, """ not implemented" )
        end hq9 ;


    % test the interpreter %
    begin
        string(32) code;
        integer    codeLength;
        write( "HQ9+> " );
        read( code );
        codeLength := 31;
        while codeLength >= 0 and code(codeLength//1) = " " do codeLength := codeLength - 1;
        hq9( code, codeLength + 1 )
    end
end.
