import random, re
chars = ["(",")","/","+","-","*"]
while True:
    charsandints, ints = [], []
    for x in range(4):
        ints.append(str(random.randrange(1,10)))
    charsandints = chars + ints
    print "Numbers are:", ints
    guess = raw_input("Enter your guess:")
    if guess.lower() == "q":
        break
    elif guess.lower() == "|":
        pass
    else:
        flag = True
        for a in guess:
            if a not in charsandints or guess.count(a) > charsandints.count(a):
                flag = False
        if re.search("\d\d", guess):
            print "You cannot combine digits."
            break
        if flag:
            print "Your result is: ", eval(guess)
            if eval(guess) == 24:
                print "You won"
                break
            else:
                print "You lost"
                break
        else:
            print "You cannot use anthing other than", charsandints
            break
print "Thanks for playing"
