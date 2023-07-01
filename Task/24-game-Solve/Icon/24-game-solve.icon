invocable all
link strings   # for csort, deletec, permutes

procedure main()
static eL
initial {
   eoP := []  # set-up expression and operator permutation patterns
   every ( e := !["a@b#c$d", "a@(b#c)$d", "a@b#(c$d)", "a@(b#c$d)", "a@(b#(c$d))"] ) &
         ( o := !(opers := "+-*/") || !opers || !opers ) do
      put( eoP, map(e,"@#$",o) )    # expr+oper perms

   eL := []   # all cases
   every ( e := !eoP ) & ( p := permutes("wxyz") ) do
      put(eL, map(e,"abcd",p))

   }

write("This will attempt to find solutions to 24 for sets of numbers by\n",
      "combining 4 single digits between 1 and 9 to make 24 using only + - * / and ( ).\n",
      "All operations have equal precedence and are evaluated left to right.\n",
      "Enter 'use n1 n2 n3 n4' or just hit enter (to use a random set),",
      "'first'/'all' shows the first or all solutions, 'quit' to end.\n\n")

repeat {
   e := trim(read()) | fail
   e ?  case tab(find(" ")|0) of {
      "q"|"quit" : break
      "u"|"use"  : e := tab(0)
      "f"|"first": first := 1 & next
      "a"|"all"  : first := &null & next
      ""         : e := " " ||(1+?8) || " " || (1+?8) ||" " || (1+?8) || " " || (1+?8)
      }

   writes("Attempting to solve 24 for",e)

   e := deletec(e,' \t') # no whitespace
   if e ? ( tab(many('123456789')), pos(5), pos(0) ) then
      write(":")
   else write(" - invalid, only the digits '1..9' are allowed.") & next

   eS := set()
   every ex := map(!eL,"wxyz",e) do {
      if member(eS,ex) then next # skip duplicates of final expression
      insert(eS,ex)
      if ex ? (ans := eval(E()), pos(0)) then # parse and evaluate
         if ans = 24 then {
            write("Success ",image(ex)," evaluates to 24.")
            if \first then break
            }
      }
   }
write("Quiting.")
end

procedure eval(X)    #: return the evaluated AST
   if type(X) == "list" then {
      x := eval(get(X))
      while o := get(X) do
         if y := get(X) then
            x := o( real(x), (o ~== "/" | fail, eval(y) ))
         else write("Malformed expression.") & fail
   }
   return \x | X
end

procedure E()    #: expression
   put(lex := [],T())
   while put(lex,tab(any('+-*/'))) do
      put(lex,T())
   suspend if *lex = 1 then lex[1] else lex     # strip useless []
end

procedure T()                   #: Term
   suspend 2(="(", E(), =")") | # parenthesized subexpression, or ...
       tab(any(&digits))        # just a value
end
