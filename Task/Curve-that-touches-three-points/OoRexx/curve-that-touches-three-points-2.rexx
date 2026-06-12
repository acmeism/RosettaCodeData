/* REXX ***************************************************************
* Compute the polynome satisfying  three given Points
**********************************************************************/
Numeric Digits 20
pl='(10,10) (100,200) (200,10)'
Do i=1 To 3
  Parse Var pl '(' x.i ',' y.i ')' pl
  s.i=x.i**2 x.i 1 y.i
  End
abc=lingl()
a=abc[1]
b=abc[2]
c=abc[3]
If a~numerator<>0 Then
  gl=a'*x**2'
Else
  gl=''
If b~numerator<>0 Then gl=gl'+'||b'*x'
If c~numerator<>0 Then gl=gl'+'||c
o='y='gl
o=replr(o,'-(','+(-')
o=replr(o,'=-(','=(-')
o=replr(o,'=','=+')
Say o
Say 'x / f(x) / y'
Do i=1 To 3
  Say x.i '/' fun(x.i) '/' y.i
  End
Exit

fun:
Parse Arg x
Return a*x**2+b*x+c

lingl: Procedure  Expose s.
/************************************************* Version: 25.11.1996 *
* Lösung eines linearen Gleichungssystems
* 22.11.1996 PA neu
***********************************************************************/
Numeric Digits 20
Do i=1 to 3
  l=s.i
  Do j=1 By 1 While l<>''
    Parse Var l a.1.i.j l
    fa.1.i.j=.fraction~new(a.1.i.j,1)
    End
  m=j-1
  End
n=i-1
Do i=1 To n
  s=''
  Do j=1 To m
    s=s format(a.1.i.j,20)
    End
  Call dbg s
  End
Do ie=1 To i-1
  u=ie
  v=ie+1
  Do kk=ie To n
    If a.u.kk.ie<>0 Then Leave
    End
  Select
    When kk=ie Then Nop
    When kk>n Then Call ex 'eine Katastrophe'
    Otherwise Do
      Do jj=1 To m
        temp=a.u.ie.jj
        a.u.ie.jj=a.u.kk.jj
        a.u.kk.jj=temp
        ftemp=fa.u.ie.jj
        fa.u.ie.jj=fa.u.kk.jj
        fa.u.kk.jj=ftemp
        End
      Do ip=1 To n
        s=''
        Do jp=1 To m
          s=s format(a.u.ip.jp,20)
          End
        Call dbg s
        End
      End
    End

  Do i=1 To n
    Do j=1 To m
      If i<=ie Then Do
        a.v.i.j=a.u.i.j
        fa.v.i.j=fa.u.i.j
        End
      Else Do
        a.v.i.j=a.u.i.j*a.u.ie.ie-a.u.i.ie*a.u.ie.j
        fa.v.i.j=fa.u.i.j*fa.u.ie.ie-fa.u.i.ie*fa.u.ie.j
        End
      End
    End

   Call dbg copies('-',70)
   Do i=1 To n
     Do j=1 To m
       If a.v.i.j<>0 Then Leave
       End
     Select
       When j=m Then Call ex 'Widersprü�chliches Gleichungssystem'
       When j>m Then Call ex 'Gleichungen sind linear abhängig'
       Otherwise Nop
       End
     End
   Do i=1 To n
     s=''
     Do j=1 To m
       s=s format(a.v.i.j,20)
       End
     Call dbg s
     End
   End
n1=n+1
Do i=n To 1 By -1
  x.i=a.v.i.n1/a.v.i.i
  fx.i=fa.v.i.n1/fa.v.i.i
  sub=0
  fsub=.fraction~new(0,1)
  Do j=i+1 To n
    sub=sub+a.v.i.j*x.j
    fsub=fsub+fa.v.i.j*fx.j
    End
  x.i=x.i-sub/a.v.i.i
  fx.i=fx.i-fsub/fa.v.i.i
  End

Return .array~of(fx.1,fx.2,fx.3)

ex:
  Say arg(1)
  Exit

dbg: Return
--REQUIRES fraction.cls

::class fraction public inherit stringlike orderable comparable

::method init                                 /* initialize a fraction          */
  expose numerator denominator                /* expose the state data          */
  Numeric Digits 20
  Use Strict Arg numerator = 0, denominator = 1 /* access the two numbers       */
  numerator += 0                              /* force rounding                 */
  denominator += 0

  anum=abs(numerator)
  aden=abs(denominator)
  x=gcd2(anum,aden)
  anum=anum/x
  aden=aden/x
  If sign(denominator)<>sign(numerator) Then
    numerator=-anum
  Else
    numerator=anum
  denominator=aden

::method '[]' class                           /* create a new fraction          */
  forward message("NEW")                      /* just a synonym for NEW         */

-- read-only attributes for numerator and denominator
::attribute numerator GET
::attribute denominator GET

::method '+'                                  /* addition method                */
  expose numerator denominator                /* access the state values        */
  Numeric Digits 20
  Use Strict Arg adder = .nil                 /* get the operand                */

  if arg(1,'o') Then                          /* prefix plus operation?         */
    Return self                               /* don't do anything with this    */

  if adder~isa(.string) Then                  /* if just a simple number,       */
    adder = self~class~new(adder)             /* convert to a fraction          */

  rnum=self~numerator*adder~denominator+,
       self~denominator*adder~numerator
  rdenom=self~denominator*adder~denominator

  Return self~class~new(rnum,rdenom)

::method '-'                                  /* subtraction method             */
  expose numerator denominator                /* access the state values        */
  Numeric Digits 20
  Use Strict Arg adder = .nil                 /* get the operand                */

  if arg(1,'o') Then do                       /* prefix minus operation?        */
    rdenom=self~denominator
    rnum=-self~numerator
    End
  Else Do
    if adder~isa(.string) Then                /* if just a simple number,       */
      adder = self~class~new(adder)           /* convert to a fraction          */

    rnum=self~numerator*adder~denominator-,
         self~denominator*adder~numerator
    rdenom=self~denominator*adder~denominator
    End

  Return self~class~new(rnum,rdenom)

::method '*'                                  /* multiplication method          */
  expose numerator denominator                /* access the state values        */
  Numeric Digits 20
  Use Strict Arg adder = .nil                 /* get the operand                */

  if adder~isa(.string) Then                  /* if just a simple number,       */
    adder = self~class~new(adder)             /* convert to a fraction          */

  rnum=self~numerator*adder~numerator
  rdenom=self~denominator*adder~denominator

  Return self~class~new(rnum,rdenom)

::method '/'                                  /* division method                */
  expose numerator denominator                /* access the state values        */
  Numeric Digits 20
  Use Strict Arg adder = .nil                 /* get the operand                */

  if adder~isa(.string) Then                  /* if just a simple number,       */
    adder = self~class~new(adder)             /* convert toa fraction           */

  rnum=self~numerator*adder~denominator
  rdenom=self~denominator*adder~numerator

  Return self~class~new(rnum,rdenom)

::method 'value'                              /* the fraction' numeric Value    */
  expose numerator denominator                /* access the state values        */
  Return numerator/denominator

::method string                               /* format as a string value       */
  If self~denominator=1 Then
    Return '('self~numerator')'
  Else
    Return '('self~numerator'/'self~denominator')' /* format as '(a,b)'         */

::class "Stringlike" PUBLIC MIXINCLASS object

-- This unknown method forwards all method invocations to the object's string value,
-- effectively adding all of the string methods to the class
::method unknown UNGUARDED                    /* create an unknown method       */
  Use Arg msgname, args                       /* get the message and arguments  */
                                              /* just forward to the string val.*/
  forward to(self~string) message(msgname) arguments(args)

::ROUTINE gcd2
/**********************************************************************
* Compute greatest common divider
**********************************************************************/
  Numeric Digits 20
  Parse Arg a,b
  if b = 0 Then Return abs(a)
  Return GCD2(b,a//b)
::ROUTINE replr
/* REXX ***************************************************************
* Replace,in s, occurrences of old by new and return the changed string
* ooRexx has the builtin function changestr
**********************************************************************/
  Parse Arg s,new,old
  Do i=1 To 2 Until p=0
    p=pos(old,s)
    If p>0 Then
      s=left(s,p-1)||new||substr(s,p+length(old))
    End
  Return s
