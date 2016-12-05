multi sub fizzbuzz(Int $ where * %% 15) { 'FizzBuzz' }
multi sub fizzbuzz(Int $ where * %%  5) { 'Buzz' }
multi sub fizzbuzz(Int $ where * %%  3) { 'Fizz' }
multi sub fizzbuzz(Int $number        ) { $number }
(1 .. 100)».&fizzbuzz.say;
