/*REXX*/
Parse Value '1 2 3' With n.1 n.2 n.3
Parse Value '3 3 3' With p.1 p.2 p.3
Parse Value '0 2 4' With a.1 a.2 a.3
Parse Value '3 2 1' With v.1 v.2 v.3

a=n.1
b=n.2
c=n.3
d=n.1*p.1+n.2*p.2+n.3*p.3  /* Parameter form of the plane */
Select
  When a=0 Then
    pd=''
  When a=1 Then
    pd='x'
  When a=-1 Then
    pd='-x'
  Otherwise
    pd=a'*x'
  End
pd=pd
yy=mk2('y',b)
Select
  When left(yy,1)='-' Then
    pd=pd '-' substr(yy,2)
  When left(yy,1)='0' Then
    Nop
  Otherwise
    pd=pd '+' yy
  End
zz=mk2('z',c)
Select
  When left(zz,1)='-' Then
    pd=pd '-' substr(zz,2)
  When left(zz,1)='0' Then
    Nop
  Otherwise
    pd=pd '+' zz
  End
pd=pd '=' d

Say 'Plane definition:' pd

ip=0
Do i=1 To 3
  ip=ip+n.i*v.i
  dd=n.1*a.1+n.2*a.2+n.3*a.3
  End
If ip=0 Then Do
  If dd=d Then
    Say 'Line is part of the plane'
  Else
    Say 'Line is parallel to the plane'
  Exit
  End

t=(d-(a*a.1+b*a.2+c*a.3))/(a*v.1+b*v.2+c*v.3)

x=a.1+t*v.1
y=a.2+t*v.2
z=a.3+t*v.3

ld=mk('x',a.1,v.1) ';' mk('y',a.2,v.2) ';' mk('z',a.3,v.3)
Say 'Line definition:' ld

Say 'Intersection: P('||x','y','z')'
Exit

Mk: Procedure
/*---------------------------------------------------------------------
* build part of line definition
*--------------------------------------------------------------------*/
Parse Arg v,aa,vv
If aa<>0 Then
  res=v'='aa
Else
  res=v'='
Select
  When vv=0 Then
    res=res||'0'
  When vv=-1 Then
    res=res||'-t'
  When vv<0 Then
    res=res||vv'*t'
  Otherwise Do
    If res=v'=' Then Do
      If vv=1 Then
        res=res||'t'
      Else
        res=res||vv'*t'
      End
    Else Do
      If vv=1 Then
        res=res||'+t'
      Else
        res=res||'+'vv'*t'
      End
    End
  End
Return res

mk2: Procedure
/*---------------------------------------------------------------------
* build part of plane definition
*--------------------------------------------------------------------*/
Parse Arg v,u
Select
  When u=0 Then
    res=''
  When u=1 Then
    res=v
  When u=-1 Then
    res='-'v
  When u<0 Then
    res=u'*'v
  Otherwise Do
    If pd<>'' Then
      res='+'u'*'v
    Else
      res=u'*'v
    End
  End
Return res
