/*REXX program multiplies two matrices together,                      */
/* displays the matrices and the result.                              */
Signal On syntax
amat=2x2 1 2 3 4                 /* define A matrix size and elements */
bmat=2x2 0 5 6 7                 /* "      B    "     "   "     "     */
a=.matrix~new('A',2,2,1 2 3 4)         /* create matrix A             */
b=.matrix~new('B',2,2,0 5 6 7)         /* create matrix B             */
a~show
b~show
c=kronmat(a,b)
c~show
Say ''
Say copies('|',55)
Say ''
a=.matrix~new('A',3,3,0 1 0 1 1 1 0 1 0)         /* create matrix A   */
b=.matrix~new('B',3,4,1 1 1 1 1 0 0 1 1 1 1 1)   /* create matrix B   */
a~show
b~show
c=kronmat(a,b)
c~show
Exit

kronmat: Procedure               /* compute the Kronecker Product     */
  Use Arg a,b
  rp=0                           /* row of product                    */
  Do ra=1 To a~rows
    Do rb=1 To b~rows
      rp=rp+1                    /* row of product                    */
      cp=0                       /* column of product                 */
      Do ca=1 To a~cols
        x=a~element(ra,ca)
        Do cb=1 To b~cols
          y=b~element(rb,cb)
          cp=cp+1                /* column of product                 */
          xy=x*y
          c.rp.cp=xy             /* element of product                */
          End /* cb */
        End /* ca */
      End /* rb */
    End /* ra */
  mm=''
  Do i=1 To a~rows*b~rows
    Do j=1 To a~rows*b~cols
      mm=mm C.i.j
      End /*j*/
    End /*i*/
  c=.matrix~new('Kronecker product',a~rows*b~rows,a~rows*b~cols,mm)
  Return c
/*--------------------------------------------------------------------*/
Exit:
  Say arg(1)
  Exit
Syntax:
  Say 'Syntax raised in line' sigl
  Say sourceline(sigl)
  Say 'rc='rc '('errortext(rc)')'
  Say '***** There was a problem!'
  Exit

::class Matrix
/********************************************************************
* Matrix is implemented as an array of rows
* where each row is an arryay of elements.
********************************************************************/
::Attribute name
::Attribute rows
::Attribute cols

::Method init
  expose m name rows cols
  Use Arg name,rows,cols,elements
  If words(elements)<>(rows*cols) Then Do
    Say 'incorrect number of elements ('words(elements)')<>'||(rows*cols)
    m=.nil
    Return
    End
  m=.array~new
  Do r=1 To rows
    ro=.array~new
    Do c=1 To cols
      Parse Var elements e elements
      ro~append(e)
      End
    m~append(ro)
    End

::Method element   /* get an element's value */
  expose m
  Use Arg r,c
  ro=m[r]
  Return ro[c]

::Method set       /* set an element's value and return its previous */
  expose m
  Use Arg r,c,new
  ro=m[r]
  old=ro[c]
  ro[c]=new
  Return old

::Method show  public  /* display the matrix */
  expose m name rows cols
  z='+'
  b6=left('',6)
  Say ''
  Say b6 copies('-',7) 'matrix' name copies('-',7)
  w=0
  Do r=1 To rows
    ro=m[r]
    Do c=1 To cols
      x=ro[c]
      w=max(w,length(x))
      End
    End
  Say b6 b6 '+'copies('-',cols*(w+1)+1)'+' /* top border              */
  Do r=1 To rows
    ro=m[r]
    line='|' right(ro[1],w)         /* element of first colsumn       */                       /* start with long vertical bar   */
    Do c=2 To cols                  /* loop for other columns         */
      line=line right(ro[c],w)      /* append the elements            */
      End /* c */
    Say b6 b6 line '|'              /* append a long vertical bar.    */
    End /* r */
  Say b6 b6 '+'copies('-',cols*(w+1)+1)'+' /* bottom border           */
  Return
