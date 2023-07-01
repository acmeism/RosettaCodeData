def fizzBuzz = { i -> [[3,'Fizz'],[5,'Buzz'],[7,'Baxx']].collect{i%it[0]?'':it[1]}.join()?:i}
1.upto(100){println fizzBuzz(it)}
