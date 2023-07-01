"""
    Run the Sleeping Beauty Problem experiment `repetitions` times, checking to see
    how often we had heads on waking Sleeping Beauty.
"""
function sleeping_beauty_experiment(repetitions)
    gotheadsonwaking = 0
    wakenings = 0
    for _ in 1:repetitions
        coin_result = rand(["heads", "tails"])

        # On Monday, we check if we got heads.
        wakenings += 1
        if coin_result == "heads"
            gotheadsonwaking += 1
        end

        # If tails, we do this again, but of course we will not add as if it was heads.
        if coin_result == "tails"
            wakenings += 1
            if coin_result == "heads"
                gotheadsonwaking += 1   # never done
            end
        end
    end

    # Show the number of times she was wakened.
    println("Wakenings over ", repetitions, " experiments: ", wakenings)

    # Return the number of correct bets SB made out of the total number
    # of times she is awoken over all the experiments with that bet.
    return gotheadsonwaking / wakenings
end

CREDENCE = sleeping_beauty_experiment(1_000_000)
println("Results of experiment:  Sleeping Beauty should estimate a credence of: ", CREDENCE)
