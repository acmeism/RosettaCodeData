       IDENTIFICATION DIVISION.
       PROGRAM-ID. ALMOST-PRIME.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 CONTROL-VARS.
          03 K              PIC 9.
          03 I              PIC 999.
          03 SEEN           PIC 99.
          03 N              PIC 999.
          03 P              PIC 99.
          03 P-SQUARED      PIC 9(4).
          03 F              PIC 99.
          03 N-DIV-P        PIC 999V999.
          03 FILLER         REDEFINES N-DIV-P.
             05 NEXT-N      PIC 999.
             05 FILLER      PIC 999.
                88 N-DIVS-P VALUE ZERO.

       01 OUT-VARS.
          03 K-LN           PIC X(70).
          03 K-LN-PTR       PIC 99.
          03 LN-HDR.
             05 FILLER      PIC X(4) VALUE "K = ".
             05 K-OUT       PIC 9.
             05 FILLER      PIC X VALUE ":".
          03 I-FMT.
             05 FILLER      PIC X VALUE SPACE.
             05 I-OUT       PIC ZZ9.

       PROCEDURE DIVISION.
       BEGIN.
           PERFORM K-ALMOST-PRIMES VARYING K FROM 1 BY 1
               UNTIL K IS GREATER THAN 5.
           STOP RUN.

       K-ALMOST-PRIMES.
           MOVE SPACES TO K-LN.
           MOVE 1 TO K-LN-PTR.
           MOVE ZERO TO SEEN.
           MOVE K TO K-OUT.
           STRING LN-HDR DELIMITED BY SIZE INTO K-LN
               WITH POINTER K-LN-PTR.
           PERFORM I-K-ALMOST-PRIME VARYING I FROM 2 BY 1
               UNTIL SEEN IS EQUAL TO 10.
           DISPLAY K-LN.

       I-K-ALMOST-PRIME.
           MOVE ZERO TO F, P-SQUARED.
           MOVE I TO N.
           PERFORM PRIME-FACTOR VARYING P FROM 2 BY 1
               UNTIL F IS NOT LESS THAN K
               OR P-SQUARED IS GREATER THAN N.
           IF N IS GREATER THAN 1, ADD 1 TO F.
           IF F IS EQUAL TO K,
               MOVE I TO I-OUT,
               ADD 1 TO SEEN,
               STRING I-FMT DELIMITED BY SIZE INTO K-LN
                   WITH POINTER K-LN-PTR.

       PRIME-FACTOR.
           MULTIPLY P BY P GIVING P-SQUARED.
           DIVIDE N BY P GIVING N-DIV-P.
           PERFORM DIVIDE-FACTOR UNTIL NOT N-DIVS-P.

       DIVIDE-FACTOR.
           MOVE NEXT-N TO N.
           ADD 1 TO F.
           DIVIDE N BY P GIVING N-DIV-P.
