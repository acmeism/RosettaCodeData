with createobject("ADODB.Stream")
  .charset ="UTF-8"
  .open
  .loadfromfile("unixdict.txt")
  s=.readtext
end with
a=split (s,vblf)
set d=createobject("scripting.dictionary")
redim b(ubound(a))
i=0
for each x in a
  s=trim(x)
  if len(s)>=9 then
    if len(s)= 9 then d.add s,""
    b(i)=s
    i=i+1
  end if
next
redim preserve b(i-1)
wscript.echo i
j=1
for i=0 to ubound(b)-9
  s9=mid(b(i+0),1,1)& mid(b(i+1),2,1)& mid(b(i+2),3,1)& mid(b(i+3),4,1)& mid(b(i+4),5,1)&_
  mid(b(i+5),6,1)& mid(b(i+6),7,1)& mid(b(i+7),8,1)& mid(b(i+8),9,1)
  'wscript.echo b(i), s9
  if d.exists(s9) then
    wscript.echo j,s9
    d.remove(s9)
    j=j+1
  end if
next

