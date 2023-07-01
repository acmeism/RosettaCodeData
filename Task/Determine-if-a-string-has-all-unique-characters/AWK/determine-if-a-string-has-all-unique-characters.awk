# syntax: GAWK -f DETERMINE_IF_A_STRING_HAS_ALL_UNIQUE_CHARACTERS.AWK
BEGIN {
    for (i=0; i<=255; i++) { ord_arr[sprintf("%c",i)] = i } # build array[character]=ordinal_value
    n = split(",.,abcABC,XYZ ZYX,1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ",arr,",")
    for (i in arr) {
      width = max(width,length(arr[i]))
    }
    width += 2
    fmt = "| %-*s | %-6s | %-10s | %-8s | %-3s | %-9s |\n"
    head1 = head2 = sprintf(fmt,width,"string","length","all unique","1st diff","hex","positions")
    gsub(/[^|\n]/,"-",head1)
    printf(head1 head2 head1) # column headings
    for (i=1; i<=n; i++) {
      main(arr[i])
    }
    printf(head1) # column footing
    exit(0)
}
function main(str,  c,hex,i,leng,msg,position1,position2,tmp_arr) {
    msg = "yes"
    leng = length(str)
    for (i=1; i<=leng; i++) {
      c = substr(str,i,1)
      if (c in tmp_arr) {
        msg = "no"
        first_diff = "'" c "'"
        hex = sprintf("%2X",ord_arr[c])
        position1 = index(str,c)
        position2 = i
        break
      }
      tmp_arr[c] = ""
    }
    printf(fmt,width,"'" str "'",leng,msg,first_diff,hex,position1 " " position2)
}
function max(x,y) { return((x > y) ? x : y) }
