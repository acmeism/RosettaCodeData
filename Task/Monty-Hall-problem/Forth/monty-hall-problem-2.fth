0 value stay-wins
0 value switch-wins

: trial ( -- )
  3 choose 3 choose ( -- prize choice )
  = IF  1 +TO stay-wins exit  ENDIF
  1 +TO switch-wins ;

: trials ( n -- )
  CLEAR stay-wins
  CLEAR switch-wins
  dup 0 ?DO  trial  LOOP
  CR   stay-wins DEC. ." / " dup DEC. ." staying wins,"
  CR switch-wins DEC. ." / "     DEC. ." switching wins." ;
