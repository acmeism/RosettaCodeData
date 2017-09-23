seq 100 | sed '/.*[05]$/s//Buzz/;n;s//Buzz/;n;s//Buzz/;s/^[0-9]*/Fizz/'
