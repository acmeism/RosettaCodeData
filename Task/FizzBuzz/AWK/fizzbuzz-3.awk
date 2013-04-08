seq 100 | awk '$0=NR%15?NR%5?NR%3?$0:"Fizz":"Buzz":"FizzBuzz"'
