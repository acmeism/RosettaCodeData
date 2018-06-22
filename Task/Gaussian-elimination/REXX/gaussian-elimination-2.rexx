/*REXX program solves   Ax=b   with Gaussian elimination  and  backwards  substitution. */
parse arg iFID .                                 /*obtain optional argument from the CL.*/
numeric digits 1000                              /*heavy─duty decimal digits precision. */
if iFID=='' | iFID=="," then iFID= 'GAUSS_E.DAT' /*Not specified?  Then use the default.*/
     do rec=1    while lines(iFID) \== 0         /*read the              equation sets. */
     #=0                                         /*the number of equations  (so far).   */
         do $=1  while lines(iFID) \== 0         /*process the equation.                */
         z=linein(iFID);    if z=''  then leave  /*Is this a blank line?    end─of─data.*/
         if $==1  then do;  say;     say center(' equations ', 75, "▓");        say
                       end                       /* [↑]  if 1st equation, then show hdr.*/
         say z                                   /*display an equation to the terminal. */
         if left(space(z), 1)=='*'  then iterate /*Is this a comment?    Then ignore it.*/
         #=# + 1;      n=words(z) - 1            /*assign equation #; calculate # items.*/
           do e=1  for n;     a.#.e= word(z, e)
           end   /*e*/                           /* [↑]  process  A  numbers.           */
         b.#=word(z, n + 1)                      /* ◄───    "     B     "               */
         end     /*$*/
     if #\==0  then call Gauss_elim              /*Not zero?  Then display the results. */
     end         /*rec*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Gauss_elim:                   do     j=1  for n;   jp=j + 1
                                do   i=jp  to n;   _=a.j.j / a.i.j
                                  do k=jp  to n;   a.i.k=a.j.k   -   _ * a.i.k
                                  end   /*k*/
                                b.i=b.j   -   _ * b.i
                                end     /*i*/
                              end       /*j*/
            x.n=b.n / a.n.n
                              do   j=n-1  to 1  by -1;   _=0
                                do i=j+1  to n;    _=_   +   a.j.i * x.i
                                end     /*i*/
                              x.j=(b.j - _) / a.j.j
                              end       /*j*/    /* [↑]  uses backwards substitution.   */
            say
            numeric digits 8                     /*for the display,  only use 8 digits. */
            say center('solution', 75, "═"); say /*a title line for articulated output. */
                   do o=1  for n;   say right('x['o"] = ", 38)   left('', x.o>=0)    x.o/1
                   end   /*o*/
            return
