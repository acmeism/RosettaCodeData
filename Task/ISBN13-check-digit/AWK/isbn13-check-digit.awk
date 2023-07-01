# syntax: GAWK -f ISBN13_CHECK_DIGIT.AWK
BEGIN {
    arr[++n] = "978-1734314502"
    arr[++n] = "978-1734314509"
    arr[++n] = "978-1788399081"
    arr[++n] = "978-1788399083"
    arr[++n] = "9780820424521"
    arr[++n] = "0820424528"
    for (i=1; i<=n; i++) {
      printf("%s %s\n",arr[i],isbn13(arr[i]))
    }
    exit(0)
}
function isbn13(isbn,  check_digit,i,sum) {
    gsub(/[ -]/,"",isbn)
    if (length(isbn) != 13) { return("NG length") }
    for (i=1; i<=12; i++) {
      sum += substr(isbn,i,1) * (i % 2 == 1 ? 1 : 3)
    }
    check_digit = 10 - (sum % 10)
    return(substr(isbn,13,1) == check_digit ? "OK" : sprintf("NG check digit S/B %d",check_digit))
}
