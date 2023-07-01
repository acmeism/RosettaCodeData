# syntax: GAWK -f PERNICIOUS_NUMBERS.AWK
BEGIN {
    pernicious(25)
    pernicious(888888877,888888888)
    exit(0)
}
function pernicious(x,y,  count,n) {
    if (y == "") { # print first X pernicious numbers
      while (count < x) {
        if (is_prime(pop_count(++n)) == 1) {
          printf("%d ",n)
          count++
        }
      }
    }
    else { # print pernicious numbers in X-Y range
      for (n=x; n<=y; n++) {
        if (is_prime(pop_count(n)) == 1) {
          printf("%d ",n)
        }
      }
    }
    print("")
}
function dec2bin(n,  str) {
    while (n) {
      if (n%2 == 0) {
        str = "0" str
      }
      else {
        str = "1" str
      }
      n = int(n/2)
    }
    if (str == "") {
      str = "0"
    }
    return(str)
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
function pop_count(n) {
    n = dec2bin(n)
    return gsub(/1/,"&",n)
}
