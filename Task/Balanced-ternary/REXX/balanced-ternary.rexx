/*REXX program converts decimal  ?---?  balanced ternary;  it also performs arithmetic. */
  Numeric Digits 10000              /* be able to handle  gihugic  numbers              */
  ao='+-0++0+'
  abt=ao
  bo='-436'
  bbt=d2bt(bo)
  co='+-++-'
  cbt=co
  c1='balanced ternary ='           /* two literals used by subroutine                  */
  c2='(decimal)'
  Call btShow '[a]',abt
  Call btShow '[b]',bbt
  Call btShow '[c]',cbt
  Say
  btp=btmul(abt,btsub(bbt,cbt))     /* compute a*(b-c)                                  */
  Call btShow '[a*(b-c)]',btp
  Exit 0                            /* stick a fork in it,  we're all done              */
/*--------------------------------------------------------------------------------------*/
d2bt: Procedure
  Parse Arg x 1
  x=x/1
  p=0
  d.='-'
  d.1='+'
  d.0=0
  btn=''
  Do Until x==0
    _=(x//(3**(p+1)))%3**p
    If _==2 Then
      _=-1
    Else
      If _==-2 Then
        _=1
      x=x-_*(3**p)
    p=p+1
    btn=d._||btn
    End
  Return btn
/*--------------------------------------------------------------------------------------*/
bt2d: Procedure
  Parse Arg x
  r=reverse(x)
  d.=-1
  d.0=0
  btn=0
  _='+'
  d._=1
  Do j=1 For length(x)
    _=substr(r,j,1)
    btn=btn+d._*3**(j-1)
    End
  Return btn
/*--------------------------------------------------------------------------------------*/
btadd: Procedure
  Parse Arg x,y
  rx=reverse(x)
  ry=reverse(y)
  carry=0
  a.=0
  _='-'
  a._=-1
  _='+'
  a._=1
  d.='-'
  d.0=0
  d.1='+'
  btn=''
  Do j=1 For max(length(x),length(y))
    x_=substr(rx,j,1)
    xn=a.x_
    y_=substr(ry,j,1)
    yn=a.y_
    s=xn+yn+carry
    carry=0
    Select
      When s==2  Then Parse Value '-1  1' with s carry .
      When s==3  Then Parse Value ' 0  1' with s carry .
      When s==-2 Then Parse Value ' 1 -1' with s carry .
      When s==-3 Then Parse Value ' 0 -1' with s carry .
      Otherwise
        Nop
      End
    btn=d.s||btn
    End
  If carry\==0 Then
    btn=d.carry||btn
  Return btnorm(btn)
/*--------------------------------------------------------------------------------------*/
btmul: Procedure
  Parse Arg x 1 x1 2,y 1 y1 2
  If x==0|y==0 Then
    Return 0
  s=1
  p=0
  x=btnorm(x)
  y=btnorm(y)
  lx=length(x)
  ly=length(y)
  If x1=='-' Then Do
    x=btneg(x)
    s=-s
    End
  If y1=='-' Then Do
    y=btneg(y)
    s=-s
    End
  If ly>lx Then
    Parse Value x y With y x        /* optimize                                         */
  Do Until y==0                     /* keep adding 'til done                            */
    p=btadd(p,x)                    /* multiple the hard way                            */
    y=btsub(y,'+')                  /* subtract  1  from  Y.                            */
    End                             /* until                                            */
  If s==-1 Then
    p=btneg(p)
  Return p                          /* adjust the product's sign;  ret                  */
/*--------------------------------------------------------------------------------------*/
btneg:                              /* negate bal_ternary number                        */
  Return translate(arg(1),'-+','+-')
btnorm:                             /* normalize the number.                            */
  _=strip(arg(1),'L',0)
  If _=='' Then
    _=0
  Return _
btsub:                              /* subtract two BT args.                            */
  Return btadd(arg(1),btneg(arg(2)))
btshow:
  Say center(arg(1),9) right(arg(2),20) c1 right(bt2d(arg(2)),9) c2
  Return
