# syntax: GAWK -f ABC_INCREMENTAL_COUNTS.AWK unixdict.txt words_alpha.txt
BEGIN {
    if (ARGC-1 == 0) {
      error("incorrect number of arguments")
      exit # go to END
    }
}
{   for (i=1; i<=NF; i++) {
      arr[tolower($i)] = ""
    }
}
ENDFILE {
    printf("\n%s has %d records\n",FILENAME,FNR)
    if (toupper(FILENAME) ~ /UNIXDICT/) {
      main(1,"abc")
      main(1,"the")
      main(2,"cio")
    }
    if (toupper(FILENAME) ~ /WORDS_ALPHA/) {
      main(2,"abc")
      main(2,"the")
      main(3,"cio")
    }
    delete arr
}
END {
    exit(errors == 0 ? 0 : 1)
}
function main(count,letters,  arr2,c,i,n,nwords,word,x) {
    printf("\nminimum count/letters: %d,%s\n",count,letters)
    if (length(letters) != 3) {
      error("letters S/B 3")
    }
    PROCINFO["sorted_in"] = "@ind_str_asc"
    for (word in arr) {
      for (i=1; i<=length(letters); i++) {
        c = substr(letters,i,1)
        arr2[c] = gsub(c,"&",word)
      }
      PROCINFO["sorted_in"] = "@val_num_asc"
      x = ""
      for (i in arr2) {
        x = x arr2[i]
      }
      if ((n = substr(x,1,1)) >= count) {
        if (substr(x,2,1) == n + 1) {
          if (substr(x,3,1) == n + 2) {
            printf("%s\n",word)
            nwords++
          }
        }
      }
    }
    printf("%d words\n",nwords)
}
function error(message) { printf("error: %s\n",message) ; errors++ }
