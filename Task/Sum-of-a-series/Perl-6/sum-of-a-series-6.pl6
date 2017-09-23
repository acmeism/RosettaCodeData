constant @x = [\+] 0, { 1 / ++(state $n) ** 2 } ... *;
say @x[1000];  # prints 1.64393456668156
