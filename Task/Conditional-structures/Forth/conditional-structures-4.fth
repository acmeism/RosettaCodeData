: test-case ( n -- )
   CASE
     0 OF ." Zero!" ENDOF
     1 OF ." One!"  ENDOF
     ." Some other number!"
   ENDCASE ;
