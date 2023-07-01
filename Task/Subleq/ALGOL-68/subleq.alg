# Subleq program interpreter                                                 #
# executes the program specified in code, stops when the instruction pointer #
# becomes negative                                                           #
PROC run subleq = ( []INT code )VOID:
     BEGIN
        INT   max memory = 3 * 1024;
        [ 0 : max memory - 1 ]INT memory;
        # load the program into memory                                       #
        # a slice yields a row with LWB 1...                                 #
        memory[ 0 : UPB code - LWB code ] := code[ AT 1 ];
        # start at instruction 0                                             #
        INT   ip := 0;
        # execute the instructions until ip is < 0                           #
        WHILE ip >= 0 DO
            # get three words at ip and advance ip past them                 #
            INT a := memory[ ip     ];
            INT b := memory[ ip + 1 ];
            INT c := memory[ ip + 2 ];
            ip +:= 3;
            # execute according to a, b and c                                #
            IF   a = -1 THEN
                # input a character to b                                     #
                CHAR input;
                get( stand in, ( input ) );
                memory[ b ] := ABS input
            ELIF b = -1 THEN
                # output character from a                                    #
                print( ( REPR memory[ a ] ) )
            ELSE
                # subtract and branch if le 0                                #
                memory[ b ] -:= memory[ a ];
                IF memory[ b ] <= 0 THEN
                    ip := c
                FI
            FI
        OD
     END # run subleq # ;

# test the interpreter with the hello-world program specified in the task    #
run subleq( (  15,  17,  -1,  17,  -1,  -1
            ,  16,   1,  -1,  16,   3,  -1
            ,  15,  15,   0,   0,  -1,  72
            , 101, 108, 108, 111,  44,  32
            , 119, 111, 114, 108, 100,  33
            ,  10,   0
            )
          )
