(for N 100
   (prinl
      (or (pack (at (0 . 3) "Fizz") (at (0 . 5) "Buzz")) N) ) )

# Above, we simply count till 100 'prin'-ting number 'at' 3rd ('Fizz'), 5th ('Buzz') and 'pack'-ing 15th number ('FizzBuzz').
# Rest of the times 'N' is printed as it loops in 'for'.
