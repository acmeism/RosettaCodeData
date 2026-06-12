gcc -o csine csine.c -lm
./csine 440 5 | play -    # Now either pipe output into SoX to play
./csine 440 5 > test.au   # or redirect output to a file.
