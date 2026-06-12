func isprim n .
   if n < 2 : return 0
   for i = 2 to sqrt n : if n mod i = 0 : return 0
   return 1
.
func$ find t$ .
   for c$ in strchars t$ : t[] &= strcode c$
   for a in t[] : for b in t[] : for c in t[]
      if isprim abs (a - b) = 1 and isprim abs (b - c) = 1 and isprim abs (a - c) = 1
         return strchar a & strchar b & strchar c
      .
   .
.
for t$ in [ "riOtjuoq" "wjtiOxtj" "akwercjoeiJ" "Weej" "Aek" "jjgja" ]
   r$ = find t$
   if r$ = "" : r$ = "Not found."
   print r$
.
