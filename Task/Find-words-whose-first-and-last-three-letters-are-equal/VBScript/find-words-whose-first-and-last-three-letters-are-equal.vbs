with createobject("ADODB.Stream")
  .charset ="UTF-8"
  .open
  .loadfromfile("unixdict.txt")
  s=.readtext
end with
a=split (s,vblf)

set d= createobject("Scripting.Dictionary")
for each aa in a
  x=trim(aa)
  l=len(x)
  if l>5 then
   d.removeall
   for i=1 to 3
     m=mid(x,i,1)
     if not d.exists(m) then d.add m,null
   next
   res=true
   for i=l-2 to l
     m=mid(x,i,1)
     if not d.exists(m) then
       res=false:exit for
      else
        d.remove(m)
      end if
   next
   if res then
     wscript.stdout.write left(x & space(15),15)
     if left(x,3)=right(x,3) then  wscript.stdout.write "*"
     wscript.stdout.writeline
    end if
  end if
next
