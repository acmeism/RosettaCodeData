# syntax: GAWK -f CHRONOLOGICAL_ORDER.AWK CHRONOLOGICAL_ORDER_TABLE*.TXT
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    PROCINFO["sorted_in"] = "@ind_num_asc" ; SORTTYPE = 1
}
BEGINFILE {
    printf("\n%s unsorted\n",FILENAME)
    delete arr
}
{   printf("%s\n",$0)
    if ($NF == "BCE") {
      arr["-" $(NF-1)] = $0
    }
    else if ($NF == "CE") {
      arr[$(NF-1)] = $0
    }
    else {
      error("above card is missing BCE or CE")
    }
}
ENDFILE {
    printf("\n%s sorted %d records\n",FILENAME,FNR)
    for (i in arr) {
      printf("%s\n",arr[i])
    }
}
END {
    exit(errors == 0 ? 0 : 1)
}
function error(message) { printf("error: %s\n",message) ; errors++ }
