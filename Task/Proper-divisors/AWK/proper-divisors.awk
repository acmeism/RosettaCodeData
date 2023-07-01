# syntax: GAWK -f PROPER_DIVISORS.AWK
BEGIN {
    show = 0 # show divisors: 0=no, 1=yes
    print("    N  cnt  DIVISORS")
    for (i=1; i<=20000; i++) {
      divisors(i)
      if (i <= 10 || i == 100) { # including 100 as it was an example in task description
        printf("%5d  %3d  %s\n",i,Dcnt,Dstr)
      }
      if (Dcnt < max_cnt) {
        continue
      }
      if (Dcnt > max_cnt) {
        rec = ""
        max_cnt = Dcnt
      }
      rec = sprintf("%s%5d  %3d  %s\n",rec,i,Dcnt,show?Dstr:"divisors not shown")
    }
    printf("%s",rec)
    exit(0)
}
function divisors(n,  i) {
    if (n == 1) {
      Dcnt = 0
      Dstr = ""
      return
    }
    Dcnt = Dstr = 1
    for (i=2; i<n; i++) {
      if (n % i == 0) {
        Dcnt++
        Dstr = sprintf("%s %s",Dstr,i)
      }
    }
    return
}
