/*REXX program multiplies two matrices together,                      */
/* displays the matrices and the result.                              */
Signal On syntax
x.=0
a=.matrix~new('A',4,2,1 2 3 4 5 6 7 8) /* create matrix A             */
b=.matrix~new('B',2,3,1 2 3 4 5 6)     /* create matrix B             */
If a~cols<>b~rows Then
  Call exit 'Matrices are incompatible for matrix multiplication',
            'a~cols='a~cols'<>b~rows='||b~rows
-- say a~name'[2,2] changed from' a~set(2,2,4711) 'to 4711' ; Pull .
c=multMat(a,b)                   /* multiply A x B                    */
a~show
b~show
c~show
Exit

multMat: Procedure
  Use Arg a,b
  c.=0
  Do i=1 To a~rows
    Do j=1 To b~cols
      Do k=1 To a~cols
        c.i.j=c.i.j+a~element(i,k)*b~element(k,j)
        End /*k*/
      End /*j*/
    End /*i*/
  mm=''
  Do i=1 To a~rows
    Do j=1 To b~cols
      mm=mm C.i.j
      End /*j*/
    End /*i*/
  c=.matrix~new('C',a~rows,b~cols,mm)
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

::Method show      /* display the matrix */
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
