import random
t,g=random.randint(1,10),0
g=int(input("Guess a number that's between 1 and 10: "))
while t!=g:g=int(input("Guess again! "))
print("That's right!")
