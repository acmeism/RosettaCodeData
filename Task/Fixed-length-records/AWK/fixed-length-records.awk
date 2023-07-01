# syntax: GAWK -f FIXED_LENGTH_RECORDS.AWK
BEGIN {
    vlr_fn = "FIXED_LENGTH_RECORDS.TXT"
    flr_fn = "FIXED_LENGTH_RECORDS.TMP"
    print("bef:")
    while (getline rec <vlr_fn > 0) { # read variable length records
      printf("%-80.80s",rec) >flr_fn # write fixed length records without CR/LF
      printf("%s\n",rec)
    }
    close(vlr_fn)
    close(flr_fn)
    print("aft:")
    getline rec <flr_fn # read entire file
    while (length(rec) > 0) {
      printf("%s\n",revstr(substr(rec,1,80),80))
      rec = substr(rec,81)
    }
    exit(0)
}
function revstr(str,start) {
    if (start == 0) {
      return("")
    }
    return( substr(str,start,1) revstr(str,start-1) )
}
