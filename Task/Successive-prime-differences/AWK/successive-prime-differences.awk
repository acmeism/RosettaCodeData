# syntax: GAWK -f SUCCESSIVE_PRIME_DIFFERENCES.AWK
BEGIN {
    for (i=lo=0; i<=hi=1000000; i++) {
      if (is_prime(i)) {
        p_arr[++p] = i
      }
    }
    printf("there are %d primes between %d - %d\n",p,lo,hi)
    fmt = "%-11s %5s %-15s %s\n"
    printf(fmt,"differences","count","first group","last group")
    for (a=1; a<=split("2;1;2,2;2,4;4,2;6,4,2;2,4,6;100;112",diff_arr,";"); a++) {
      diff_leng = split(diff_arr[a],tmp_arr,",")
      first_set = last_set = ""
      count = 0
      for (b=1; b<=p; b++) {
        str = ""
        for (c=1; c<=diff_leng; c++) {
          if (p_arr[b+c-1] + tmp_arr[c] == p_arr[b+c]) {
            str = (str == "") ? (p_arr[b+c-1] "," p_arr[b+c]) : (str "," p_arr[b+c])
          }
        }
        if (gsub(/,/,"&",str) == diff_leng) {
          count++
          if (first_set == "") {
            first_set = str
          }
          last_set = str
        }
      }
      printf(fmt,diff_arr[a],count,first_set,last_set)
    }
    exit(0)
}
function is_prime(x,  i) {
    if (x <= 1) {
      return(0)
    }
    for (i=2; i<=int(sqrt(x)); i++) {
      if (x % i == 0) {
        return(0)
      }
    }
    return(1)
}
