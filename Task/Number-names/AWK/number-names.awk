# syntax: GAWK -f NUMBER_NAMES.AWK
BEGIN {
    init_numtowords()
    n = split("-10 0 .1 8 100 123 1001 99999 100000 9123456789 111000000111",arr," ")
    for (i=1; i<=n; i++) {
      printf("%s = %s\n",arr[i],numtowords(arr[i]))
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
