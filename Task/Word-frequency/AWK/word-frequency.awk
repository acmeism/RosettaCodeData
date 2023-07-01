# syntax: GAWK -f WORD_FREQUENCY.AWK [-v show=x] LES_MISERABLES.TXT
#
# A word is anything separated by white space.
# Therefor "this" and "this." are different.
# But "This" and "this" are identical.
# As I am "free to define what a letter is" I have chosen to allow
# numerics and all special characters as they are usually considered
# parts of words in text processing applications.
#
{   nbytes += length($0) + 2 # +2 for CR/LF
    nfields += NF
    $0 = tolower($0)
    for (i=1; i<=NF; i++) {
      arr[$i]++
    }
}
END {
    show = (show == "") ? 10 : show
    width1 = length(show)
    PROCINFO["sorted_in"] = "@val_num_desc"
    for (i in arr) {
      if (width2 == 0) { width2 = length(arr[i]) }
      if (n++ >= show) { break }
      printf("%*d %*d %s\n",width1,n,width2,arr[i],i)
    }
    printf("input: %d records, %d bytes, %d words of which %d are unique\n",NR,nbytes,nfields,length(arr))
    exit(0)
}
