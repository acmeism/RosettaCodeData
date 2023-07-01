# JUMBLEA.AWK - words with the most duplicate spellings
# syntax: GAWK -f JUMBLEA.AWK UNIXDICT.TXT
{   for (i=1; i<=NF; i++) {
      w = sortstr(toupper($i))
      arr[w] = arr[w] $i " "
      n = gsub(/ /,"&",arr[w])
      if (max_n < n) { max_n = n }
    }
}
END {
    for (w in arr) {
      if (gsub(/ /,"&",arr[w]) == max_n) {
        printf("%s\t%s\n",w,arr[w])
      }
    }
    exit(0)
}
function sortstr(str,  i,j,leng) {
    leng = length(str)
    for (i=2; i<=leng; i++) {
      for (j=i; j>1 && substr(str,j-1,1) > substr(str,j,1); j--) {
        str = substr(str,1,j-2) substr(str,j,1) substr(str,j-1,1) substr(str,j+1)
      }
    }
    return(str)
}
