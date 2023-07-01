# syntax: GAWK -f FOUR_IS_MAGIC.AWK
BEGIN {
    init_numtowords()
    n = split("-1 0 1 2 3 4 5 6 7 8 9 11 21 1995 1000000 1234567890 1100100100100",arr," ")
    for (i=1; i<=n; i++) {
      a = arr[i]
      printf("%s: ",a)
      do {
        if (a == 4) {
          break
        }
        a = numtowords(a)
        b = numtowords(length(a))
        printf("%s is %s, ",a,b)
        a = length(a)
      } while (b !~ /^four$/)
      printf("four is magic.\n")
    }
    exit(0)
}
# source: The AWK Programming Language, page 75
function numtowords(n,  minus,str) {
    if (n < 0) {
      n = n * -1
      minus = "minus "
    }
    if (n == 0) {
      str = "zero"
    }
    else {
      str = intowords(n)
    }
    gsub(/  /," ",str)
    gsub(/ $/,"",str)
    return(minus str)
}
function intowords(n) {
    n = int(n)
    if (n >= 1000000000000) {
      return intowords(n/1000000000000) " trillion " intowords(n%1000000000000)
    }
    if (n >= 1000000000) {
      return intowords(n/1000000000) " billion " intowords(n%1000000000)
    }
    if (n >= 1000000) {
      return intowords(n/1000000) " million " intowords(n%1000000)
    }
    if (n >= 1000) {
      return intowords(n/1000) " thousand " intowords(n%1000)
    }
    if (n >= 100) {
      return intowords(n/100) " hundred " intowords(n%100)
    }
    if (n >= 20) {
      return tens[int(n/10)] " " intowords(n%10)
    }
    return(nums[n])
}
function init_numtowords() {
    split("one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen",nums," ")
    split("ten twenty thirty forty fifty sixty seventy eighty ninety",tens," ")
}
