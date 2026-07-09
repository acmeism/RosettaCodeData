# syntax: GAWK -f VILE_AND_DOPEY_NUMBERS.AWK
# converted from EasyLang
BEGIN {
    limit = 25
    show(0,"Vile")
    show(1,"Dopey")
    upto = 2
    print("upto:  Vile Dopey")
    while (upto <= 1024) {
      i++
      h = is_dopey(i)
      ndopey += h
      nvile += 1 - h
      if (i == upto) {
        printf("%4d: %5d %5d\n",upto,nvile,ndopey)
        upto *= 2
      }
    }
    exit(0)
}
function is_dopey(n,  h) {
    while (n % 2 == 0) {
      h++
      n /= 2
    }
    return(h % 2)
}
function show(what,desc,  count,i) {
    printf("First %d %s numbers:\n",limit,desc)
    while (count < limit) {
      i++
      if (is_dopey(i) == what) {
        count++
        printf("%d ",i)
      }
    }
    printf("\n\n")
}
