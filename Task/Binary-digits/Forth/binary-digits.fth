\ Forth uses a system variable 'BASE' for number conversion

\ HEX is a standard word to change the value of base to 16
\ DECIMAL is a standard word to change the value of base to 10

\ we can easily compile a word into the system to set 'BASE' to 2

  : binary  2 base ! ; ok


\ interactive console test with conversion and binary masking example

hex 0FF binary . 11111111  ok
decimal 679 binary . 1010100111  ok
  ok
binary  11111111111  00000110000  and . 110000  ok

decimal ok
