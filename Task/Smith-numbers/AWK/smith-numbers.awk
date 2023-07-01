# syntax: GAWK -f SMITH_NUMBERS.AWK
# converted from C
BEGIN {
    limit = 10000
    printf("Smith Numbers < %d:\n",limit)
    for (a=4; a<limit; a++) {
      num_factors = num_prime_factors(a)
      if (num_factors < 2) {
        continue
      }
      prime_factors(a)
      if (sum_digits(a) == sum_factors(num_factors)) {
        printf("%4d ",a)
        if (++cr % 16 == 0) {
          printf("\n")
        }
      }
      delete arr
    }
    printf("\n")
    exit(0)
}
function num_prime_factors(x,  p,pf) {
    p = 2
    pf = 0
    if (x == 1) {
      return(1)
    }
    while (1) {
      if (!(x % p)) {
        pf++
        x = int(x/p)
        if (x == 1) {
          return(pf)
        }
      }
      else {
        p++
      }
    }
}
function prime_factors(x,  p,pf) {
    p = 2
    pf = 0
    if (x == 1) {
      arr[pf] = 1
    }
    else {
      while (1) {
        if (!(x % p)) {
          arr[pf++] = p
          x = int(x/p)
          if (x == 1) {
            return
          }
        }
        else {
          p++
        }
      }
    }
}
function sum_digits(x,  sum,y) {
    while (x) {
      y = x % 10
      sum += y
      x = int(x/10)
    }
    return(sum)
}
function sum_factors(x,  a,sum) {
    sum = 0
    for (a=0; a<x; a++) {
      sum += sum_digits(arr[a])
    }
    return(sum)
}
