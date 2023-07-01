dim t()
if Wscript.arguments.count=1 then
  n=Wscript.arguments.item(0)
else
  n=15
end if
redim t(n+1)
't(*)=0
t(1)=1
for i=1 to n
  ip=i+1
  for j = i to 1 step -1
    t(j)=t(j)+t(j-1)
  next 'j
  t(i+1)=t(i)
  for j = i+1 to 1 step -1
    t(j)=t(j)+t(j-1)
  next 'j
  Wscript.echo t(i+1)-t(i)
next 'i
