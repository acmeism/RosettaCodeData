LevenshteinDistance: Procedure
Parse Arg s,t
If s==t Then Return 0;
sl=length(s)
tl=length(t)
If sl=0 Then Return tl
If tl=0 Then Return sl
Do i=0 To tl
  v0.i=i
  End
Do i=0 To sl-1
  v1.0=i+1
  Do j=0 To tl-1
    jj=j+1
    cost=substr(s,i+1,1)<>substr(t,j+1,1)
    v1.jj=min(v1.j+1,v0.jj+1,v0.j+cost)
    End
  Do j=0 to tl-1
    v0.j=v1.j
    End
  End
return v1.tl
