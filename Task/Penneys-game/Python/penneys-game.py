from __future__ import print_function
import random
from time import sleep

first = random.choice([True, False])

you = ''
if first:
    me = ''.join(random.sample('HT'*3, 3))
    print('I choose first and will win on first seeing {} in the list of tosses'.format(me))
    while len(you) != 3 or any(ch not in 'HT' for ch in you) or you == me:
        you = input('What sequence of three Heads/Tails will you win with: ')
else:
    while len(you) != 3 or any(ch not in 'HT' for ch in you):
        you = input('After you: What sequence of three Heads/Tails will you win with: ')
    me = ('H' if you[1] == 'T' else 'T') + you[:2]
    print('I win on first seeing {} in the list of tosses'.format(me))

print('Rolling:\n  ', end='')
rolled = ''
while True:
    rolled += random.choice('HT')
    print(rolled[-1], end='')
    if rolled.endswith(you):
        print('\n  You win!')
        break
    if rolled.endswith(me):
        print('\n  I win!')
        break
    sleep(1)    # For dramatic effect
