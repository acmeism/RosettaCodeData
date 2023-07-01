x <- 1:100
ifelse(x %% 15 == 0, 'FizzBuzz',
       ifelse(x %% 5 == 0, 'Buzz',
              ifelse(x %% 3 == 0, 'Fizz', x)))
