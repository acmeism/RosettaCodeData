/*REXX program uses a subtractive generaTor,and creates a sequence of ranDom numbers. */
/* array index must be positive! */
s=.array~new
r=.array~new
s[1]=292929
s[2]=1
billion=1e9
numeric digits 20
ci=55
Do i=2 To ci-1
  s[i+1]=mod(s[i-1]-s[i],billion)
  End
cp=34
Do j=0 To ci-1
  r[j+1]=s[mod(cp*(j+1),ci)+1]
  End
m=219
cj= 24
Do k=ci To m
  _=k//ci
  r[_+1]=mod(r[mod(k-ci,ci)+1]-r[mod(k-cj,ci)+1],billion)
  End
t=235
Do n=m+1 To t
  _=n//ci
  r[_+1]=mod(r[mod(n-ci,ci)+1]-r[mod(n-cj,ci)+1],billion)
  Say right(r[_+1],40)
  End
Exit
mod: Procedure
Parse Arg a,b
Return ((a//b)+b)//b
