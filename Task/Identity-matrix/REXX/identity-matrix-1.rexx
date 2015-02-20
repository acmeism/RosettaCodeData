/*REXX program  creates  and  displays  any sized  identity matrix.     */
          do k=3  to 6                 /* [↓]  build & display a matrix.*/
          call identity_matrix  k      /*build and display a kxk matrix.*/
          end   /*k*/                  /* [↑]  use general─purpose disp.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────IDENTITY_MATRIX subroutine──────────*/
identity_matrix:  procedure;  parse arg n;  $=

          do       r=1  for n          /*build identity matrix,  by row,*/
                do c=1  for n          /*               ···  and by col.*/
                $=$  (r==c)            /*append zero or one (if on diag)*/
                end   /*c*/
          end         /*r*/

call showMatrix  'identity matrix of size'  n,   $
return
/*──────────────────────────────────SHOWMATRIX subroutine───────────────*/
showMatrix: procedure; parse arg hdr,x;  #=words(x)  /*#:  # of elements*/
dp=0                                         /*DP:   dec fraction width.*/
w=0                                          /*W:    integer part width.*/
      do n=1  until n*n>=#;  _=word(x,n)     /*find matrix order (size).*/
      parse var _ y '.' f;   w=max(w, length(y));    dp=max(dp, length(f))
      end   /*n*/      /* [↑]  idiomatically find widths to align output*/
w=w+1
say;  say center(hdr, max(length(hdr)+6, (w+1)*#%n), '─');  say
#=0                                                       /*#: element #*/
          do       row=1  for n;      _=left('',n+w)      /*indentation.*/
                do col=1  for n;      #=#+1               /*bump element*/
                _=_  right(format(word(x, #), , dp)/1, w)
                end   /*col*/         /* [↑]  division by 1 normalizes #*/
          say _                       /*display one line of the matrix. */
          end         /*row*/
return
