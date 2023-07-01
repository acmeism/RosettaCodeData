from random import choice

def sleeping_beauty_experiment(repetitions):
    """
    Run the Sleeping Beauty Problem experiment `repetitions` times, checking to see
    how often we had heads on waking Sleeping Beauty.
    """
    gotheadsonwaking = 0
    wakenings = 0
    for _ in range(repetitions):
        coin_result = choice(["heads", "tails"])

        # On Monday, we check if we got heads.
        wakenings += 1
        if coin_result == "heads":
            gotheadsonwaking += 1

        # If tails, we do this again, but of course we will not add as if it was heads..
        if coin_result == "tails":
            wakenings += 1
            if coin_result == "heads":
                gotheadsonwaking += 1   # never done


    # Show the number of times she was wakened.
    print("Wakenings over", repetitions, "experiments:", wakenings)

    # Return the number of correct bets SB made out of the total number
    # of times she is awoken over all the experiments with that bet.
    return gotheadsonwaking / wakenings


CREDENCE = sleeping_beauty_experiment(1_000_000)
print("Results of experiment:  Sleeping Beauty should estimate a credence of:", CREDENCE)
