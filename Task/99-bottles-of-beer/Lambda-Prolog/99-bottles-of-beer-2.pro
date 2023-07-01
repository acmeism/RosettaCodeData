module bottles.

println Str :- print Str, print "\n".

round N :- M is N - 1,
           NStr is int_to_string N,
           MStr is int_to_string M,
           BOB = " bottles of beer ",
           Line1 is NStr ^ BOB ^ "on the wall",
           Line2 is NStr ^ BOB,
           Line3 is "take one down, pass it around",
           Line4 is MStr ^ BOB ^ "on the wall",
           println Line1,
           println Line2,
           println Line3,
           println Line4.

bottles_song 0.
bottles_song N :- N > 0,
                  round N,
                  M is N - 1,
                  bottles_song M.
