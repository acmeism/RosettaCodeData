# syntax: GAWK -M -f CURRENCY.AWK
# using GNU Awk 4.1.1, API: 1.1 (GNU MPFR 3.1.2, GNU MP 5.1.2)
BEGIN {
    PREC = 100
    hamburger_p = 5.50
    hamburger_q = 4000000000000000
    hamburger_v = hamburger_p * hamburger_q
    milkshake_p = 2.86
    milkshake_q = 2
    milkshake_v = milkshake_p * milkshake_q
    subtotal = hamburger_v + milkshake_v
    tax = subtotal * .0765
    printf("%-9s %8s %18s %22s\n","item","price","quantity","value")
    printf("hamburger %8.2f %18d %22.2f\n",hamburger_p,hamburger_q,hamburger_v)
    printf("milkshake %8.2f %18d %22.2f\n\n",milkshake_p,milkshake_q,milkshake_v)
    printf("%37s %22.2f\n","subtotal",subtotal)
    printf("%37s %22.2f\n","tax",tax)
    printf("%37s %22.2f\n","total",subtotal+tax)
    exit(0)
}
