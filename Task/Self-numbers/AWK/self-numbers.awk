# syntax: GAWK -f SELF_NUMBERS.AWK
# converted from Go (low memory example)
BEGIN {
    print("HH:MM:SS      INDEX       SELF")
    print("-------- ---------- ----------")
    count = 0
    digits = 1
    i = 1
    last_self = 0
    offset = 9
    pow = 10
    while (count < 1E8) {
      is_self = 1
      start = max(i-offset,0)
      sum = sum_digits(start)
      for (j=start; j<i; j++) {
        if (j + sum == i) {
          is_self = 0
          break
        }
        sum = ((j+1) % 10 != 0) ? ++sum : sum_digits(j+1)
      }
      if (is_self) {
        last_self = i
        if (++count <= 50) {
          selfs = selfs i " "
        }
      }
      if (++i % pow == 0) {
        pow *= 10
        digits++
        offset = digits * 9
      }
      if (count ~ /^10*$/ && arr[count]++ == 0) {
        printf("%8s %10s %10s\n",strftime("%H:%M:%S"),count,last_self)
      }
    }
    printf("\nfirst 50 self numbers:\n%s\n",selfs)
    exit(0)
}
function sum_digits(x,  sum,y) {
    while (x) {
      y = x % 10
      sum += y
      x = int(x/10)
    }
    return(sum)
}
function max(x,y) { return((x > y) ? x : y) }
