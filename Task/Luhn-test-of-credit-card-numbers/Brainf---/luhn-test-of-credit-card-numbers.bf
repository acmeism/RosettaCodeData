>>>>>>>>>+>,----------[                        READ CHARACTERS UNTIL \N AND
  >++++++++[<----->-]<++>>>>>>+>,----------]   SUBTRACT ASCII 0 FROM EACH
<-<<<<<<<                                      GO TO LAST DIGIT
[                                              WHILE THERE ARE DIGITS
  >>>>>>>>[-<<<<<<<+>>>>>>>]<<<<<<<<             ADD RUNNING TOTAL TO ODD DGT
  <<<<<<<                                        GO TO EVEN DIGIT
  [                                              IF THERE IS ONE
    >[->++<]>[-<+>]                                MUL BY TWO
    >>>++++++++++<<<<[                             DIVMOD BY TEN
      >>>[-]+>-[<-<]<[<<]                            DECR DIVISOR
      >>[                                            IF ZERO
        >++++++++++>+<<-]<<<                           SET TO TEN; INCR QUOTIENT
    -]                                               DECR DIVIDEND UNTIL ZERO
    ++++++++++>>>>[-<<<<->>>>]                     CALCULATE REMAINDER
    >[-<<<<<+>>>>>]                                ADD QUOTIENT TO IT
    >>[-<<<<<<<+>>>>>>>]<<<<<<<<                   THEN ADD RUNNING TOTAL
    <<<<<                                          ZERO BEFORE NEXT ODD DIGIT
  ]<<                                            GO TO NEXT ODD DIGIT
]
>>>>>>>-[+>>-]>                                GO TO TOTAL
>>>>++++++++++<<<<[                            MODULO TEN
  >>>[-]+>-[<-<]<[<<]                            DECR DIVISOR
  >>[>++++++++++<-]                              IF ZERO SET BACK TO TEN
<<<-]                                            DECR DIVIDEND UNTIL ZERO
>>>++++++++++>[-<->]<                          REMAINDER: TEN MINUS DIVISOR
<<<<<<++++++++++[->                            VALUES FOR ASCII OUTPUT
  +++++++++++>                                   110
  ++++++++++>                                    100
  ++++++++>                                      80
  +++++++<<<<]                                   70
>>>>>+>                                        GO BACK TO REMAINDER
[<<.<<---.<-----.+++.<]                        IF NOT ZERO FAIL
<[<<.<---.<+++++..<]                           IF ZERO PASS
++++++++++.                                    NEWLINE
