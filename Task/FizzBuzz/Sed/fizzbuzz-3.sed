seq 100 | sed '0~3 s/.*/Fizz/; 0~5 s/[0-9]*$/Buzz/'
