    # create constants for the ASCII control characters (0-127)        #
    INT  char value := -1;
    # increments and returns the next value for a character            #
    PROC next char = CHAR: REPR ( char value +:= 1 );
    CHAR nul = next char;
    CHAR soh = next char;
    CHAR stx = next char;
    CHAR etx = next char;
    CHAR eot = next char;
    CHAR enq = next char;
    CHAR ack = next char;
    CHAR bel = next char;
    CHAR bs  = next char;
    CHAR ht  = next char;
    CHAR lf  = next char;
    CHAR vt  = next char;
    CHAR ff  = next char;
    CHAR cr  = next char;
    CHAR so  = next char;
    CHAR si  = next char;
    CHAR dle = next char;
    CHAR dc1 = next char;
    CHAR dc2 = next char;
    CHAR dc3 = next char;
    CHAR dc4 = next char;
    CHAR nak = next char;
    CHAR syn = next char;
    CHAR etb = next char;
    CHAR can = next char;
    CHAR em  = next char;
    CHAR sub = next char;
    CHAR esc = next char;
    CHAR fs  = next char;
    CHAR gs  = next char;
    CHAR rs  = next char;
    CHAR us  = next char;
    CHAR spc = " ";     # using spc as space is a standard transput procedure #
    CHAR del = REPR 127;

# e.g.:                                                                       #
# print( ( nul, soh, ht, lf ) );              prints the characters themselve #
# print( ( ABS nul, ABS soh, ABS ht, ABS lf, lf ) ); prints the characters as #
#                      integers:          +0         +1         +9        +10 #
