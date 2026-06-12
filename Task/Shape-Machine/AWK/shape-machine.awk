# syntax: GAWK -f SHAPE-MACHINE.AWK
# converted from FreeBASIC
BEGIN {
    initial = prev = 4
    for (;;) {
      sgte = (prev + 3) * 0.86
      if (prev == sgte) {
        break
      }
      printf("%3d %18.15f\n",++count,sgte)
      prev = sgte
    }
    printf("Took %d iterations using initial value of %d\n",count,initial)
    exit(0)
}
