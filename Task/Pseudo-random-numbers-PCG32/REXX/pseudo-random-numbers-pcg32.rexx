Numeric Digits 40
N     = 6364136223846793005
state = x2d('853c49e6748fea9b',16)
inc   = x2d('da3e39cb94b95bdb',16)
Call seed 42,54
Do zz=1 To 5
  res=nextint()
  Say int2str(res)
  End
Call seed 987654321,1
cnt.=0
Do i=1 To 100000
  z=nextfloat()
  cnt.z=cnt.z+1
  End
Say ''
Say 'The counts for 100,000 repetitions are:'
Do z=0 To 4
  Say format(z,2) ':' format(cnt.z,5)
  End
Exit

int2str: Procedure
int=arg(1)
intx=d2x(int,8)
res=x2d(copies(0,8)intx,16)
Return res

seed:
Parse Arg seedState,seedSequence
state=0
inc=dshift(seedSequence,-1)
inc=x2d(or(d2x(inc,16),d2x(1,16)),16)
z=nextint()
state=javaadd(state,seedState)
z=nextint()
Return

nextInt:
old = state
oldxN = javamult(old,n)
statex= javaadd(oldxN,inc)
state=statex
oldx=d2x(old,16)
oldb=x2b(oldx)
oldb18=copies(0,18)left(oldb,64-18)
oldb18o=bxor(oldb18,oldb)
rb=copies(0,27)left(oldb18o,64-27)
rx=b2x(rb)
shifted=x2d(substr(rx,9),8)
oldx=d2x(old,16)
oldb=x2b(oldx)
oldb2=copies(0,59)left(oldb,length(oldb)-59)
oldx2=b2x(oldb2)
rotx=x2d(substr(oldx2,9),8)
t1=ishift(shifted,rotx,'L')
t2=x2d(xneg(d2x(rotx,8)),8)
t3=t2+1
t4=x2d(xand(d2x(t3,8),d2x(31,8)),8)
t5=dshift(shifted,-t4)
t5x=d2x(t5,16)
t5y=substr(t5x,9)
t5z=x2d(t5y,16)
t7=x2d(or(d2x(t1,16),d2x(t5z,16)),16)
t8=long2int(t7)
Return t8

nextfloat:
ni=nextint()
nix=d2x(ni,8)
niz=copies(0,8)nix
u=x2d(niz,16)
uu=u/(2**32)
z=uu*5%1
Return z

javaadd: Procedure
/**********************************************************************
* Add two long integers and ignore the possible overflow
**********************************************************************/
Numeric Digits 40
Parse Arg a,b
r=a+b
rx=d2x(r,18)
res=right(rx,16)
return x2d(res,16)

javamult: Procedure
/**********************************************************************
* Multiply java style
**********************************************************************/
Numeric Digits 40
Parse Arg a,b
m=d2x(a*b,16)
res=x2d(m,16)
Return res

bxor: Procedure
/**********************************************************************
* Exclusive Or two bit strings
**********************************************************************/
Parse arg a,b
res=''
Do i=1 To length(a)
  res=res||(substr(a,i,1)<>substr(b,i,1))
  End
Return res

xxor: Procedure
/**********************************************************************
* Exclusive Or two hex strings
**********************************************************************/
Parse Arg u,v
ub=x2b(u)
vb=x2b(v)
res=''
Do i=1 To 64
  res=res||(substr(ub,i,1)<>substr(vb,i,1))
  End
res=b2x(res)
Return res

xand: Procedure
/**********************************************************************
* And two hex strings
**********************************************************************/
Parse Arg u,v
ub=x2b(u)
vb=x2b(v)
res=''
Do i=1 To length(ub)
  res=res||(substr(ub,i,1)&substr(vb,i,1))
  End
res=b2x(res)
Return res

or: Procedure
/**********************************************************************
* Or two hex strings
**********************************************************************/
Parse Arg u,v
ub=x2b(u)
vb=x2b(v)
res=''
Do i=1 To length(ub)
  res=res||(substr(ub,i,1)|substr(vb,i,1))
  End
res=b2x(res)
Return res

long2int: Procedure
/**********************************************************************
* Cast long to int
**********************************************************************/
Parse Arg long
longx=d2x(long,16)
int=x2d(substr(longx,9),8)
Return int

xneg: Procedure
/**********************************************************************
* Negate a hex string
**********************************************************************/
Parse Arg s
sb=x2b(s)
res=''
Do i=1 To length(sb)
  res=res||\substr(sb,i,1)
  End
res=b2x(res)
Return res

dshift: Procedure
/**********************************************************************
* Implement the shift operations for a long variable
* r = dshift(long,shift[,mode])  >>  Mode='L' logical right shift
*                                >>> Mode='A' arithmetic right shift
*                                <<  xhift<0  left shift
********************************************`*************************/
Parse Upper Arg n,s,o
Numeric Digits 40
If o='' Then o='L'
nx=d2x(n,16)
nb=x2b(nx)
If s<0 Then Do
  s=abs(s)
  rb=substr(nb,s+1)||copies('0',s)
  rx=b2x(rb)
  r=x2d(rx,16)
  End
Else Do
  If o='L' Then Do
    rb=left(copies('0',s)nb,length(nb))
    rx=b2x(rb)
    r=x2d(rx,16)
    End
  Else Do
    rb=left(copies(left(nb,1),s)nb,length(nb))
    rx=b2x(rb)
    r=x2d(rx,16)
    End
  End
Return r

ishift: Procedure
/**********************************************************************
* Implement the shift operations for an int variable
* r = dshift(int,shift[,mode])   >>  Mode='L' logical right shift
*                                >>> Mode='A' arithmetic right shift
*                                <<  xhift<0  left shift
********************************************`*************************/
Parse Upper Arg n,s,o
Numeric Digits 40
If o='' Then o='L'
nx=d2x(n,8)
nb=x2b(nx)
If s<0 Then Do
  s=abs(s)
  rb=substr(nb,s+1)||copies('0',s)
  rx=b2x(rb)
  r=x2d(rx,8)
  End
Else Do
  If o='L' Then Do
    rb=left(copies('0',s)nb,length(nb))
    rx=b2x(rb)
    r=x2d(rx,8)
    End
  Else Do
    rb=left(copies(left(nb,1),s)nb,length(nb))
    rx=b2x(rb)
    r=x2d(rx,8)
    End
  End
Return r

b2x: Procedure Expose x.
/**********************************************************************
* Convert a Bit string to a Hex stríng
**********************************************************************/
Parse Arg b
z='0'; bits.z='0000'; y=bits.z; x.y=z
z='1'; bits.z='0001'; y=bits.z; x.y=z
z='2'; bits.z='0010'; y=bits.z; x.y=z
z='3'; bits.z='0011'; y=bits.z; x.y=z
z='4'; bits.z='0100'; y=bits.z; x.y=z
z='5'; bits.z='0101'; y=bits.z; x.y=z
z='6'; bits.z='0110'; y=bits.z; x.y=z
z='7'; bits.z='0111'; y=bits.z; x.y=z
z='8'; bits.z='1000'; y=bits.z; x.y=z
z='9'; bits.z='1001'; y=bits.z; x.y=z
z='A'; bits.z='1010'; y=bits.z; x.y=z
z='B'; bits.z='1011'; y=bits.z; x.y=z
z='C'; bits.z='1100'; y=bits.z; x.y=z
z='D'; bits.z='1101'; y=bits.z; x.y=z
z='E'; bits.z='1110'; y=bits.z; x.y=z
z='F'; bits.z='1111'; y=bits.z; x.y=z
x=''
Do While b<>''
  Parse Var b b4 +4 b
  x=x||x.b4
  End
Return x

x2b: Procedure Expose bits.
/***********************************************************************
* Convert a Hex string to a Bit stríng
***********************************************************************/
Parse Arg x
z='0'; bits.z='0000'; y=bits.z; x.y=z
z='1'; bits.z='0001'; y=bits.z; x.y=z
z='2'; bits.z='0010'; y=bits.z; x.y=z
z='3'; bits.z='0011'; y=bits.z; x.y=z
z='4'; bits.z='0100'; y=bits.z; x.y=z
z='5'; bits.z='0101'; y=bits.z; x.y=z
z='6'; bits.z='0110'; y=bits.z; x.y=z
z='7'; bits.z='0111'; y=bits.z; x.y=z
z='8'; bits.z='1000'; y=bits.z; x.y=z
z='9'; bits.z='1001'; y=bits.z; x.y=z
z='A'; bits.z='1010'; y=bits.z; x.y=z
z='B'; bits.z='1011'; y=bits.z; x.y=z
z='C'; bits.z='1100'; y=bits.z; x.y=z
z='D'; bits.z='1101'; y=bits.z; x.y=z
z='E'; bits.z='1110'; y=bits.z; x.y=z
z='F'; bits.z='1111'; y=bits.z; x.y=z
b=''
Do While x<>''
  Parse Var x c +1 x
  b=b||bits.c
  End
Return b
