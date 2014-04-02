seq 1 100 | sed -r '3~3 s/[0-9]*/Fizz/; 5~5 s/[0-9]*$/Buzz/'
