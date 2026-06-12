# syntax: GAWK -f PRIME_WORDS.AWK unixdict.txt
BEGIN {
    for (i=0; i<=255; i++) {
      if (is_prime(i)) {
        prime_chars = sprintf("%s%c",prime_chars,i)
      }
    }
    pattern = sprintf("^[%s]+$",prime_chars)
}
{   if ($0 ~ pattern) {
      printf("%s ",$0)
    }
}
END {
    printf("\n")
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
