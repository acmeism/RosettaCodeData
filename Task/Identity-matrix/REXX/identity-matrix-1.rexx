/*REXX program  creates and displays any sized  identity matrix  (centered, with title).*/
           do k=3  to 6                          /* [↓]  build and display a sq. matrix.*/
           call ident_mat  k                     /*build & display a KxK square matrix. */
           end   /*k*/                           /* [↑]  use general─purpose display sub*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
ident_mat: procedure;  parse arg n; $=
              do    r=1  for n                   /*build identity matrix, by row and col*/
                 do c=1  for n;     $= $ (r==c)  /*append  zero  or  one  (if on diag). */
                 end   /*c*/
              end      /*r*/
           call showMat  'identity matrix of size'   n,   $
           return
/*──────────────────────────────────────────────────────────────────────────────────────*/
showMat: procedure; parse arg hdr,x;  #=words(x) /*#  is the number of matrix elements. */
         dp= 0                                   /*DP:  max width of decimal fractions. */
         w= 0                                    /*W:   max width of integer part.      */
                 do n=1  until n*n>=#;  _= word(x,n)      /*determine the matrix order. */
                 parse var _ y '.' f;   w= max(w, length(y));      dp= max(dp, length(f) )
                 end   /*n*/                     /* [↑]  idiomatically find the widths. */
         w= w +1
         say;  say center(hdr, max(length(hdr)+8, (w+1)*#%n), '─');  say
         #= 0                                                            /*#: element #.*/
                 do   row=1  for n;     _= left('', n+w)                 /*indentation. */
                   do col=1  for n;     #= # + 1                         /*bump element.*/
                   _=_ right(format(word(x, #), , dp)/1, w)
                   end   /*col*/                 /* [↑]  division by unity normalizes #.*/
                 say _                           /*display a single line of the matrix. */
                 end     /*row*/
         return
