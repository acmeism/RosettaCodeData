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
  if len(s)>5 then
    if instr(s,"i") then d.add s,""
    if instr(s,"e") then b(i)=s:  i=i+1
  end if
next
redim preserve b(i-1)

for i=0 to ubound(b)
  s=trim(b(i))
  s2=replace(s,"e","i")
  if d.exists(s2) then
    wscript.echo left(s& space(10),10) & "-> " & s2
  end if
next

