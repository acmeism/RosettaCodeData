# syntax: GAWK -f CYCLOPS_NUMBERS.AWK
BEGIN {
    n = 0
    limit = 50
    while (A134808_cnt < limit || A134809_cnt < limit || A329737_cnt < limit || A136098_cnt < limit) {
      leng = length(n)
      if (leng ~ /[13579]$/) {
        middle_col = int(leng/2)+1
        if (substr(n,middle_col,1) == 0 && gsub(/0/,"&",n) == 1) {
          A134808_arr[++A134808_cnt] = n
          if (is_prime(n)) {
            A134809_arr[++A134809_cnt] = n
            tmp = n
            sub(/0/,"",tmp)
            if (is_prime(tmp)) {
              A329737_arr[++A329737_cnt] = n
            }
            if (reverse(n) == n) {
              A136098_arr[++A136098_cnt] = n
            }
          }
        }
      }
      n++
    }
    printf("Range: 0-%d\n\n",n-1)
    show_array(A134808_arr,A134808_cnt,"A134808: Cyclops numbers")
    show_array(A134809_arr,A134809_cnt,"A134809: Cyclops primes")
    show_array(A329737_arr,A329737_cnt,"A329737: Cyclops primes that remain prime after being 'blinded'")
    show_array(A136098_arr,A136098_cnt,"A136098: Prime palindromic cyclops numbers")
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
function reverse(str,  i,rts) {
    for (i=length(str); i>=1; i--) {
      rts = rts substr(str,i,1)
    }
    return(rts)
}
function show_array(arr,cnt,desc,  count,i) {
    printf("%s  Found %d numbers within range\n",desc,cnt)
    for (i=1; i<=limit; i++) {
      printf("%7d%1s",arr[i],++count%10?"":"\n")
    }
    printf("\n")
}
