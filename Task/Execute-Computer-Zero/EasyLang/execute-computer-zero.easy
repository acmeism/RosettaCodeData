proc run name$ mem[] . .
   write name$ & ": "
   pc = 1
   len mem[] 32
   repeat
      ppc = mem[pc]
      op = ppc div 32
      addr = ppc mod 32 + 1
      pc += 1
      if op = 1
         acc = mem[addr]
      elif op = 2
         mem[addr] = acc
      elif op = 3
         acc = (acc + mem[addr]) mod 255
      elif op = 4
         acc = (acc - mem[addr]) mod 255
      elif op = 5
         if acc = 0
            pc = addr
         .
      elif op = 6
         pc = addr
      .
      until op = 7 or pc > 32
   .
   print acc
.
run "2+2" [ 35 100 224 2 2 ]
run "7*8" [ 44 106 76 43 141 75 168 192 44 224 8 7 0 1 ]
run "Fibonacci" [ 46 79 109 78 47 77 48 145 171 80 192 46 224 1 1 0 8 1 ]
run "List" [ 45 111 69 112 71 0 78 0 171 79 192 46 224 32 0 28 1 0 0 0 6 0 2 26 5 20 3 30 1 22 4 24 ]
run "Prisoner" [ 0 0 224 0 0 35 157 178 35 93 174 33 127 65 194 32 127 64 192 35 93 33 126 99 ]
