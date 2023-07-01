% Subleq program interpreter                                                 %
begin

    % executes the program specified in scode, stops when the instruction    %
    % pointer becomes negative                                               %
    procedure runSubleq ( integer array scode( * )
                        ; integer value codeLength
                        ) ;
    begin
        integer maxMemory;
        maxMemory := 3 * 1024;
        begin
            integer array memory ( 0 :: maxMemory - 1 );
            integer       ip, a, b, c;
            for i := 0 until maxMemory - 1 do memory( i ) := 0;
            % load the program into memory                                   %
            for i := 0 until codeLength do memory( i ) := scode( i );

            % start at instruction 0                                         %
            ip := 0;
            % execute the instructions until ip is < 0                       %
            while ip >= 0 do begin
                % get three words at ip and advance ip past them             %
                a  := memory( ip     );
                b  := memory( ip + 1 );
                c  := memory( ip + 2 );
                ip := ip + 3;
                % execute according to a, b and c                            %
                if       a = -1 then begin
                    % input a character to b                                 %
                    string(1) input;
                    read( input );
                    memory( b ) := decode( input )
                    end
                else if b = -1 then begin
                    % output character from a                                %
                    writeon( code( memory( a ) ) )
                    end
                else begin
                    % subtract and branch if le 0                            %
                    memory( b ) := memory( b ) - memory( a );
                    if memory( b ) <= 0 then ip := c
                end
            end % while-do %
        end
    end % runSubleq % ;

    % test the interpreter with the hello-world program specified in the task %
    begin
        integer array code ( 0 :: 31 );
        integer       codePos;
        codePos := 0;
        for i :=  15,  17,  -1,  17,  -1,  -1
               ,  16,   1,  -1,  16,   3,  -1
               ,  15,  15,   0,   0,  -1,  72
               , 101, 108, 108, 111,  44,  32
               , 119, 111, 114, 108, 100,  33
               ,  10,   0
        do begin
            code( codePos ) := i;
            codePos := codePos + 1;
        end;
        runSubleq( code, 31 )
    end

end.
