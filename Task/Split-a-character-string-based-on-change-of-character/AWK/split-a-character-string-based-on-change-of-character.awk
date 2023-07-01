# syntax: GAWK -f SPLIT_A_CHARACTER_STRING_BASED_ON_CHANGE_OF_CHARACTER.AWK
BEGIN {
    str = "gHHH5YY++///\\"
    printf("old: %s\n",str)
    printf("new: %s\n",split_on_change(str))
    exit(0)
}
function split_on_change(str,  c,i,new_str) {
    new_str = substr(str,1,1)
    for (i=2; i<=length(str); i++) {
      c = substr(str,i,1)
      if (substr(str,i-1,1) != c) {
        new_str = new_str ", "
      }
      new_str = new_str c
    }
    return(new_str)
}
