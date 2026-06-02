from random import randrange
from re import search

chars = ["(", ")", "/", "+", "-", "*"]
while True:
    charsandints, ints = [], []
    for _ in range(4):
        ints.append(str(randrange(1, 10)))
    charsandints = chars + ints
    print("Numbers are:", ints)
    guess = input("Enter your guess:")
    if guess.lower() == "q":
        break
    elif guess.lower() == "|":
        continue
    else:
        flag = True
        for a in guess:
            if a not in charsandints or guess.count(a) > charsandints.count(a):
                flag = False
                break
        if search("\\d\\d", guess):
            print("You cannot combine digits.")
        if flag:
            result = eval(guess)
            print("Your result is: ", result)
            print("You won!" if result == 24 else "You lost.")
        else:
            print("You cannot use anything other than", charsandints)
    break

print("Thanks for playing!")
