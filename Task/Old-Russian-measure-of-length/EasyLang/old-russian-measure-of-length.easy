units$[] = [ "tochka" "liniya" "dyuim" "vershok" "piad" "fut" "arshin" "sazhen" "versta" "milia" "centimeter" "meter" "kilometer" ]
convs[] = [ 0.254 0.254 2.54 4.445 17.78 30.48 71.12 213.36 10668 74676 1 100 10000 ]
for i to len units$[]
   print i & ") " & units$[i]
.
print ""
write "Please choose a unit (1 to 13): "
repeat
   unit = number input
   until unit >= 1 and unit <= 13
.
print unit
write "Now enter a value in that unit: "
repeat
   value = -1
   value = number input
   print value
   until value >= 0
.
print value
print ""
print value & " " & units$[unit] & " are"
print ""
for i to len units$[]
   if i <> unit
      print value * convs[unit] / convs[i] & " " & units$[i]
   .
.
