import random

randomize()

proc shuffle[T](x: var seq[T]) =
  for i in countdown(x.high, 0):
    let j = rand(i)
    swap(x[i], x[j])

# 1 represents a car
# 0 represent a goat

var
  stay = 0   # amount won if stay in the same position
  switch = 0 # amount won if you switch

for i in 1..1000:
  var lst = @[1,0,0]  # one car and two goats
  shuffle(lst)        # shuffles the list randomly
  let ran = rand(2  ) # gets a random number for the random guess
  let user = lst[ran] # storing the random guess
  del lst, ran        # deleting the random guess

  var huh = 0
  for i in lst:       # getting a value 0 and deleting it
    if i == 0:
      del lst, huh    # deletes a goat when it finds it
      break
    inc huh

  if user == 1:       # if the original choice is 1 then stay adds 1
    inc stay

  if lst[0] == 1:     # if the switched value is 1 then switch adds 1
    inc switch

echo "Stay = ",stay
echo "Switch = ",switch
