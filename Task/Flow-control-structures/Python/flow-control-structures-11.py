    i = 101
    for i in range(4): # loop 4 times
        print "I will always be seen."
        if i % 2 == 0:
            continue # continue goes back to the loop beginning for a new iteration.
        print "I'll only be seen every other time."
    else:
        print "Loop done"

    # Output:
    # I will always be seen.
    # I will always be seen.
    # I'll only be seen every other time.
    # I will always be seen.
    # I will always be seen.
    # I'll only be seen every other time.
    # Loop done

if(__name__ == "__main__"):
    main()
