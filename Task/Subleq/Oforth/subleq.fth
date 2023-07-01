: subleq(program)
| ip a b c newb |
   program asListBuffer ->program
   0 ->ip
   while( ip 0 >= ) [
      ip 1+ dup program at ->a 1+ dup program at ->b 1+ program at ->c
      ip 3 + ->ip
      a -1 = ifTrue: [ b System.In >> nip program put continue ]
      b -1 = ifTrue: [ System.Out a 1+ program at <<c drop continue ]
      b 1+ program at a 1+ program at - ->newb
      program put(b 1+, newb)
      newb 0 <= ifTrue: [ c ->ip ]
      ] ;

[15, 17, -1, 17, -1, -1, 16, 1, -1, 16, 3, -1, 15, 15, 0, 0, -1, 72, 101, 108, 108, 111, 44, 32, 119, 111, 114, 108, 100, 33, 10, 0 ]
subleq
