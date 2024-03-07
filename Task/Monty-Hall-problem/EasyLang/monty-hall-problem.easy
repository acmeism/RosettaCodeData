max = 1000000
for i = 1 to max
   car_door = randint 3
   chosen_door = randint 3
   if car_door <> chosen_door
      montys_door = 6 - car_door - chosen_door
   else
      repeat
         montys_door = randint 3
         until montys_door <> car_door
      .
   .
   if car_door = chosen_door
      stay += 1
   .
   if car_door = 6 - montys_door - chosen_door
      switch += 1
   .
.
print "If you stick to your choice, you have a " & stay / max * 100 & " percent chance to win"
print "If you switched, you have a " & switch / max * 100 & " percent chance to win"
