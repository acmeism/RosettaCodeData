# syntax: GAWK -f SUM_AND_PRODUCT_PUZZLE.AWK
BEGIN {
    for (s=2; s<=100; s++) {
      if ((a=satisfies_statement3(s)) != 0) {
        printf("%d (%d+%d)\n",s,a,s-a)
      }
    }
    exit(0)
}
function satisfies_statement1(s,  a) { # S says: P does not know the two numbers.
# Given s, for all pairs (a,b), a+b=s, 2 <= a,b <= 99, true if at least one of a or b is composite
    for (a=2; a<=int(s/2); a++) {
      if (is_prime(a) && is_prime(s-a)) {
        return(0)
      }
    }
    return(1)
}
function satisfies_statement2(p,  i,j,winner) { # P says: Now I know the two numbers.
# Given p, for all pairs (a,b), a*b=p, 2 <= a,b <= 99, true if exactly one pair satisfies statement 1
    for (i=2; i<=int(sqrt(p)); i++) {
      if (p % i == 0) {
        j = int(p/i)
        if (!(2 <= j && j <= 99)) { # in range
          continue
        }
        if (satisfies_statement1(i+j)) {
          if (winner) {
            return(0)
          }
          winner = 1
        }
      }
    }
    return(winner)
}
function satisfies_statement3(s,  a,b,winner) { # S says: Now I know the two numbers.
# Given s, for all pairs (a,b), a+b=s, 2 <= a,b <= 99, true if exactly one pair satisfies statements 1 and 2
    if (!satisfies_statement1(s)) {
      return(0)
    }
    for (a=2; a<=int(s/2); a++) {
      b = s - a
      if (satisfies_statement2(a*b)) {
        if (winner) {
          return(0)
        }
        winner = a
      }
    }
    return(winner)
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
