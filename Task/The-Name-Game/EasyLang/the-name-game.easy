proc toLowercase string$ . result$ .
   for i = 1 to len string$
      code = strcode substr string$ i 1
      if code >= 65 and code <= 90
         code += 32
      .
      result$ &= strchar code
   .
.
proc findInStrArray array$[] item$ . index .
   for i = 1 to len array$[]
      if array$[i] = item$
         index = i
         return
      .
   .
   index = 0
.
# This version actually handles consonant clusters
name$ = input
toLowercase name$ lowerName$
vowels$[] = [ "a" "e" "i" "o" "u" ]
for i = 1 to len lowerName$
   letter$ = substr lowerName$ i 1
   findInStrArray vowels$[] letter$ index
   if index <> 0
      truncName1$ = substr lowerName$ i len lowerName$
      break 1
   .
   truncName1$ = ""
.
firstLetter$ = substr lowerName$ 1 1
if firstLetter$ <> "b"
   b$ = "b"
.
if firstLetter$ <> "f"
   f$ = "f"
.
if firstLetter$ <> "m"
   m$ = "m"
.
if b$ = "" or f$ = "" or m$ = ""
   truncName2$ = substr lowerName$ 2 len lowerName$
.
# Determine the appropriate name for each line
if b$ = ""
   bName$ = truncName2$
else
   bName$ = truncName1$
.
if f$ = ""
   fName$ = truncName2$
else
   fName$ = truncName1$
.
if m$ = ""
   mName$ = truncName2$
else
   mName$ = truncName1$
.
# Print the song
print name$ & ", " & name$ & ", " & "bo-" & b$ & bName$
print "Banana-fana fo-" & f$ & fName$
print "Fee-fi-mo-" & m$ & mName$
print name$ & "!"
