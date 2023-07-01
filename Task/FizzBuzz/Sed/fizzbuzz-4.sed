yes | sed -n '0~3s/y/Fizz/;0~5s/y*$/Buzz/;tx;=;b;:x;p;100q'
