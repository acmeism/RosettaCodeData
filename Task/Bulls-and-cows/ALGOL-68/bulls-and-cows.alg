STRING digits = "123456789";

[4]CHAR chosen;
STRING available := digits;
FOR i TO UPB chosen DO
    INT c = ENTIER(random*UPB available)+1;
    chosen[i] := available[c];
    available := available[:c-1]+available[c+1:]
OD;

COMMENT print((chosen, new line)); # Debug # END COMMENT

OP D = (INT d)STRING: whole(d,0); # for formatting an integer #

print (("I have chosen a number from ",D UPB chosen," unique digits from 1 to 9 arranged in a random order.", new line,
"You need to input a ",D UPB chosen," digit, unique digit number as a guess at what I have chosen", new line));

PRIO WITHIN = 5, NOTWITHIN = 5;
OP WITHIN = (CHAR c, []CHAR s)BOOL: char in string(c,LOC INT,s);
OP NOTWITHIN = (CHAR c, []CHAR s)BOOL: NOT ( c WITHIN s );

INT guesses := 0, bulls, cows;
WHILE
    STRING guess;
    guesses +:= 1;
    WHILE
        # get a good guess #
        print((new line,"Next guess [",D guesses,"]: "));
        read((guess, new line));
        IF UPB guess NE UPB chosen THEN
            FALSE
        ELSE
            BOOL ok;
            FOR i TO UPB guess WHILE
                ok := guess[i] WITHIN digits AND guess[i] NOTWITHIN guess[i+1:]
            DO SKIP OD;
            NOT ok
        FI
    DO
        print(("Problem, try again. You need to enter ",D UPB chosen," unique digits from 1 to 9", new line))
    OD;
# WHILE #
    guess NE chosen
DO
    bulls := cows := 0;
    FOR i TO UPB chosen DO
        IF guess[i] = chosen[i] THEN
            bulls +:= 1
        ELIF guess[i] WITHIN chosen THEN
            cows +:= 1
        FI
    OD;
    print(("  ",D bulls," Bulls",new line,"  ",D cows," Cows"))
OD;
print((new line, "Congratulations you guessed correctly in ",D guesses," attempts.",new line))
