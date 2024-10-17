using Formatting

function PL1example()

                                    # all variables are DECLARED as integers.
    prod  =  1;                     # start with a product of unity.
    sum   =  0;                     #   "     "  "   sum    " zero.
    x     = +5;
    y     = -5;
    z     = -2;
    one   =  1;
    three =  3;
    seven =  7;
                                    # (below)  **  is exponentiation:  4**3=64
    for j in [           -three   :  three :  3^3           ;
                         -seven   :   x    :  +seven        ;
                            555            :  550 - y       ;
                             22   : -three :  -28           ;
                           1927            :  1939          ;
                              x   :  z     :  y             ;
                           11^x            :   11^x + one   ]
                                                        # ABS(n) = absolute value
        sum = sum + abs(j);                             # add absolute value of J.
        if abs(prod) < 2^27 && j !=0 prod = prod*j      # PROD is small enough & J
        end;                                            # not 0, then multiply it.
    end             # SUM and PROD are used for verification of J incrementation.
    println(" sum = $(format(sum, commas=true))");      # display strings to term.
    println("prod = $(format(prod, commas=true))");     #   "       "     "   "
end

PL1example()
