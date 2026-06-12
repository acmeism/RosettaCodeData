with createobject("ADODB.Stream")
  .charset ="UTF-8"
  .open
  .loadfromfile("unixdict.txt")
  s=.readtext
end with
a=split (s,vblf)
with new regexp
  .pattern=".*?the.*"

for each i in a
  if len(trim(i))>=11 then
   if .test(i) then wscript.echo i
  end if
next
end with
