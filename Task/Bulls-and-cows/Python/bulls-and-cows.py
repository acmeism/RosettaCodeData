'''
 Bulls and cows. A game pre-dating, and similar to, Mastermind.
'''

from random import sample

digits = '123456789'
size = 4
chosen = ''.join(sample(digits, size))
print('''I have chosen a number from %s unique digits from 1 to 9 arranged in a random order.
You need to input a %i digit, unique digit number as a guess at what I have chosen (or type Q to quit).''' % (size, size))
guesses = 1
while True:
    guess = input('\nNext guess [%i]: ' % guesses).strip()
    if guess.lower() == "q":
         break
    # get a good guess
    if len(guess) != size or \
        any(char not in digits for char in guess) \
        or len(set(guess)) != size:
            print('Problem, try again. You need to enter %i unique digits from 1 to 9.' % size)
            continue
    if guess == chosen:
        print('\nCongratulations! You guessed correctly in', guesses, 'attempts.')
        break
    bulls, cows = 0, 0
    for i in range(size):
        if guess[i] == chosen[i]:
            bulls += 1
        elif guess[i] in chosen:
            cows += 1
    guesses += 1
    print('  %i Bulls\n  %i Cows' % (bulls, cows))

print('Thanks for playing!')
