main:
(
    INT n;
    INT g;
    n := ENTIER (random*10+1);
    PROC puts = (STRING string)VOID: putf(standout, ($gl$,string));
    puts("I'm thinking of a number between 1 and 10.");
    puts("Try to guess it! ");
    DO
        readf(($g$, g));
        IF g = n THEN break
        ELSE
          puts("That's not my number. ");
          puts("Try another guess!")
        FI
    OD;
    break:
    puts("You have won! ")
)
