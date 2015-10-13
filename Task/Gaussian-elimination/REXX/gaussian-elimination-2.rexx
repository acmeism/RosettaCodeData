/*REXX program solves Ax=b with Gaussian elimination & backwards substitution.*/
parse arg iFID .;  if iFID==''  then iFID='GAUSS_E.DAT' /*¬given? Use default.*/
numeric digits 200                                      /*use hefty precision.*/
     do rec=1  while  lines(iFID)\==0                   /*read equation sets. */
     #=0
           do $=1  while lines(iFID)\==0                /*process the equation*/
           z=linein(iFID);  if z=''  then leave         /*Blank line? e─o─data*/
           if $==1  then do;  say;  say center(' equations ',75,'▒');  say;  end
           say z                                        /*show an equation.   */
           if left(space(z),1)=='*'  then iterate       /*ignore any comments.*/
           #=#+1;  n=words(z)-1                         /*assign equation #s. */
             do e=1  for n; a.#.e=word(z,e); end  /*e*/ /*process the  A  #s. */
           b.#=word(z,n+1)                              /*   "     "   B  #s. */
           end   /*$*/
     if #\==0  then call Gauss_elimination              /*compute,show results*/
     end   /*rec*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
Gauss_elimination:  do     j=1  for n;   jp=j+1
                      do   i=jp  to n;   _=a.j.j/a.i.j
                        do k=jp  to n;   a.i.k=a.j.k-_*a.i.k;   end  /*k*/
                      b.i=b.j-_*b.i
                      end   /*i*/
                    end     /*j*/
x.n=b.n/a.n.n
                    do   j=n-1  to 1  by -1;  _=0
                      do i=j+1  to n;    _=_+a.j.i*x.i;         end  /*i*/
                    x.j=(b.j-_)/a.j.j
                    end   /*j*/          /* [↑]  uses backwards substitution. */
numeric digits 8                         /*for the display, only use 8 digits.*/
say;  say center('solution',75,'═'); say /*a title line for articulated output*/
    do o=1  for n;  say right('x['o"] = ",38) left('',x.o>=0) x.o/1;  end  /*o*/
return
