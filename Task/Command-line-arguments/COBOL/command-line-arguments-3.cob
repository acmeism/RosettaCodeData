       *>Created By Zwiegnet 8/19/2004

        IDENTIFICATION DIVISION.
        PROGRAM-ID. arguments.

        ENVIRONMENT DIVISION.

        DATA DIVISION.


        WORKING-STORAGE SECTION.

        01 command1 PIC X(50).
        01 command2 PIC X(50).
        01 command3 PIC X(50).


        PROCEDURE DIVISION.

        PERFORM GET-ARGS.

        *> Display Usage for Failed Checks
        ARGUSAGE.
        display "Usage: <command1> <command2> <command3>"
        STOP RUN.

        *> Evaluate Arguments
        GET-ARGS.
        ACCEPT command1 FROM ARGUMENT-VALUE
        IF command1 = SPACE OR LOW-VALUES THEN
        PERFORM ARGUSAGE
        ELSE
        INSPECT command1 REPLACING ALL SPACES BY LOW-VALUES


        ACCEPT command2 from ARGUMENT-VALUE
        IF command2 = SPACE OR LOW-VALUES THEN
        PERFORM ARGUSAGE
        ELSE
        INSPECT command2 REPLACING ALL SPACES BY LOW-VALUES


        ACCEPT command3 from ARGUMENT-VALUE
        IF command3 = SPACE OR LOW-VALUES THEN
        PERFORM ARGUSAGE
        ELSE
                INSPECT command3 REPLACING ALL SPACES BY LOW-VALUES



        *> Display Final Output
        display command1 " " command2 " " command3


        STOP RUN.

.
