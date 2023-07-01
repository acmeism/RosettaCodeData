# syntax: GAWK -f FASTA_FORMAT.AWK filename
# stop processing each file when an error is encountered
{   if (FNR == 1) {
      header_found = 0
      if ($0 !~ /^[;>]/) {
        error("record is not valid")
        nextfile
      }
    }
    if ($0 ~ /^;/) { next } # comment begins with a ";"
    if ($0 ~ /^>/) { # header
      if (header_found > 0) {
        printf("\n") # EOL for previous sequence
      }
      printf("%s: ",substr($0,2))
      header_found = 1
      next
    }
    if ($0 ~ /[ \t]/) { next } # ignore records with whitespace
    if ($0 ~ /\*$/) { # sequence may end with an "*"
      if (header_found > 0) {
        printf("%s\n",substr($0,1,length($0)-1))
        header_found = 0
        next
      }
      else {
        error("end of sequence found but header is missing")
        nextfile
      }
    }
    if (header_found > 0) {
      printf("%s",$0)
    }
    else {
      error("header not found")
      nextfile
    }
}
ENDFILE {
    if (header_found > 0) {
      printf("\n")
    }
}
END {
    exit (errors == 0) ? 0 : 1
}
function error(message) {
    printf("error: FILENAME=%s, FNR=%d, %s, %s\n",FILENAME,FNR,message,$0) >"con"
    errors++
    return
}
