min = 1
max = 100
see "think of a number between " + min + " and " + max + nl
see "i will try to guess your number." + nl
while true
      guess =floor((min + max) / 2)
      see "my guess is " + guess + nl
      see "is it higher than, lower than or equal to your number " give answer
      ans = left(answer,1)
      switch ans
             on "l" min = guess + 1
             on "h" max = guess - 1
             on "e" exit
             other see "sorry, i didn't understand your answer." + nl
      off
end
see "goodbye." + nl
