func$ comdir path$[] .
   for i = 1 to len path$[1]
      c$ = substr path$[1] i 1
      for j = 2 to len path$[]
         if c$ <> substr path$[j] i 1
            break 2
         .
      .
      if c$ = "/"
         f = i - 1
      .
   .
   return substr path$[1] 1 f
.
a$[] &= "/home/user1/tmp/coverage/test"
a$[] &= "/home/user1/tmp/covert/operator"
a$[] &= "/home/user1/tmp/coven/members"
print comdir a$[]
