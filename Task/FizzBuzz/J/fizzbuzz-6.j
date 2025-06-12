Fizz=: 'Fizz' #~ 0 = 3&|
Buzz=: 'Buzz' #~ 0 = 5&|
FizzBuzz=: ": [^:('' -: ]) Fizz,Buzz

FizzBuzz"0 >: i.100
