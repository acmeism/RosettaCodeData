import os
import time

ROCKET = r"""
     /\
    /  \
    |  |
    |  |
   /|/\|\
  /_||||_\
"""

SMOKE = "     **"

def main():
    t = 4
    sky = 10
    countdown = True
    wait = 1

    while True:
        os.system('clear')
        print("\033[0;0H") # Move console cursor to (0, 0)

        print(f'T minus in:', end=' ')

        for i in range(5, t, -1):
            print(i, end=' ')

        print()

        if countdown:
            t -= 1

            if t == 0:
                countdown = False
        else:
            print('Lift off!', end=' ')

            for _ in range(sky):
                print()

            print(ROCKET, end='')

            for _ in range(10 - sky):
                print(SMOKE)

            sky -= 1
            wait -= 0.1

            if sky == -1:
                break

        time.sleep(wait)

if __name__ == '__main__':
    main()
