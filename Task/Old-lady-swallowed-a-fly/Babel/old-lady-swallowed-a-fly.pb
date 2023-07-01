((main {fly !})

(fly
    {{"There was an old lady who swallowed a " <<
        iter 1 - dup
        <- 0 animal ! nl << ->
           1 animal !    <<
        {iter 10 ~=}{
            " " <<
            {iter 1 =}{last}{fnord} ifte
            iter 1 - 0 animal ! nl <<
                {"She swallowed the " <<
                this_iter ! 0 animal ! <<
                " to catch the " <<
                next_iter ! 0 animal ! nl <<
                {iter 2 =}
                    {8 1 animal ! nl <<}
                    {fnord}
                ifte}
            11 iter - 1 -
            times}
            {fnord}
        ifte
        "But I don't know why she swallowed the fly\nPerhaps she'll die\n\n" <<}
    animals len
    times})

(next_iter {10 iter - })
(this_iter {next_iter ! 1 -})

(animal { <- <- animals -> ith -> ith})

-- There are 10 animals
(animals
   (("horse"    "She's dead of course...\n")
    ("donkey"   "It was rather wonkey! To swallow a")
    ("cow"      "I don't know how she swallowed a")
    ("goat"     "She just opened her throat! And swallowed the")
    ("pig"      "Her mouth was so big, to swallow a")
    ("dog"      "What a hog! To swallow a")
    ("cat"      "Fancy that! She swallowed a")
    ("bird"     "Quite absurd to swallow a")
    ("spider"   "That wriggled and jiggled and tickled inside her")
    ("fly"      " "))))
