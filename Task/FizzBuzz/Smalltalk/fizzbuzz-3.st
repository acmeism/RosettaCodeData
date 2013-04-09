fizzbuzz := Dictionary with: #(true true)->'FizzBuzz'
                       with: #(true false)->'Fizz'
                       with: #(false true)->'Buzz'.

1 to: 100 do:
	[ :i | Transcript show:
               (fizzbuzz at: {i isDivisibleBy: 3. i isDivisibleBy: 5}
		         ifAbsent: [ i ]); cr]
