set d1=createobject("Scripting.Dictionary")
d1.add "name", "Rocket Skates"
d1.add "price", 12.75
d1.add "color", "yellow"

set d2=createobject("Scripting.Dictionary")
d2.add "price", 15.25
d2.add "color", "red"
d2.add "year", 1974

set d3=createobject("Scripting.Dictionary")
for each k1 in d1.keys
   if not d3.exists(k1) then
     d3.add k1, d1(k1)
   else
     d3(k1)=d1(k1)
   end if
next	
for each k2 in d2.keys
   if not d3.exists(k2) then
      d3.add k2, d2(k2)
   else
      d3(k2)=d2(k2)
   end if
next	

for each k3 in d3.keys
   wscript.echo k3 & vbtab & d3(k3)
next	
