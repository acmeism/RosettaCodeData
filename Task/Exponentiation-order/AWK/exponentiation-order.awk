# syntax: GAWK -f EXPONENTIATION_ORDER.AWK
BEGIN {
    printf("5^3^2   = %d\n",5^3^2)
    printf("(5^3)^2 = %d\n",(5^3)^2)
    printf("5^(3^2) = %d\n",5^(3^2))
    exit(0)
}
