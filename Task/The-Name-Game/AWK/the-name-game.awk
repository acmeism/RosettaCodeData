# syntax: GAWK -f THE_NAME_GAME.AWK
BEGIN {
    n = split("gary,earl,billy,felix,mary,shirley",arr,",")
    for (i=1; i<=n; i++) {
      print_verse(arr[i])
    }
    exit(0)
}
function print_verse(name,  c,x,y) {
    x = toupper(substr(name,1,1)) tolower(substr(name,2))
    y = (x ~ /^[AEIOU]/) ? tolower(x) : substr(x,2)
    c = substr(x,1,1)
    printf("%s, %s, bo-%s%s\n",x,x,(c~/B/)?"":"b",y)
    printf("Banana-fana fo-%s%s\n",(c~/F/)?"":"f",y)
    printf("Fee-fi-mo-%s%s\n",(c~/M/)?"":"m",y)
    printf("%s!\n\n",x)
}
