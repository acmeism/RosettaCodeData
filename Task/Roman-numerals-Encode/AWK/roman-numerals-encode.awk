# syntax: GAWK -f ROMAN_NUMERALS_ENCODE.AWK
BEGIN {
    leng = split("1990 2008 1666",arr," ")
    for (i=1; i<=leng; i++) {
      n = arr[i]
      printf("%s = %s\n",n,dec2roman(n))
    }
    exit(0)
}
function dec2roman(number,  v,w,x,y,roman1,roman10,roman100,roman1000) {
    number = int(number) # force to integer
    if (number < 1 || number > 3999) { # number is too small | big
      return
    }
    split("I II III IV V VI VII VIII IX",roman1," ")   # 1 2 ... 9
    split("X XX XXX XL L LX LXX LXXX XC",roman10," ")  # 10 20 ... 90
    split("C CC CCC CD D DC DCC DCCC CM",roman100," ") # 100 200 ... 900
    split("M MM MMM",roman1000," ")                    # 1000 2000 3000
    v = (number - (number % 1000)) / 1000
    number = number % 1000
    w = (number - (number % 100)) / 100
    number = number % 100
    x = (number - (number % 10)) / 10
    y = number % 10
    return(roman1000[v] roman100[w] roman10[x] roman1[y])
}
