'permutation ,recursive
a=array("Hello",1,True,3.141592)
cnt=0
perm a,0
wscript.echo vbcrlf &"Count " & cnt

sub print(a)
  s=""
  for i=0  to ubound(a):
    s=s &" " & a(i):
  next:
  wscript.echo s :
  cnt=cnt+1 :
end sub
sub swap(a,b) t=a: a=b :b=t:  end sub

sub perm(byval a,i)
   if i=ubound(a) then print a: exit sub
   for j= i to ubound(a)
      swap a(i),a(j)
      perm a,i+1
     swap a(i),a(j)
   next
end sub
