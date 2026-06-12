/* REXX ---------------------------------------------------------------
* 24.07.2014 Walter Pachl translated from Pascal
*            extend with decryption (following Pascal)
* 25.07.2014 WP changed i+=8 to I=I+8 (courtesy GS)
* 26.07-2014 WP removed extraneous semicolons
*--------------------------------------------------------------------*/
Numeric Digits 32
aa=0
bb=0
cc=0
mm.=0
randcnt=0
randrsl.=0
msg='a Top Secret secret'
key='this is my secret key'
iMode='iEncrypt'

Call iSeed key,1          /* 1) seed ISAAC with the key */
xctx=Vernam(msg)          /* 2) Vernam XOR encryption   */
mode='iEncrypt'
mctx=Vigenere(msg,mode)   /* 3) MOD encryption          */
Call iSeed key,1
xptx=Vernam(xctx)         /* a) XOR (Vernam)            */
mode='iDecrypt'
mptx=Vigenere(mctx,mode)  /* b) MOD (Vigenere)          */
                          /* program output             */
Say 'Message: 'msg
Say 'Key    : 'key
Say 'XOR    : 'c2x(xctx)
Say 'MOD    : 'c2x(mctx)
Say 'XOR dcr: 'xptx
Say 'MOD dcr: 'mptx
Exit

isaac: Procedure      Expose mm. aa bb cc randrsl. randcnt
  cc=add(cc,1)
  bb=add(bb,cc)
  Do i=0 To 255
    x=mm.i
    im4=i//4
    Select
      When im4=0 Then aa=xor(aa,shl(aa,13))
      When im4=1 Then aa=xor(aa,shr(aa, 6))
      When im4=2 Then aa=xor(aa,shl(aa, 2))
      When im4=3 Then aa=xor(aa,shr(aa,16))
      End
    z=(i+128)//256
    aa=add(mm.z,aa)
    z=shr(x,2)//256
    y=add(mm.z,aa,bb)
    mm.i=y
    z=shr(y,10)//256
    bb=add(mm.z,x)
    randrsl.i=bb
    End
  randcnt=0
  Return

mix: Procedure        Expose a b c d e f g h mm. aa bb cc randrsl. randcnt
  a=xor(a,shl(b,11)); d=add(d,a); b=add(b,c)
  b=xor(b,shr(c, 2)); e=add(e,b); c=add(c,d)
  c=xor(c,shl(d, 8)); f=add(f,c); d=add(d,e)
  d=xor(d,shr(e,16)); g=add(g,d); e=add(e,f)
  e=xor(e,shl(f,10)); h=add(h,e); f=add(f,g)
  f=xor(f,shr(g, 4)); a=add(a,f); g=add(g,h)
  g=xor(g,shl(h, 8)); b=add(b,g); h=add(h,a)
  h=xor(h,shr(a, 9)); c=add(c,h); a=add(a,b)
  Return

iRandInit: Procedure  Expose mm. randrsl. randcnt
  Parse Arg flag
  aa=0; bb=0; cc=0
  a= 2654435769 /* $9e3779b9;        // the golden ratio */

  b=a; c=a; d=a; e=a; f=a; g=a; h=a

  do i=0 TO 3
    Call mix
    End

  i=0
  do until i>255    /* fill in mm[] with messy stuff */
    IF flag THEN Do /* use all the information in the seed */
      Call setix
      a=add(a,randrsl.i);  b=add(b,randrsl.i1)
      c=add(c,randrsl.i2); d=add(d,randrsl.i3)
      e=add(e,randrsl.i4); f=add(f,randrsl.i5)
      g=add(g,randrsl.i6); h=add(h,randrsl.i7)
      End
    Call mix
    mm.i=a;  mm.i1=b; mm.i2=c; mm.i3=d
    mm.i4=e; mm.i5=f; mm.i6=g; mm.i7=h
    i=i+8
    End

  IF flag THEN Do /* do a second pass to make all of the seed affect all of mm  */
    i=0
    do until i>255    /* fill in mm[] with messy stuff */
      Call setix
      a=add(a,mm.i);  b=add(b,mm.i1); c=add(c,mm.i2); d=add(d,mm.i3)
      e=add(e,mm.i4); f=add(f,mm.i5); g=add(g,mm.i6); h=add(h,mm.i7)
      Call mix
      mm.i=a;  mm.i1=b; mm.i2=c; mm.i3=d
      mm.i4=e; mm.i5=f; mm.i6=g; mm.i7=h
      i=i+8
      End
    End
  Call isaac       /* fill in the first set of results        */
  randcnt=0;       /* prepare to use the first set of results */
  Return

iseed: Procedure      Expose aa bb cc randcnt randrsl. mm.
/*---------------------------------------------------------------------
* Seed ISAAC with a given string.
*  The string can be any size. The first 256 values will be used.
*--------------------------------------------------------------------*/
  Parse Arg seed,flag
  mm.=0
  m=Length(seed)-1
  Do i=0 TO 255
    IF i>m THEN   /* in case seed has less than 256 elements */
      randrsl.i=0
    ELSE
      randrsl.i=c2d(substr(seed,i+1,1))
    end
  Call iRandInit flag   /* initialize ISAAC with seed */
  Return

iRandom: Procedure    Expose aa bb cc randcnt randrsl. mm.
/* Get a random 32-bit value 0..MAXINT */
  iRandom=randrsl.randcnt
  randcnt=randcnt+1
  If randcnt>255 Then Do
    Call isaac
    randcnt=0
    End
  Return irandom

iRandA: Procedure     Expose aa bb cc randcnt randrsl. mm.
/* Get a random character in printable ASCII range */
  iRandA=iRandom()//95+32
  Return iRandA

xor: Procedure        Expose aa bb cc randcnt randrsl. mm.
  Parse Arg a,b
  ac=d2c(a,4)
  bc=d2c(b,4)
  res=c2d(bitxor(ac,bc))
  return res//4294967296

Vernam: Procedure     Expose aa bb cc randcnt randrsl. mm.
/* XOR encrypt on random stream. Output: string of hex chars */
  Parse Arg msg
  Vernam=''
  Do i=1 to length(msg)
    Vernam=Vernam||d2c(xor(iRandA(),c2d(substr(msg,i,1))))
    End
  Return Vernam

letternum: Procedure  Expose aa bb cc randcnt randrsl. mm.
/* Get position of the letter in chosen alphabet */
  Parse Arg letter,start
  letternum=c2d(letter)-c2d(start)
  Return letternum

Caesar: Procedure     Expose aa bb cc randcnt randrsl. mm.
/* Caesar-shift a character <shift> places: Generalized Vigenere */
  Parse Arg m,ch,shift,modulo,start
  IF m='iDecrypt' TheN shift=-shift
  n=letternum(ch,start)+shift
  n=n//modulo
  IF n<0 Then n=n+modulo
  Caesar=d2c(c2d(start)+n)
  Return Caesar

Vigenere: Procedure   Expose aa bb cc randcnt randrsl. mm.
/* Vigenere mod 95 encryption. Output: string of hex chars */
  Parse Arg msg,m
  Vigenere=''
  Do i=1 to length(msg)
    Vigenere=Vigenere||Caesar(m,substr(msg,i,1),iRandA(),95,' ')
    End
  Return Vigenere

shl: Procedure
  res=arg(1)*(2**arg(2))
  return res//4294967296

shr: Procedure
  res=arg(1)%(2**arg(2))
  return res//4294967296

setix:
  i1=i+1
  i2=i+2
  i3=i+3
  i4=i+4
  i5=i+5
  i6=i+6
  i7=i+7
  Return

add: Procedure
/* add argumemnts modulo 4294967296 */
  res=arg(1)+arg(2)
  If arg(3)<>'' Then
    res=res+arg(3)
  return res//4294967296
