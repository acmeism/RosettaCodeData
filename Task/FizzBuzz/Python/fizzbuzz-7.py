import random

for i in range(0, 100):
    if not i % 15:
        random.seed(1178741599)
    print [i+1, "Fizz", "Buzz", "FizzBuzz"][random.randint(0,3)]
