# syntax GAWK -f SORT_THE_LETTERS_OF_STRING_IN_ALPHABETICAL_ORDER.AWK
BEGIN {
    str = "Now is the time for all good men to come to the aid of their country."
    printf("old: %s\n",str)
    printf("new: %s\n",sortstr(str))
    exit(0)
}
function sortstr(str,  i,j) {
    for (i=2; i<=length(str); i++) {
      for (j=i; j>1 && substr(str,j-1,1) > substr(str,j,1); j--) {
#             < left          > < these are swapped             > < right       >
        str = substr(str,1,j-2) substr(str,j,1) substr(str,j-1,1) substr(str,j+1)
      }
    }
    return(str)
}
