import random
target, guess = random.randint(1, 10), 0
guess = int(input("Guess a number that's between 1 and 10: "))
while target != guess:
    guess = int(input("Guess again! "))
print("That's right!")
