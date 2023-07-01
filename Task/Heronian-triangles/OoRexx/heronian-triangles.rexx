/*REXX pgm generates primitive Heronian triangles by side length & area.*/
  Call time 'R'
  Numeric Digits 12
  Parse Arg mxs area list
  If mxs ='' Then mxs =200
  If area='' Then area=210
  If list='' Then list=10
  tx='primitive Heronian triangles'
  Call heronian mxs            /* invoke sub with max SIDES.     */
  Say nt tx 'found with side length up to' mxs "(inclusive)."
  Call show '2'
  Call show '3'
  Say time('E') 'seconds elapsed'
  Exit

heronian:
  abc.=0  /* abc.ar.p.* contains 'a b c' for area ar and perimeter p */
  nt=0                              /* number of triangles found     */
  min.=''
  max.=''
  mem.=0
  ln=length(mxs)
  Do a=3 To mxs
    Do b=a To mxs
      ab=a+b
      Do c=b To mxs
        If hgcd(a,b,c)=1 Then Do    /* GCD=1                         */
          ar=heron_area()
          If pos('.',ar)=0 Then Do  /* is an integer                 */
            nt=nt+1                 /* a primitive Heronian triangle.*/
            Call minmax '0P',p
            Call minmax '0A',a
            per=ab+c
            abc_ar=right(per,4) right(a,4) right(b,4) right(c,4),
                                                            right(ar,5)
            Call mem abc_ar
            End
          End
        End
      End
    End
  /*
  say 'min.p='min.0p
  say 'max.p='max.0p
  say 'min.a='min.0a
  say 'max.a='max.0a
  */
  Return nt

hgcd: Procedure
  Parse Arg x
  Do j=2 For 2
    y=arg(j)
    Do Until _==0
      _=x//y
      x=y
      y=_
      End
    End
  Return x

minmax:
  Parse Arg which,x
  If min.which='' Then Do
    min.which=x
    max.which=x
    End
  Else Do
    min.which=min(min.which,x)
    max.which=max(max.which,x)
    End
  --Say which min.which '-' max.which
  Return

heron_area:
  p=ab+c                           /* perimeter                      */
  s=p/2
  ar2=s*(s-a)*(s-b)*(s-c)          /* area**2                        */
  If pos(right(ar2,1),'014569')=0 Then /* ar2 cannot be              */
    Return '.'                         /* square of an integer*/
  If ar2>0 Then
    ar=sqrt(ar2)                   /* area                           */
  Else
    ar='.'
  Return ar

show: Parse Arg which
  Say ''
  Select
    When which='2' Then Do
      Say 'Listing of the first' list tx":"
      Do i=1 To list
        Call ot i,mem.i
        End
      End
    When which='3' Then Do
      Say 'Listing of the' tx "with area=210"
      j=0
      Do i=1 To mem.0
        Parse Var mem.i per a b c area
        If area=210 Then Do
          j=j+1
          Call ot j,mem.i
          End
        End
      End
    End
  Return

ot: Parse Arg k,mem
    Parse Var mem per a b c area
    Say right(k,9)'     area:'right(area,6)||,
                '      perimeter:'right(per,4)'     sides:',
                       right(a,3) right(b,3) right(c,3)
    Return

mem:
  Parse Arg e
  Do i=1 To mem.0
    If mem.i>>e Then Leave
    End
  Do j=mem.0 to i By -1
    j1=j+1
    mem.j1=mem.j
    End
  mem.i=e
  mem.0=mem.0+1
  Return
/* for "Classic" REXX
sqrt: procedure; parse arg x;if x=0 then return 0;d=digits();numeric digits 11
numeric form;  parse value format(x,2,1,,0) 'E0' with g 'E' _ .;  g=g*.5'E'_%2
p=d+d%4+2; m.=11;  do j=0 while p>9; m.j=p; p=p%2+1; end;  do k=j+5 to 0 by -1
if m.k>11 then numeric digits m.k;g=.5*(g+x/g);end;numeric digits d;return g/1
*/
/* for ooRexx */
::requires rxmath library
::routine sqrt
  Return rxCalcSqrt(arg(1),14)
