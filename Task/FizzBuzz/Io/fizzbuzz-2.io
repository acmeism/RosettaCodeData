a := 0; b := 0
for(n, 1, 100,
    if(a = (n % 3) == 0, "Fizz" print);
    if(b = (n % 5) == 0, "Buzz" print);
    if(a not and b not, n print);
    "\n" print
)
