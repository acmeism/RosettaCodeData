# syntax: GAWK -M -f CURRENCY2.AWK
# using GNU Awk 4.1.1, API: 1.1 (GNU MPFR 3.1.2, GNU MP 5.1.2)
# INT is used to define values and do math; results then converted to FLOAT
BEGIN {
    PREC = 100
    hamburger_p = 550
    hamburger_q = 4000000000000000
    hamburger_v = hamburger_p * hamburger_q
    milkshake_p = 286
    milkshake_q = 2
    milkshake_v = milkshake_p * milkshake_q
    subtotal = hamburger_v + milkshake_v
    tax = subtotal * 765
    subtotal /= 100
    tax /= 1000000
    printf("%-9s %8s %18s %22s\n","item","price","quantity","value")
    printf("hamburger %8.2f %18d %22.2f\n",hamburger_p/100,hamburger_q,hamburger_v/100)
    printf("milkshake %8.2f %18d %22.2f\n\n",milkshake_p/100,milkshake_q,milkshake_v/100)
    printf("%37s %22.2f\n","subtotal",subtotal)
    printf("%37s %22.2f\n","tax",tax)
    printf("%37s %22.2f\n","total",subtotal+tax)
    exit(0)
}
