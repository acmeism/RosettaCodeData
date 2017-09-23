/********************************************************************
* Package rxm
* implements the functions available in RxMath with high precision
* by computing the values with significantly increased precision
* and rounding the result to the specified precision.
* This started 10 years ago when Vladimir Zabrodsky published his
* Album of Algorithms http://dhost.info/zabrodskyvlada/aat/
* Gerard Schildberger suggests on rosettacode.org to use +10 digits
* Rony Flatscher suggested and helped to turn this into an ooRexx class
* Rick McGuire advised on using Use STRICT Arg for argument checking
* Alexander Seik creates this documentation
* Horst Wegscheider helped with reviewing and some improvements
* 12.04.2014 Walter Pachl
*            Documentation: see rxmath.pdf in the ooRexx distribution
*                           and rxm.doc (here)
* 13.04.2014 WP arcsin and arctan commentary corrected (courtesy Horst)
* 13.04.2014 WP improve arctan performance
* 20.04.2014 WP towards completion
* 24.04.2014 WP arcsin verbessert. courtesy Horst Wegscheider
* 28.04.2014 WP run ooRexxDoc
* 11.08.2014 WP replace log algorithm with Vladimir Zabrodsky's code
**********************************************************************/
.local~my.rxm=.rxm~new(16,"D")

::Class rxm Public

::Method init
  Expose precision type
  Use Arg  precision=(digits()),type='D'

::attribute precision set
  Expose precision
  Use Strict Arg  precision=(digits())

::attribute precision get

::attribute type set
  Expose type
  Use Strict Arg type='R'

::attribute type get

::Method arccos
/***********************************************************************
* Return arccos(x,precision,type) -- with specified precision
* arccos(x) = pi/2 - arcsin(x)
***********************************************************************/
  Expose precision type
  Use Strict Arg x,xprec=(precision),xtype=(type)
  iprec=xprec+10
  Numeric Digits iprec
  If x=1 Then
    r=0
  Else Do
    r=self~arcsin(x,iprec,'R')
    If r='nan' Then
      Return r
    r=self~pi(iprec)/2 - r
    End
  Select
    When xtype='D' Then
      r=r*180/self~pi(iprec)
    When xtype='G' Then
      r=r*200/self~pi(iprec)
    Otherwise
      Nop
    End
  Numeric Digits xprec
  Return (r+0)

::Method arcsin
/***********************************************************************
* Return arcsin(x,precision,type) -- with specified precision
* arcsin(x) = x+(x**3)*1/2*3+(x**5)*1*3/2*4*5+(x**7)*1*3*5/2*4*6*7+...
***********************************************************************/
  Expose precision type
  Use Strict Arg x,xprec=(precision),xtype=(type)
  iprec=xprec+10
  Numeric Digits iprec
  sign=sign(x)
  If x<0 Then
    x=abs(x)
  Select
    When abs(x)>1 Then
      Return 'nan'
    When x=0 Then
      r=0
    When x=1 Then
      r=rxmpi(iprec)/2
    When x<0.8 Then Do
      o=x
      u=1
      r=x
      Do i=3 By 2 Until ra=r
        ra=r
        o=o*x*x*(i-2)
        u=u*(i-1)*i/(i-2)
        r=r+(o/u)
        If r=ra Then
          r=r+(o/u)/2 /* final touch */
        End
      End
    Otherwise Do
      z=x
      r=x
      o=x
      s=x*x
      do j=2 by 2;
        o=o*s*(j-1)/j;
        z=z+o/(j+1);
        if z=r then
          leave
        r=z;
        end
      /***********************
      y=(1-x*x)/4
      n=0.5-self~sqrt(y,iprec)
      z=self~sqrt(n,iprec)
      r=2*self~arcsin(z,xprec)
      ***********************/
      End
    End
  Select
    When xtype='D' Then
      r=r*180/self~pi(iprec)
    When xtype='G' Then
      r=r*200/self~pi(iprec)
    Otherwise
      Nop
    End
  Numeric Digits xprec
  Return sign*(r+0)

::Method arctan
/***********************************************************************
* Return arctan(x,precision,type) -- with specified precision
* x=0 -> arctan(x) = 0
* If x>0 Then
*   x<1 -> arctan(x) = arcsin(x/sqrt(x**2+1))
*   x=1 -> arctan(x) = pi/4
*   x>1 -> arctan(x) = pi/2-arcsin((1/x)/sqrt((1/x)**2+1))
* Else
*   adjust as necessary
***********************************************************************/
  Expose precision type
  Use Strict Arg x,xprec=(precision),xtype=(type)
  iprec=xprec+10
  Numeric Digits iprec
  Select
    When abs(x)<1 Then
      r=self~arcsin(x/self~sqrt(1+x**2,iprec),iprec,'R')
    When abs(x)=1 Then
      r=self~pi(iprec)/4*sign(x)
    Otherwise Do
      xr=1/abs(x)
      r=self~arcsin(xr/self~sqrt(1+xr**2,iprec),iprec,'R')
      If x>0 Then
        r=self~pi(iprec)/2-r
      Else
        r=-self~pi(iprec)/2+r
      End
    End
  Select
    When xtype='D' Then
      r=r*180/self~pi(iprec)
    When xtype='G' Then
      r=r*200/self~pi(iprec)
    Otherwise
      Nop
    End
  Numeric Digits xprec
  Return (r+0)

::Method arsinh
/***********************************************************************
* Return arsinh(x,precision,type) -- with specified precision
* arsinh(x) = ln(x+sqrt(x**2+1))
***********************************************************************/
  Expose precision
  Use Strict Arg x,xprec=(precision)
  iprec=xprec+10
  Numeric Digits iprec
  x2p1=x**2+1
  r=self~log(x+self~sqrt(x2p1,iprec),iprec)
  Numeric Digits xprec
  Return (r+0)

::Method cos
/* REXX *************************************************************
* Return cos(x,precision,type) -- with the specified precision
* cos(x)=sin(x+pi/2)
********************************************************************/
  Expose precision type
  Use Strict Arg x,xprec=(precision),xtype=(type)
  iprec=xprec+10
  Numeric Digits iprec
  Select
    When xtype='R' Then xa=x+self~pi(iprec)/2
    When xtype='D' Then xa=x+90
    When xtype='G' Then xa=x+100
    End
  r=self~sin(xa,iprec,xtype)
  Numeric Digits xprec
  Return (r+0)

::Method cosh
/* REXX ****************************************************************
* Return cosh(x,precision,type) -- with specified precision
* cosh(x) = 1+(x**2/2!)+(x**4/4!)+(x**6/6!)+-...
***********************************************************************/
  Expose precision
  Use Strict Arg x,xprec=(precision)
  iprec=xprec+10
  Numeric Digits iprec
  o=1
  u=1
  r=1
  Do i=2 By 2 Until ra=r
    ra=r
    o=o*x*x
    u=u*i*(i-1)
    r=r+(o/u)
    End
  Numeric Digits xprec
  Return (r+0)

::Method cotan
/* REXX *************************************************************
* Return cotan(x,precision,type) -- with the specified precision
* cot(x)=cos(x)/sin(x)
********************************************************************/
  Expose precision type
  Use Strict Arg x,xprec=(precision),xtype=(type)
  iprec=xprec+10
  Numeric Digits iprec
  s=self~sin(x,iprec,xtype)
  c=self~cos(x,iprec,xtype)
  If s=0 Then
    Return '+infinity'
  r=c/s
  Numeric Digits xprec
  Return (r+0)

::Method exp
/***********************************************************************
* exp(x,precision) returns e**x -- with specified precision
* exp(x,precision,base) returns base**x -- with specified precision
***********************************************************************/
  Expose precision
  Use Strict Arg x,xprec=(precision),xbase=''
  iprec=xprec+10
  Numeric Digits iprec
  Numeric Fuzz   3
  If xbase<>'' Then Do
    Select
      When xbase=0 Then Do
        Select
          When x<0 Then Return '+infinity'
          When x=0 Then Return 'nan'
          Otherwise Return 0
          End
        End
      When xbase=1 Then Return 1
      When xbase<0 Then Do
        Select
          When x=0 Then Return 1
          When datatype(x,'W')=0 Then Return 'nan'
          Otherwise Do
            r=xbase**x
            Numeric Digits xprec
            Return r+0
            End
          End
        End
      Otherwise
        x=x*self~log(xbase,iprec)
      End
    End
  o=1
  u=1
  r=1
  Do i=1 By 1 Until ra=r
    ra=r
    o=o*x
    u=u*i
    r=r+(o/u)
    End
  Numeric Digits xprec
  Return (r+0)

::Method log
/***********************************************************************
* log(x,precision) -- returns ln(x) with specified precision
* log(x,precision,base) -- returns blog(x) with specified precision
* Three different series are used for ln(x): x in range  0 to 0.5
*                                                      0.5 to 1.5
*                                                      1.5 to infinity
***********************************************************************/
  Expose precision
  Use Strict Arg x,xprec=(precision),xbase=''
  iprec=xprec+100
  Numeric Digits iprec
  Select
    When x=0 Then Return '-infinity'
    When x<0 Then Return 'nan'
    When x<1 Then  r= -self~Log(1/X,xprec)
    Otherwise Do
      do M = 0 until (2 ** M) > X; end
      M = M - 1
      Z = X / (2 ** M)
      Zeta = (1 - Z) / (1 + Z)
      N = Zeta; Ln = Zeta; Zetasup2 = Zeta * Zeta
      do J = 1
        N = N * Zetasup2; NewLn = Ln + N / (2 * J + 1)
        if NewLn = Ln then Do
          r= M * self~LN2P(xprec) - 2 * Ln
          Leave
          End
        Ln = NewLn
        end
      End
    End
  If x>0 Then Do
    If xbase>'' Then
      r=r/self~log(xbase,iprec)
  Numeric Digits xprec
    r=r+0
    End
  Return r

::Method ln2p
  Parse Arg p
  Numeric Digits p+10
  If p<=1000 Then
    Return self~ln2()
  n=1/3
  ln=n
  zetasup2=1/9
  Do j=1
    n=n*zetasup2
    newln=ln+n/(2*j+1)
    If newln=ln Then
      Return 2*ln
    ln=newln
    End

::Method LN2
    V = ''
    V = V || 0.69314718055994530941723212145817656807
    V = V || 5500134360255254120680009493393621969694
    V = V || 7156058633269964186875420014810205706857
    V = V || 3368552023575813055703267075163507596193
    V = V || 0727570828371435190307038623891673471123350
v=''
v=v||0.69314718055994530941723212145817656807
v=v||5500134360255254120680009493393621969694
v=v||7156058633269964186875420014810205706857
v=v||3368552023575813055703267075163507596193
v=v||0727570828371435190307038623891673471123
v=v||3501153644979552391204751726815749320651
v=v||5552473413952588295045300709532636664265
v=v||4104239157814952043740430385500801944170
v=v||6416715186447128399681717845469570262716
v=v||3106454615025720740248163777338963855069
v=v||5260668341137273873722928956493547025762
v=v||6520988596932019650585547647033067936544
v=v||3254763274495125040606943814710468994650
v=v||6220167720424524529612687946546193165174
v=v||6813926725041038025462596568691441928716
v=v||0829380317271436778265487756648508567407
v=v||7648451464439940461422603193096735402574
v=v||4460703080960850474866385231381816767514
v=v||3866747664789088143714198549423151997354
v=v||8803751658612753529166100071053558249879
v=v||4147295092931138971559982056543928717000
v=v||7218085761025236889213244971389320378439
v=v||3530887748259701715591070882368362758984
v=v||2589185353024363421436706118923678919237
v=v||231467232172053401649256872747782344535348

    return V

::Method log10
/***********************************************************************
* Return log10(x,prec)  specified precision
***********************************************************************/
  Expose precision
  Use Strict Arg x,xprec=(precision)
  iprec=xprec+10
  r=self~log(x,iprec,10)
  Numeric Digits xprec
  Return (r+0)

::Method pi
/* REXX *************************************************************
* Return pi with the specified precision
********************************************************************/
  Expose precision
  Use Strict Arg xprec=(precision)
  p='3.141592653589793238462643383279502884197169399375'||,
    '10582097494459230781640628620899862803482534211706'||,
    '79821480865132823066470938446095505822317253594081'||,
    '28481117450284102701938521105559644622948954930381'||,
    '96442881097566593344612847564823378678316527120190'||,
    '91456485669234603486104543266482133936072602491412'||,
    '73724587006606315588174881520920962829254091715364'||,
    '36789259036001133053054882046652138414695194151160'||,
    '94330572703657595919530921861173819326117931051185'||,
    '48074462379962749567351885752724891227938183011949'||,
    '12983367336244065664308602139494639522473719070217'||,
    '98609437027705392171762931767523846748184676694051'||,
    '32000568127145263560827785771342757789609173637178'||,
    '72146844090122495343014654958537105079227968925892'||,
    '35420199561121290219608640344181598136297747713099'||,
    '60518707211349999998372978049951059731732816096318'||,
    '59502445945534690830264252230825334468503526193118'||,
    '81710100031378387528865875332083814206171776691473'||,
    '03598253490428755468731159562863882353787593751957'||,
    '781857780532171226806613001927876611195909216420199'
  If xprec>1000 Then Do              /* more than 1000 digits wanted */
    iprec=xprec+10                     /* internal precision         */
    Numeric Digits iprec
    new=1
    a=sqrt(2,iprec)
    b=0
    p=2+a
    Do i=1 By 1 Until p=pi
      pi=p
      y=self~sqrt(a,iprec)
      a1=(y+1/y)/2
      b1=y*(b+1)/(b+a)
      p=pi*b1*(1+a1)/(1+b1)
      a=a1
      b=b1
      End
    End
  Numeric Digits xprec
  Return (p+0)

::Method power
/***********************************************************************
* power(base,exponent,precision) returns base**exponent
*                                            -- with specified precision
***********************************************************************/
  Expose precision
  Use Strict Arg b,c,xprec=(precision)
  Numeric Digits xprec
  rsign=1
  If b<0 Then Do                       /* negative base              */
    If datatype(c,'W') Then Do         /* Exponent is an integer     */
      If c//2=1 Then                   /* .. an odd number           */
        rsign=-1                       /* Resuld will be negative    */
      b=abs(b)                         /* proceed with positive base */
      End
    Else Do                            /* Exponent is not an integer */
--    Say 'for a negative base ('||b')',
                           'exponent ('c') must be an integer'
      Return 'nan'                     /* Return not a number        */
      End
    End
  If c=0 Then Do
    If b>=0 Then
      r=1
    End
  Else
    r=self~exp(c,xprec,b)
  If datatype(r)<>'NUM' Then
    Return r
  Return rsign*r

::Method sqrt
/* REXX *************************************************************
* Return sqrt(x,precision) -- with the specified precision
********************************************************************/
  Expose precision type
  Use Strict Arg x,xprec=(precision)
  If x<0 Then Do
    Return 'nan'
    End
  iprec=xprec+10
  Numeric Digits iprec
  r0= x
  r = 1
  Do i=1 By 1 Until r=r0 | (abs(r*r-x)<10**-iprec)
    r0 = r
    r  = (r + x/r) / 2
    End
  Numeric Digits xprec
  Return (r+0)

::Method sin
/* REXX *************************************************************
* Return sin(x,precision,type) -- with the specified precision
* xtype = 'R' (radians, default) 'D' (degrees) 'G' (grades)
* sin(x) = x-(x**3/3!)+(x**5/5!)-(x**7/7!)+-...
********************************************************************/
  Expose precision type
  Use Strict Arg x,xprec=(precision),xtype=(type)
  iprec=xprec+10                       /* internal precision         */
  Numeric Digits iprec
  /* first use pi constant or compute it if necessary                */
  pi=self~pi(iprec)
  /* normalize x to be between 0 and 2*pi (or equivalent)            */
  /* and convert degrees or grades to radians                        */
  xx=x
  Select
    When xtype='R' Then Do
      Do While xx>=pi*2; xx=xx-pi*2; End
      Do While xx<0;     xx=xx+pi*2; End
      End
    When xtype='D' Then Do
      Do While xx>=360;  xx=xx-360; End
      Do While xx<0;     xx=xx+360; End
      xx=xx*pi/180
      End
    When xtype='G' Then Do
      Do While xx>=400;  xx=xx-400; End
      Do While xx<0;     xx=xx+400; End
      xx=xx*pi/200
      End
    End
  /* normalize xx to be between 0 and pi/2                            */
  sign=1
  Select
    When xx<=pi/2   Then Nop
    When xx<=pi     Then xx=pi-xx
    When xx<=3*pi/2 Then Do; sign=-1; xx=xx-pi; End
    Otherwise            Do; sign=-1; xx=2*pi-xx; End
    End
  /* now compute the Taylor series for the normalized xx             */
  o=xx
  u=1
  r=xx
  If abs(xx)<10**(-iprec) Then
    r=0
  Else Do
    Do i=3 By 2 Until ra=r
      ra=r
      o=-o*xx*xx
      u=u*i*(i-1)
      r=r+(o/u)
      End
    End
  Numeric Digits xprec
  Return sign*(r+0)

::Method sinh
/* REXX ****************************************************************
* Return sinh(x,precision) -- with specified precision
* sinh(x) = x+(x**3/3!)+(x**5/5!)+(x**7/7!)+-...
* 920903 Walter Pachl
***********************************************************************/
  Expose precision
  Use Strict Arg x,xprec=(precision)
  iprec=xprec+10
  Numeric Digits iprec
  o=x
  u=1
  r=x
  Do i=3 By 2 Until ra=r
    ra=r
    o=o*x*x
    u=u*i*(i-1)
    r=r+(o/u)
    End
  Numeric Digits xprec
  Return (r+0)

::Method tan
/* REXX *************************************************************
* Return tan(x,precision,type) -- with the specified precision
* tan(x)=sin(x)/cos(x)
********************************************************************/
  Expose precision type
  Use Strict Arg x,xprec=(precision),xtype=(type)
  iprec=xprec+10
  Numeric Digits iprec
  s=self~sin(x,iprec,xtype)
  c=self~cos(x,iprec,xtype)
  If c=0 Then
    Return '+infinity'
  t=s/c
  Numeric Digits xprec
  Return (t+0)

::Method tanh
/***********************************************************************
* Return tanh(x,precision) -- with specified precision
* tanh(x) = sinh(x)/cosh(x)
***********************************************************************/
  Expose precision
  Use Strict Arg x,xprec=(precision)
  iprec=xprec+10
  Numeric Digits iprec
  r=self~sinh(x,iprec)/self~cosh(x,iprec)
  Numeric Digits xprec
  Return (r+0)

::routine rxmarccos public
  Use Strict Arg x,xprec=(.my.rxm~precision),xtype=(.my.rxm~type)

  If datatype(x,'NUM')=0 Then Do
--  Say 'Argument 1 must be a number'
    Raise Syntax 88.902 array(1,x)
    End

  If datatype(xprec,'W')=0 Then Do
--  Say 'Argument 2 must be a positive whole number'
    Raise Syntax 88.905 array(2,xprec)
    End

  If xprec<1 | 999999<xprec Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.907 array(2,1,999999,xprec)
    End

  If x<-1 | 1<x Then
    Return 'nan'

  return .my.rxm~arccos(x,xprec,xtype)

::routine rxmarcsin public
  Use Strict Arg x,xprec=(.my.rxm~precision),xtype=(.my.rxm~type)

  If datatype(x,'NUM')=0 Then Do
--  Say 'Argument 1 must be a number'
    Raise Syntax 88.902 array(1,x)
    End

  If datatype(xprec,'W')=0 Then Do
--  Say 'Argument 2 must be a positive whole number'
    Raise Syntax 88.905 array(2,xprec)
    End

  If xprec<1 | 999999<xprec Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.907 array(2,1,999999,xprec)
    End

  If wordpos(xtype,'R D G')=0 Then Do
--  Say 'Argument 3 must be R, D, or G'
    Raise Syntax 88.907 array(3,'R, D, or G',xtype)
    End

  If x<-1 | 1<x Then
    Return 'nan'

  return .my.rxm~arcsin(x,xprec,xtype)

::routine rxmarctan public
  Use Strict Arg x,xprec=(.my.rxm~precision),xtype=(.my.rxm~type)

  If datatype(x,'NUM')=0 Then Do
--  Say 'Argument 1 must be a number'
    Raise Syntax 88.902 array(1,x)
    End

  If datatype(xprec,'W')=0 Then Do
--  Say 'Argument 2 must be a positive whole number'
    Raise Syntax 88.905 array(2,xprec)
    End

  If xprec<1 | 999999<xprec Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.907 array(2,1,999999,xprec)
    End

  If wordpos(xtype,'R D G')=0 Then Do
--  Say 'Argument 3 must be R, D, or G'
    Raise Syntax 88.907 array(3,'R, D, or G',xtype)
    End

  return .my.rxm~arctan(x,xprec,xtype)

::routine rxmarsinh public
  Use Strict Arg x,xprec=(.my.rxm~precision)

  If datatype(x,'NUM')=0 Then Do
--  Say 'Argument 1 must be a number'
    Raise Syntax 88.902 array(1,x)
    End

  If datatype(xprec,'W')=0 Then Do
--  Say 'Argument 2 must be a positive whole number'
    Raise Syntax 88.905 array(2,xprec)
    End

  If xprec<1 | 999999<xprec Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.907 array(2,1,999999,xprec)
    End

  return .my.rxm~arsinh(x,xprec)

::routine rxmcos public
  Use Strict Arg x,xprec=(.my.rxm~precision),xtype=(.my.rxm~type)

  If datatype(x,'NUM')=0 Then Do
--  Say 'Argument 1 must be a number'
    Raise Syntax 88.902 array(1,x)
    End

  If datatype(xprec,'W')=0 Then Do
--  Say 'Argument 2 must be a positive whole number'
    Raise Syntax 88.905 array(2,xprec)
    End

  If xprec<1 | 999999<xprec Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.907 array(2,1,999999,xprec)
    End

  If wordpos(xtype,'R D G')=0 Then Do
--  Say 'Argument 3 must be R, D, or G'
    Raise Syntax 88.907 array(3,'R, D, or G',xtype)
    End

  return .my.rxm~cos(x,xprec,xtype)

::routine rxmcosh public
  Use Strict Arg x,xprec=(.my.rxm~precision)

  If datatype(x,'NUM')=0 Then Do
--  Say 'Argument 1 must be a number'
    Raise Syntax 88.902 array(1,x)
    End

  If datatype(xprec,'W')=0 Then Do
--  Say 'Argument 2 must be a positive whole number'
    Raise Syntax 88.905 array(2,xprec)
    End

  If xprec<1 | 999999<xprec Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.907 array(2,1,999999,xprec)
    End

  return .my.rxm~cosh(x,xprec)

::routine rxmcotan public
  Use Strict Arg x,xprec=(.my.rxm~precision),xtype=(.my.rxm~type)

  If datatype(x,'NUM')=0 Then Do
--  Say 'Argument 1 must be a number'
    Raise Syntax 88.902 array(1,x)
    End

  If datatype(xprec,'W')=0 Then Do
--  Say 'Argument 2 must be a positive whole number'
    Raise Syntax 88.905 array(2,xprec)
    End

  If xprec<1 | 999999<xprec Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.907 array(2,1,999999,xprec)
    End

  If wordpos(xtype,'R D G')=0 Then Do
--  Say 'Argument 3 must be R, D, or G'
    Raise Syntax 88.907 array(3,'R, D, or G',xtype)
    End

  return .my.rxm~cotan(x,xprec)

::routine rxmexp public
  Use Strict Arg x,xprec=(.my.rxm~precision),xbase=''
  If datatype(x,'NUM')=0 Then Do
--  Say 'Argument 1 must be a number'
    Raise Syntax 88.902 array(1,x)
    End

  If datatype(xprec,'W')=0 Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.905 array(2,xprec)
    End

  If xprec<1 | 999999<xprec Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.907 array(2,1,999999,xprec)
    End

  If datatype(xbase,'NUM')=0 & xbase<>'' Then Do
--  Say 'Argument 3 must be omitted or a number'
    Raise Syntax 88.902 array(3,xbase)
    End

  Select
    When x<0 Then Do
      iprec=xprec+10
      Numeric Digits iprec
      z=.my.rxm~exp(abs(x),iprec,xbase)
      Select
        When z=0 Then Return '+infinity'
        When datatype(z)<>'NUM' Then Return z
        Otherwise r=1/z
        End
      Numeric Digits xprec
      return r+0
      End
    When x=0 Then Do
      If xbase=0 Then
        Return 'nan'
      Else
        Return 1
      End
    Otherwise
      return .my.rxm~exp(x,xprec,xbase)
    End

::routine rxmlog public
  Use Strict Arg x,xprec=(.my.rxm~precision),xbase=''

  If datatype(x,'NUM')=0 Then Do
--  Say 'Argument 1 must be a number'
    Raise Syntax 88.902 array(1,x)
    End

  If datatype(xprec,'W')=0 Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.905 array(2,xprec)
    End

  If xprec<1 | 999999<xprec Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.907 array(2,1,999999,xprec)
    End

  If xbase<>'' &,
     datatype(xbase,'NUM')=0 Then Do
--  Say 'Argument 3 must be a number'
    Raise Syntax 88.902 array(3,xbase)
    End

  If x=0 Then
    Return '-infinity'

  If x<0 Then
    Return 'nan'

  return .my.rxm~log(x,xprec,xbase)

::routine rxmlog10 public
  Use Strict Arg x,xprec=(.my.rxm~precision)

  If datatype(x,'NUM')=0 Then Do
--  Say 'Argument 1 must be a number'
    Raise Syntax 88.902 array(1,x)
    End

  If datatype(xprec,'W')=0 Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.905 array(2,xprec)
    End

  If xprec<1 | 999999<xprec Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.907 array(2,1,999999,xprec)
    End

  If x=0 Then
    Return '-infinity'

  If x<0 Then
    Return 'nan'

  return .my.rxm~log10(x,xprec)

::routine rxmpi public
  Use Strict Arg xprec=(.my.rxm~precision)

  If datatype(xprec,'W')=0 Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.905 array(2,xprec)
    End

  If xprec<1 | 999999<xprec Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.907 array(2,1,999999,xprec)
    End

  return .my.rxm~pi(xprec)

::routine rxmpower public
  Use Strict Arg b,e,xprec=(.my.rxm~precision)

  If datatype(b,'NUM')=0 Then Do
--  Say 'Argument 1 must be a number'
    Raise Syntax 88.902 array(1,b)
    End

  If datatype(e,'NUM')=0 Then Do
--  Say 'Argument 2 must be a number'
    Raise Syntax 88.902 array(2,e)
    End

  If datatype(xprec,'W')=0 Then Do
--  Say 'Argument 3 must be a whole number between 1 and 999999'
    Raise Syntax 88.905 array(2,xprec)
    End

  If xprec<1 | 999999<xprec Then Do
--  Say 'Argument 3 must be a whole number between 1 and 999999'
    Raise Syntax 88.907 array(3,1,999999,xprec)
    End

  If b<0 & datatype(e,'W')=0 Then
    Return 'nan'

  return .my.rxm~power(b,e,xprec)

::routine rxmsqrt public
  Use Strict Arg x,xprec=(.my.rxm~precision)

  If datatype(x,'NUM')=0 Then Do
--  Say 'Argument 1 must be a number'
    Raise Syntax 88.902 array(1,x)
    End

  If datatype(xprec,'W')=0 Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.905 array(2,xprec)
    End

  If xprec<1 | 999999<xprec Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.907 array(2,1,999999,xprec)
    End
  Select
    When x<0 Then Return 'nan'
    When x=0 Then Return 0
    Otherwise
      return .my.rxm~sqrt(x,xprec)
    End

::routine rxmsin public
  Use Strict Arg x,xprec=(.my.rxm~precision),xtype=(.my.rxm~type)

  If datatype(x,'NUM')=0 Then Do
--  Say 'Argument 1 must be a number'
    Raise Syntax 88.902 array(1,x)
    End

  If datatype(xprec,'W')=0 Then Do
--  Say 'Argument 2 must be a positive whole number'
    Raise Syntax 88.905 array(2,xprec)
    End

  If xprec<1 | 999999<xprec Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.907 array(2,1,999999,xprec)
    End

  If wordpos(xtype,'R D G')=0 Then Do
--  Say 'Argument 3 must be R, D, or G'
    Raise Syntax 88.907 array(3,'R, D, or G',xtype)
    End

  return .my.rxm~sin(x,xprec,xtype)

::routine rxmsinh public
  Use Strict Arg x,xprec=(.my.rxm~precision)

  If datatype(x,'NUM')=0 Then Do
--  Say 'Argument 1 must be a number'
    Raise Syntax 88.902 array(1,x)
    End

  If datatype(xprec,'W')=0 Then Do
--  Say 'Argument 2 must be a positive whole number'
    Raise Syntax 88.905 array(2,xprec)
    End

  If xprec<1 | 999999<xprec Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.907 array(2,1,999999,xprec)
    End

  return .my.rxm~sinh(x,xprec)

::routine rxmtan public
  Use Strict Arg x,xprec=(.my.rxm~precision),xtype=(.my.rxm~type)

  If datatype(x,'NUM')=0 Then Do
--  Say 'Argument 1 must be a number'
    Raise Syntax 88.902 array(1,x)
    End

  If datatype(xprec,'W')=0 Then Do
--  Say 'Argument 2 must be a positive whole number'
    Raise Syntax 88.905 array(2,xprec)
    End

  If xprec<1 | 999999<xprec Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.907 array(2,1,999999,xprec)
    End

  If wordpos(xtype,'R D G')=0 Then Do
--  Say 'Argument 3 must be R, D, or G'
    Raise Syntax 88.907 array(3,'R, D, or G',xtype)
    End

  return .my.rxm~tan(x,xprec,xtype)

::routine rxmtanh public
  Use Strict Arg x,xprec=(.my.rxm~precision)

  If datatype(x,'NUM')=0 Then Do
--  Say 'Argument 1 must be a number'
    Raise Syntax 88.902 array(1,x)
    End

  If datatype(xprec,'W')=0 Then Do
--  Say 'Argument 2 must be a positive whole number'
    Raise Syntax 88.905 array(2,xprec)
    End

  If xprec<1 | 999999<xprec Then Do
--  Say 'Argument 2 must be a whole number between 1 and 999999'
    Raise Syntax 88.907 array(2,1,999999,xprec)
    End

  return .my.rxm~tanh(x,xprec)

::routine rxmhelp public
  Use Arg xprec=(.my.rxm~precision),xtype=(.my.rxm~type)
                   Say 'precision='xprec
                   Say '     type='xtype
  Parse source  s; Say '   source='s
  Parse version v; Say '  version='v
  Do si=2 To 5
    Say substr(sourceline(si),3)
    End
  Say 'You can change the default precision and type as follows:'
  Say "  .locaL~my.rxm~precision=50"
  Say "  .locaL~my.rxm~type='R'"
  return 0
