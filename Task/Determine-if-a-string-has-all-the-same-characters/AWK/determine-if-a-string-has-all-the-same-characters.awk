# syntax: GAWK -f DETERMINE_IF_A_STRING_HAS_ALL_THE_SAME_CHARACTERS.AWK
BEGIN {
    for (i=0; i<=255; i++) { ord_arr[sprintf("%c",i)] = i } # build array[character]=ordinal_value
    n = split(",   ,2,333,.55,tttTTT,4444 444k",arr,",")
    for (i in arr) {
      width = max(width,length(arr[i]))
    }
    width += 2
    fmt = "| %-*s | %-6s | %-8s | %-8s | %-3s | %-8s |\n"
    head1 = head2 = sprintf(fmt,width,"string","length","all same","1st diff","hex","position")
    gsub(/[^|\n]/,"-",head1)
    printf(head1 head2 head1) # column headings
    for (i=1; i<=n; i++) {
      main(arr[i])
    }
    printf(head1) # column footing
    exit(0)
}
function main(str,  c,first_diff,hex,i,leng,msg,position) {
    msg = "yes"
    leng = length(str)
    for (i=1; i<leng; i++) {
      c = substr(str,i+1,1)
      if (substr(str,i,1) != c) {
        msg = "no"
        first_diff = "'" c "'"
        hex = sprintf("%2X",ord_arr[c])
        position = i + 1
        break
      }
    }
    printf(fmt,width,"'" str "'",leng,msg,first_diff,hex,position)
}
function max(x,y) { return((x > y) ? x : y) }
