import random

ESC = "\033"
TEST = True  # Set to False to erase each player's coins

def get_number(prompt, min_val, max_val, show_min_max):
    """Prompts the user for a number within a specified range."""
    while True:
        print(prompt, end="")
        if show_min_max:
            print(f" from {min_val} to {max_val} : ", end="")
        else:
            print(" : ", end="")
        try:
            input_str = input()
            input_num = int(input_str)
            if min_val <= input_num <= max_val:
                print()
                return input_num
            else:
                print(f"Please enter a number between {min_val} and {max_val}.")
        except ValueError:
            print("Invalid input. Please enter a number.")


def main():
    """Main function to run the game."""
    random.seed()

    players = get_number("Number of players", 2, 9, True)
    coins = get_number("Number of coins per player", 3, 6, True)

    remaining = list(range(1, players + 1))
    first = 1 + random.randint(0, players - 1)

    print("The number of coins in your hand will be randomly determined for")
    print("each round and displayed to you. However, when you press ENTER")
    print("it will be erased so that the other players, who should look")
    print("away until it's their turn, won't see it. When asked to guess")
    print("the total, the computer won't allow a 'bum guess'.")

    round_num = 1
    while True:
        print(f"\nROUND {round_num}:\n")
        round_num += 1

        n = first
        hands = [0] * (players + 1)
        guesses = [-1] * (players + 1)

        while True:
            print(f"  PLAYER {n}:\n")
            print("    Please come to the computer and press ENTER")
            input()
            hands[n] = random.randint(0, coins)
            print(f"      <There are {hands[n]} coin(s) in your hand>", end="")
            input()  # Simulate scanning from stdin

            if not TEST:
                print(f"{ESC}[1A", end="")  # move cursor up one line
                print(f"{ESC}[2K", end="")  # erase line
                print("\r", end="")  # move cursor to beginning of line
            else:
                print()

            while True:
                min_guess = hands[n]
                max_guess = (len(remaining) - 1) * coins + hands[n]
                guess = get_number("    Guess the total", min_guess, max_guess, False)

                if guess not in guesses:
                    guesses[n] = guess
                    break
                print("    Already guessed by another player, try again")

            index = remaining.index(n)
            if index < len(remaining) - 1:
                n = remaining[index + 1]
            else:
                n = remaining[0]

            if n == first:
                break

        total = sum(hands)
        print("  Total coins held =", total)

        eliminated = False
        for v in remaining:
            if guesses[v] == total:
                print("  PLAYER", v, "guessed correctly and is eliminated")
                remaining.remove(v)
                eliminated = True
                break

        if not eliminated:
            print("  No players guessed correctly in this round")
        elif len(remaining) == 1:
            print("\nPLAYER", remaining[0], "buys the drinks!")
            return

        index2 = remaining.index(n)
        if index2 < len(remaining) - 1:
            first = remaining[index2 + 1]
        else:
            first = remaining[0]

if __name__ == "__main__":
    main()
