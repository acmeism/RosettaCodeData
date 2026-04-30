global expr$ vars$[] vals[] stack[] .
#
func isop c$ .
   return if strpos "&|!^" c$ > 0
.
func$ isvar c$ .
   for i = 1 to len vars$[]
      if vars$[i] = c$ : return 1
   .
   return 0
.
func varval c$ .
   for i = 1 to len vars$[]
      if vars$[i] = c$ : return vals[i]
   .
   return 0
.
proc push v .
   stack[] &= v
.
func pop .
   v = stack[$]
   len stack[] (len stack[] - 1)
   return v
.
func evalexpr .
   len stack[] 0
   for i = 1 to len expr$
      c$ = substr expr$ i 1
      if c$ = "T"
         push 1
      elif c$ = "F"
         push 0
      elif isvar c$ = 1
         push varval c$
      elif isop c$ = 1
         a = pop
         if c$ = "!"
            push (1 - a)
         elif c$ = "&"
            b = pop
            push (a * b)
         elif c$ = "|"
            b = pop
            if a = 1 or b = 1 : push 1
            if not (a = 1 or b = 1) : push 0
         else
            # ^
            b = pop
            push ((a + b) mod 2)
         .
      else
         print "ERROR: syntax"
      .
   .
   if len stack[] <> 1
      print "ERROR: stack not single"
      return 0
   .
   return stack[1]
.
proc setvars pos .
   if pos > len vars$[]
      line$ = ""
      for i = 1 to len vars$[]
         line$ &= substr "FT" (vals[i] + 1) 1 & "  "
      .
      r = evalexpr
      line$ &= substr "FT" (r + 1) 1
      print line$
      return
   .
   vals[pos] = 0
   setvars pos + 1
   vals[pos] = 1
   setvars pos + 1
.
print "Enter postfix Boolean expressions."
print "Operators: & | ! ^"
print "Variables: single letters except T/F"
print "Empty line = exit"
repeat
   write "\nBoolean expression: "
   expr$ = input
   until expr$ = ""
   h$ = strjoin strtok expr$ " \t" ""
   expr$ = ""
   for c$ in strchars h$
      c = strcode c$
      if c >= 97 and c <= 122 : c$ = strchar (c - 32)
      expr$ &= c$
   .
   vars$[] = [ ]
   for i = 1 to len expr$
      c$ = substr expr$ i 1
      if isop c$ = 0
         if c$ <> "T" and c$ <> "F" and isvar c$ = 0
            vars$[] &= c$
         .
      .
   .
   if len vars$[] = 0
      print "No variables; quitting."
      break 1
   .
   len vals[] len vars$[]
   head$ = ""
   for i = 1 to len vars$[] : head$ &= vars$[i] & "  "
   head$ &= expr$
   print ""
   print head$
   for i = 1 to len head$ : write "="
   print ""
   setvars 1
.
print ""
#
input_data
A B ^
A B C ^ |
