1.upto(100) { i -> println "${i % 3 ? '' : 'Fizz'}${i % 5 ? '' : 'Buzz'}" ?: i }
