### Bert Mariani
### 2018-03-01
### Guess_My_Number

myNumber = random(10)
answer   = 0

See "Guess my number between 1 and 10"+ nl

while answer != myNumber
  See "Your guess: "
  Give answer

  if answer = myNumber
    See "Well done! You guessed it! "+ myNumber +nl
  else
    See "Try again"+ nl
  ok

  if answer = 0
    See "Give up. My number is: "+ myNumber +nl
  ok
end
