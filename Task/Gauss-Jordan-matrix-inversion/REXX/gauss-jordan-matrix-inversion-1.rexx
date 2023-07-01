/* REXX */
Parse Arg seed nn
If seed='' Then
  seed=23345
If nn='' Then nn=5
If seed='?' Then Do
  Say 'rexx gjmi seed n computes a random matrix with n rows and columns'
  Say 'Default is 23345 5'
  Exit
  End
Numeric Digits 50
Call random 1,2,seed
a=''
Do i=1 To nn**2
  a=a random(9)+1
  End
n2=words(a)
Do n=2 To n2/2
  If n**2=n2 Then
    Leave
  End
If n>n2/2 Then
  Call exit 'Not a square matrix:' a '('n2 'elements).'
det=determinante(a,n)
If det=0 Then
  Call exit 'Determinant is 0'
Do j=1 To n
  Do i=1 To n
    Parse Var A a.i.j a
    aa.i.j=a.i.j
    End
  Do ii=1 To n
    z=(ii=j)
    iii=ii+n
    a.iii.j=z
    End
  End
Call show 1,'The given matrix'
Do m=1 To n-1
  If a.m.m=0 Then Do
    Do j=m+1 To n
      If a.m.j<>0 Then Leave
      End
    If j>n Then Do
      Say 'No pivot>0 found in column' m
      Exit
      End
    Do i=1 To n*2
      temp=a.i.m
      a.i.m=a.i.j
      a.i.j=temp
      End
    End
  Do j=m+1 To n
    If a.m.j<>0 Then Do
      jj=m
      fact=divide(a.m.m,a.m.j)
      Do i=1 To n*2
        a.i.j=subtract(multiply(a.i.j,fact),a.i.jj)
        End
      End
    End
  Call show 2 m
  End
Say 'Lower part has all zeros'
Say ''

Do j=1 To n
  If denom(a.j.j)<0 Then Do
    Do i=1 To 2*n
      a.i.j=subtract(0,a.i.j)
      End
    End
  End
Call show 3

Do m=n To 2 By -1
  Do j=1 To m-1
    jj=m
    fact=divide(a.m.j,a.m.jj)
    Do i=1 To n*2
      a.i.j=subtract(a.i.j,multiply(a.i.jj,fact))
      End
    End
  Call show 4 m
  End
Say 'Upper half has all zeros'
Say ''
Do j=1 To n
  If decimal(a.j.j)<>1 Then Do
    z=a.j.j
    Do i=1 To 2*n
      a.i.j=divide(a.i.j,z)
      End
    End
  End
Call show 5
Say 'Main diagonal has all ones'
Say ''

Do j=1 To n
  Do i=1 To n
    z=i+n
    a.i.j=a.z.j
    End
  End
Call show 6,'The inverse matrix'

do i = 1 to n
  do j = 1 to n
    sum=0
    Do k=1 To n
      sum=add(sum,multiply(aa.i.k,a.k.j))
      End
    c.i.j = sum
    end
  End
Call showc 7,'The product of input and inverse matrix'
Exit

show:
  Parse Arg num,text
  Say 'show' arg(1) text
  If arg(1)<>6 Then rows=n*2
               Else rows=n
  len=0
  Do j=1 To n
    Do i=1 To rows
      len=max(len,length(a.i.j))
      End
    End
  Do j=1 To n
    ol=''
    Do i=1 To rows
      ol=ol||right(a.i.j,len+1)
      End
    Say ol
    End
  Say ''
  Return

showc:
  Parse Arg num,text
  Say text
  clen=0
  Do j=1 To n
    Do i=1 To n
      clen=max(clen,length(c.i.j))
      End
    End
  Do j=1 To n
    ol=''
    Do i=1 To n
      ol=ol||right(c.i.j,clen+1)
      End
    Say ol
    End
  Say ''
  Return

denom: Procedure
  /* Return the denominator */
  Parse Arg d '/' n
  Return d

decimal: Procedure
  /* compute the fraction's value */
  Parse Arg a
  If pos('/',a)=0 Then a=a'/1'; Parse Var a ad '/' an
  Return ad/an

gcd: procedure
/**********************************************************************
* Greatest commn divisor
**********************************************************************/
  Parse Arg a,b
  If b = 0 Then Return abs(a)
  Return gcd(b,a//b)

add: Procedure
  Parse Arg a,b
  If pos('/',a)=0 Then a=a'/1'; Parse Var a ad '/' an
  If pos('/',b)=0 Then b=b'/1'; Parse Var b bd '/' bn
  sum=divide(ad*bn+bd*an,an*bn)
  Return sum

multiply: Procedure
  Parse Arg a,b
  If pos('/',a)=0 Then a=a'/1'; Parse Var a ad '/' an
  If pos('/',b)=0 Then b=b'/1'; Parse Var b bd '/' bn
  prd=divide(ad*bd,an*bn)
  Return prd

subtract: Procedure
  Parse Arg a,b
  If pos('/',a)=0 Then a=a'/1'; Parse Var a ad '/' an
  If pos('/',b)=0 Then b=b'/1'; Parse Var b bd '/' bn
  div=divide(ad*bn-bd*an,an*bn)
  Return div

divide: Procedure
  Parse Arg a,b
  If pos('/',a)=0 Then a=a'/1'; Parse Var a ad '/' an
  If pos('/',b)=0 Then b=b'/1'; Parse Var b bd '/' bn
  sd=ad*bn
  sn=an*bd
  g=gcd(sd,sn)
  Select
    When sd=0 Then res='0'
    When abs(sn/g)=1 Then res=(sd/g)*sign(sn/g)
    Otherwise Do
      den=sd/g
      nom=sn/g
      If nom<0 Then Do
        If den<0 Then den=abs(den)
        Else den=-den
        nom=abs(nom)
        End
      res=den'/'nom
      End
    End
  Return res

determinante: Procedure
/* REXX ***************************************************************
* determinant.rex
* compute the determinant of the given square matrix
* Input: as: the representation of the matrix as vector (n**2 elements)
* 21.05.2013 Walter Pachl
**********************************************************************/
  Parse Arg as,n
  Do i=1 To n
    Do j=1 To n
      Parse Var as a.i.j as
      End
    End
  Select
    When n=2 Then det=subtract(multiply(a.1.1,a.2.2),multiply(a.1.2,a.2.1))
    When n=3 Then Do
      det=multiply(multiply(a.1.1,a.2.2),a.3.3)
      det=add(det,multiply(multiply(a.1.2,a.2.3),a.3.1))
      det=add(det,multiply(multiply(a.1.3,a.2.1),a.3.2))
      det=subtract(det,multiply(multiply(a.1.3,a.2.2),a.3.1))
      det=subtract(det,multiply(multiply(a.1.2,a.2.1),a.3.3))
      det=subtract(det,multiply(multiply(a.1.1,a.2.3),a.3.2))
      End
    Otherwise Do
      det=0
      Do k=1 To n
        sign=((-1)**(k+1))
        If sign=1 Then
          det=add(det,multiply(a.1.k,determinante(subm(k),n-1)))
        Else
          det=subtract(det,multiply(a.1.k,determinante(subm(k),n-1)))
        End
      End
    End
  Return det

subm: Procedure Expose a. n
/**********************************************************************
* compute the submatrix resulting when row 1 and column k are removed
* Input: a.*.*, k
* Output: bs the representation of the submatrix as vector
**********************************************************************/
  Parse Arg k
  bs=''
  do i=2 To n
    Do j=1 To n
      If j=k Then Iterate
      bs=bs a.i.j
      End
    End
  Return bs

Exit: Say arg(1)
