# syntax: GAWK -f MAD_LIBS.AWK
BEGIN {
    print("enter story:")
}
{   story_arr[++nr] = $0
    if ($0 ~ /^ *$/) {
      exit
    }
    while ($0 ~ /[<>]/) {
      L = index($0,"<")
      R = index($0,">")
      changes_arr[substr($0,L,R-L+1)] = ""
      sub(/</,"",$0)
      sub(/>/,"",$0)
    }
}
END {
    PROCINFO["sorted_in"] = "@ind_str_asc"
    print("enter values for:")
    for (i in changes_arr) { # prompt for replacement values
      printf("%s ",i)
      getline rec
      sub(/ +$/,"",rec)
      changes_arr[i] = rec
    }
    printf("\nrevised story:\n")
    for (i=1; i<=nr; i++) { # print the story
      for (j in changes_arr) {
        gsub(j,changes_arr[j],story_arr[i])
      }
      printf("%s\n",story_arr[i])
    }
    exit(0)
}
