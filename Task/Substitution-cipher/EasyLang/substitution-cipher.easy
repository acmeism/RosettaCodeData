alpha$ = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
key$ = "VsciBjedgrzyHalvXZKtUPumGfIwJxqOCFRApnDhQWobLkESYMTN"
#
proc subst in$ &out$ &a$ &b$ .
   out$ = ""
   for c$ in strchars in$
      p = strpos a$ c$
      if p > 0 : c$ = substr b$ p 1
      out$ &= c$
   .
.
func$ enc s$ .
   subst s$ r$ alpha$ key$
   return r$
.
func$ dec s$ .
   subst s$ r$ key$ alpha$
   return r$
.
c$ = enc "Hello world"
print c$
print dec c$
