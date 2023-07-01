/*REXX program calculates the Kronecker product of two matrices.      */
w=0                              /* W: max width of any matrix element*/
amat=2x2 1 2 3 4                 /* define A matrix size and elements */
bmat=2x2 0 5 6 7                 /* "      B    "     "   "     "     */
Call makeMat 'A',amat            /* construct A matrix from elements  */
Call makeMat 'B',bmat            /* "         B    "     "     "      */
Call KronMat 'Kronecker product' /* calculate the Kronecker  product  */
Call showMat what,arows*brows||'X'||arows*bcols
Say ''
Say copies('|',55)
Say ''
w=0                              /* W: max width of any matrix element*/
amat=3x3 0 1 0 1 1 1 0 1 0       /* define A matrix size and elements */
bmat=3x4 1 1 1 1 1 0 0 1 1 1 1 1 /* "      B    "     "   "     "     */
Call makeMat 'A',amat            /* construct A matrix from elements  */
Call makeMat 'B',bmat            /* "         B    "     "     "      */
Call KronMat 'Kronecker product' /* calculate the Kronecker  product  */
Call showMat what,arows*brows||'X'||arows*bcols
Exit                             /* stick a fork in it, we're all done*/
/*--------------------------------------------------------------------*/
makemat:
  Parse Arg what,size elements   /*elements: e.1.1 e.1.2 - e.rows cols*/
  Parse Var size rows 'X' cols
  x.what.shape=rows cols
  n=0
  Do r=1 To rows
    Do c=1 To cols
      n=n+1
      element=word(elements,n)
      w=max(w,length(element))
      x.what.r.c=element
      End
    End
  Call showMat what,size
  Return
/*--------------------------------------------------------------------*/
kronmat:                         /* compute the Kronecker Product     */
  Parse Arg what
  Parse Var x.a.shape arows acols
  Parse Var x.b.shape brows bcols
  rp=0                           /* row of product                    */
  Do ra=1 To arows
    Do rb=1 To brows
      rp=rp+1                    /* row of product                    */
      cp=0                       /* column of product                 */
      Do ca=1 To acols
        x=x.a.ra.ca
        Do cb=1 To bcols
          y=x.b.rb.cb
          cp=cp+1                /* column of product                 */
          xy=x*y
          x.what.rp.cp=xy        /* element of product                */
          w=max(w,length(xy))
          End /* cB */
        End /* cA */
      End /* rB */
    End /* rA */
  Return
/*--------------------------------------------------------------------*/
showmat:
  Parse Arg what,size .
  Parse Var size rows 'X' cols
  z='+'
  b6=left('',6)
  Say ''
  Say b6 copies('-',7) 'matrix' what copies('-',7)
  Say b6 b6 '+'copies('-',cols*(w+1)+1)'+'
  Do r=1 To rows
    line='|' right(x.what.r.1,w)    /* element of first column        */                       /* start with long vertical bar   */
    Do c=2 To cols                  /* loop for other columns         */
      line=line right(x.what.r.c,w) /* append the elements            */
      End /* c */
    Say b6 b6 line '|'              /* append a long vertical bar.    */
    End /* r */
  Say b6 b6 '+'copies('-',cols*(w+1)+1)'+'
  Return
