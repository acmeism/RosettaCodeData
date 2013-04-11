main: (
    INT a, b;
    INT seed := 4; # chosen by a fair dice roll, guaranteed to be random c.f. http://xkcd.com/221/ #
    # first random; #
    WHILE
        a := ENTIER (next random(seed) * 20);
        print((a));
  # WHILE # NOT (a = 10) DO
        b := ENTIER (next random(seed) * 20);
        print((b, new line))
    OD;
    print(new line)
)
