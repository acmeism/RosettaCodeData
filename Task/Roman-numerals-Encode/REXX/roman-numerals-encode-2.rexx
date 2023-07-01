/*REXX program converts (Arabic) non─negative decimal integers (≥0) ───► Roman numerals.*/
numeric digits 10000                             /*decimal digs can be higher if wanted.*/
parse arg #                                      /*obtain optional integers from the CL.*/
@er= "argument isn't a non-negative integer: "   /*literal used when issuing error msg. */
if #=''  then                                    /*Nothing specified?  Then generate #s.*/
    do
                                                  do j= 0  by  11  to  111; #=# j;     end
    #=# 49;                                       do k=88  by 100  to 1200; #=# k;     end
    #=# 1000 2000 3000 4000 5000 6000;            do m=88  by 200  to 1200; #=# m;     end
    #=# 1304 1405 1506 1607 1708 1809 1910 2011;  do p= 4          to   50; #=# 10**p; end
    end                                          /*finished with generation of numbers. */

  do i=1  for words(#);         x=word(#, i)     /*convert each of the numbers───►Roman.*/
  if \datatype(x, 'W') | x<0  then say "***error***"  @er  x     /*¬ whole #?  negative?*/
  say  right(x, 55)     dec2rom(x)
  end   /*i*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
dec2rom: procedure;   parse arg n,#              /*obtain the number, assign # to a null*/
         n=space(translate(n/1, , ','),  0)      /*remove commas from normalized integer*/
         nulla= 'ZEPHIRUM NULLAE NULLA NIHIL'    /*Roman words for "nothing" or "none". */
         if n==0  then return word(nulla, 1)     /*return a Roman word for  "zero".     */
         maxnp=(length(n)-1)%3                   /*find max(+1) # of parenthesis to use.*/
         highPos=(maxnp+1)*3                     /*highest position of number.          */
         nn=reverse( right(n, highPos, 0) )      /*digits for Arabic──►Roman conversion.*/
                       do j=highPos  to 1  by -3
                       _=substr(nn, j,   1);  select     /*════════════════════hundreds.*/
                                              when _==9  then hx='CM'
                                              when _>=5  then hx='D'copies("C", _-5)
                                              when _==4  then hx='CD'
                                              otherwise       hx=   copies('C', _)
                                              end  /*select hundreds*/
                       _=substr(nn, j-1, 1);  select     /*════════════════════════tens.*/
                                              when _==9  then tx='XC'
                                              when _>=5  then tx='L'copies("X", _-5)
                                              when _==4  then tx='XL'
                                              otherwise       tx=   copies('X', _)
                                              end  /*select tens*/
                       _=substr(nn, j-2, 1);  select     /*═══════════════════════units.*/
                                              when _==9  then ux='IX'
                                              when _>=5  then ux='V'copies("I", _-5)
                                              when _==4  then ux='IV'
                                              otherwise       ux=   copies('I', _)
                                              end  /*select units*/
                       $=hx || tx || ux
                       if $\==''  then #=# || copies("(", (j-1)%3)$ ||copies(')', (j-1)%3)
                       end   /*j*/
         if pos('(I',#)\==0  then do i=1  for 4           /*special case: M,MM,MMM,MMMM.*/
                                  if i==4  then _ = '(IV)'
                                           else _ = '('copies("I", i)')'
                                  if pos(_, #)\==0  then #=changestr(_, #, copies('M', i))
                                  end   /*i*/
         return #
