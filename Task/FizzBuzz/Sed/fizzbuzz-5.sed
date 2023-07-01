sed -nz '0~3s/^/Fizz/;0~5s/$/Buzz/;tx;=;b;:x;p;100q' /dev/zero | sed 'y/\c@/\n/'
