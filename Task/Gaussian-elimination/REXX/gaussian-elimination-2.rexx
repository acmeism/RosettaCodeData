/*REXX pgm solves Ax=b with Gaussian elimination &backwards substitution*/
parse arg iFID .;  if iFID==''  then iFID='GAUSS_E.DAT'

  do files=1  while lines(iFID)\==0;  #=0           /*read equation sets*/
  numeric digits 200                                /*reduces rounding. */
     do $=1  while lines(iFID)\==0                  /*process equation. */
     z=linein(iFID);  if z=''  then leave           /*Blank line? e─o─d.*/
     if $==1  then do;  say;  say center(' equations ',75,'▒');  say;  end
     say z                                          /*show an equation. */
     if left(space(z),1)=='*'  then iterate         /*ignore comments.  */
     #=#+1;  n=words(z)-1                           /*assign equation #s*/
       do e=1  for n; a.#.e=word(z,e); end  /*e*/   /*process the  A #s.*/
     b.#=word(z,n+1)                                /*   "     "   B  #.*/
     end   /*$*/
  if #==0  then iterate                             /*extra blank line? */
  call Gauss_elimination                            /*invoke Gauss elim.*/
  say;  say center('solution',75,'═');   say        /* [↓] show solution*/
  numeric digits 8;      pad=left('',30)            /*only show 8 digits*/
     do s=1  for n;  say pad 'x['s"] = "   left('', x.s>=0)   x.s/1;   end
  end   /*files*/

exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────GAUSS_ELIMINATION subroutine────────*/
Gauss_elimination:  do     j=1   for n;   jp=j+1
                      do   i=jp   to n;   _=a.j.j/a.i.j
                        do k=jp   to n;   a.i.k=a.j.k-_*a.i.k;  end  /*k*/
                      b.i=b.j-_*b.i
                      end   /*i*/
                    end     /*j*/
x.n=b.n/a.n.n
                do   j=n-1  to 1  by -1;  _=0
                  do i=j+1  to n; _=_+a.j.i*x.i; end  /*i*/
                x.j=(b.j-_)/a.j.j
                end   /*j*/              /* [↑]  backwards substitution.*/
return
