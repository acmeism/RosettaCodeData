seq = *0..100
{Fizz:3, Buzz:5, FizzBuzz:15}.each{|k,n| n.step(100,n){|i|seq[i]=k}}
puts seq.drop(1)
