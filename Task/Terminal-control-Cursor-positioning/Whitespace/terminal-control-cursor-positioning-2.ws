push "Hello"	;The characters are pushed onto the stack in reverse order
push "[6;3H"
push 27		;ESC

push 11		;Number of characters to print
call 0		;Calls print-string function
exit

0:
  dup jumpz 1	;Return if counter is zero
  exch prtc	;Swap counter with the next character and print it
  push 1 sub	;Subtract one from counter
  jump 0	;Loop back to print next character

1:
  pop ret	;Pop counter and return
