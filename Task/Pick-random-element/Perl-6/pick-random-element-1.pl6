(1..6).roll;    # return 1 random value in the range 1 through 6
(1..6).roll(3); # return a list of 3 random values in the range 1 through 6
(1..6).roll(*); # return a lazy infinite list of random values in the range 1 through 6
