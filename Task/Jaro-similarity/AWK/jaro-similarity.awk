# syntax: GAWK -f JARO_DISTANCE.AWK
BEGIN {
    main("DWAYNE","DUANE")
    main("MARTHA","MARHTA")
    main("DIXON","DICKSONX")
    main("JELLYFISH","SMELLYFISH")
    exit(0)
}
function main(str1,str2) {
    printf("%9.7f '%s' '%s'\n",jaro(str1,str2),str1,str2)
}
function jaro(str1,str2,  begin,end,i,j,k,leng1,leng2,match_distance,matches,str1_arr,str2_arr,transpositions) {
    leng1 = length(str1)
    leng2 = length(str2)
    if (leng1 == 0 && leng2 == 0) { # both strings are empty
      return(1)
    }
    if (leng1 == 0 || leng2 == 0) { # only one string is empty
      return(0)
    }
    match_distance = int(max(leng1,leng2)/2-1)
    for (i=1; i<=leng1; i++) { # find matches
      begin = int(max(0,i-match_distance))
      end = int(min(i+match_distance+1,leng2))
      for (j=begin; j<=end; j++) {
        if (str2_arr[j]) { continue }
        if (substr(str1,i,1) != substr(str2,j,1)) { continue }
        str1_arr[i] = 1
        str2_arr[j] = 1
        matches++
        break
      }
    }
    if (matches == 0) {
      return(0)
    }
    k = 0
    for (i=1; i<=leng1; i++) { # count transpositions
      if (!str1_arr[i]) { continue }
      while (!str2_arr[k]) {
        k++
      }
      if (substr(str1,i,1) != substr(str2,k,1)) {
        transpositions++
      }
      k++
    }
    transpositions /= 2
    return((matches/leng1)+(matches/leng2)+((matches-transpositions)/matches))/3
}
function max(x,y) { return((x > y) ? x : y) }
function min(x,y) { return((x < y) ? x : y) }
