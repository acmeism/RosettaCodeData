main: { [2 3 5 7 11 13] sp }

sum!    : { <- 0 -> { + } eachar }
product!: { <- 1 -> { * } eachar }

sp!:
    { dup
    sum %d cr <<
    product %d cr << }

Result:
41
30030
