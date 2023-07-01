from random import randint

hands = ['rock', 'scissors', 'paper']; judge = ['its a tie!', 'the computer beat you... :(', 'yay you win!']
while True:
    try:
        YOU = hands.index(input('Choose your weapon: ')) # YOU = hands.index(raw_input('Choose your weapon: '))   If you use Python2.7
    except ValueError:
        break
    NPC = randint(0, 2)
    print('The computer played ' + hands[NPC] + '; ' + judge[YOU-NPC])
