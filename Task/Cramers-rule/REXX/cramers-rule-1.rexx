/* REXX Use Cramer's rule to compute solutions of given linear equations  */
Numeric Digits 20
names='w x y z'
M='  2  -1   5   1',
  '  3   2   2  -6',
  '  1   3   3  -1',
  '  5  -2  -3   3'
v=' -3',
  '-32',
  '-47',
  ' 49'
Call mk_mat(m)                      /* M -> a.i.j                    */
Do j=1 To dim                       /* Show the input                */
  ol=''
  Do i=1 To dim
    ol=ol format(a.i.j,6)
    End
  ol=ol format(word(v,j),6)
  Say ol
  End
Say copies('-',35)

d=det(m)                            /* denominator determinant       */

Do k=1 To dim                       /* construct nominator matrix    */
  Do j=1 To dim
    Do i=1 To dim
      If i=k Then
        b.i.j=word(v,j)
      Else
        b.i.j=a.i.j
      End
    End
  Call show_b
  d.k=det(mk_str())                 /* numerator determinant         */
  Say word(names,k) '=' d.k/d       /* compute value of variable k   */
  End
Exit

mk_mat: Procedure Expose a. dim     /* Turn list into matrix a.i.j */
  Parse Arg list
  dim=sqrt(words(list))
  k=0
  Do j=1 To dim
    Do i=1 To dim
      k=k+1
      a.i.j=word(list,k)
      End
    End
  Return

mk_str: Procedure Expose b. dim     /* Turn matrix b.i.j into list   */
  str=''
Do j=1 To dim
  Do i=1 To dim
    str=str b.i.j
    End
  End
Return str

show_b: Procedure Expose b. dim     /* show numerator matrix         */
  do j=1 To dim
    ol=''
    Do i=1 To dim
      ol=ol format(b.i.j,6)
      end
    Call dbg ol
    end
  Return

det: Procedure                      /* compute determinant           */
Parse Arg list
n=words(list)
call dbg 'det:' list
do dim=1 To 10
  If dim**2=n Then Leave
  End
call dbg 'dim='dim
If dim=2 Then Do
  det=word(list,1)*word(list,4)-word(list,2)*word(list,3)
  call dbg 'det=>'det
  Return det
  End
k=0
Do j=1 To dim
  Do i=1 To dim
    k=k+1
    a.i.j=word(list,k)
    End
  End
Do j=1 To dim
  ol=j
  Do i=1 To dim
    ol=ol format(a.i.j,6)
    End
  call dbg ol
  End
det=0
Do i=1 To dim
  ol=''
  Do j=2 To dim
    Do ii=1 To dim
      If ii<>i Then
        ol=ol a.ii.j
      End
    End
  call dbg 'i='i 'ol='ol
  If i//2 Then
    det=det+a.i.1*det(ol)
  Else
    det=det-a.i.1*det(ol)
  End
Call dbg 'det=>>>'det
Return det
sqrt: Procedure
/* REXX ***************************************************************
* EXEC to calculate the square root of a = 2 with high precision
**********************************************************************/
  Parse Arg x,prec
  If prec<9 Then prec=9
  prec1=2*prec
  eps=10**(-prec1)
  k = 1
  Numeric Digits 3
  r0= x
  r = 1
  Do i=1 By 1 Until r=r0 | (abs(r*r-x)<eps)
    r0 = r
    r  = (r + x/r) / 2
    k  = min(prec1,2*k)
    Numeric Digits (k + 5)
    End
  Numeric Digits prec
  r=r+0
  Return r


dbg: Return
