import random
import sys

snl = {
    4: 14,
    9: 31,
    17: 7,
    20: 38,
    28: 84,
    40: 59,
    51: 67,
    54: 34,
    62: 19,
    63: 81,
    64: 60,
    71: 91,
    87: 24,
    93: 73,
    95: 75,
    99: 78
}
sixesRollAgain = True

def turn(player, square):
    while True:
        roll = random.randint(1,6)
        sys.stdout.write("Player {0} on square {1}, rolls a {2}".format(player, square, roll))
        if square + roll > 100:
            print " but cannot move."
        else:
            square += roll
            print " and moves to square {0}".format(square)
            if square == 100:
                return 100
            next = snl.get(square, square)
            if square < next:
                print "Yay! landed on a ladder. Climb up to {0}.".format(next)
                if square == 100:
                    return 100
                square = next
            elif square > next:
                print "Oops! Landed on a snake. Slither down to {0}.".format(next)
                square = next
        if roll < 6 or not sixesRollAgain:
            return square
        print "Rolled a 6 so roll again."

def main():
    players = [1, 1, 1]
    while True:
        for i in range(0, 3):
            ns = turn(i+1, players[i])
            if ns == 100:
                print "Player {0} wins!".format(i+1)
                return
            players[i] = ns;
            print

main()
