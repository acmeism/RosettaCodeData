use feature "say";

@a = ("FizzBuzz", 0, 0, "Fizz", 0, "Buzz", "Fizz", 0, 0, "Fizz", "Buzz", 0, "Fizz");

say $a[$_ % 15] || $_ for 1..100;
