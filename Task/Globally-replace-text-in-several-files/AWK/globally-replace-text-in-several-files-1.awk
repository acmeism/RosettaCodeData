# syntax: GAWK -f GLOBALLY_REPLACE_TEXT_IN_SEVERAL_FILES.AWK filename(s)
BEGIN {
    old_text = "Goodbye London!"
    new_text = "Hello New York!"
}
BEGINFILE {
    nfiles_in++
    text_found = 0
    delete arr
}
{   if (gsub(old_text,new_text,$0) > 0) {
      text_found++
    }
    arr[FNR] = $0
}
ENDFILE {
    if (text_found > 0) {
      nfiles_out++
      close(FILENAME)
      for (i=1; i<=FNR; i++) {
        printf("%s\n",arr[i]) >FILENAME
      }
    }
}
END {
    printf("files: %d read, %d updated\n",nfiles_in,nfiles_out)
    exit(0)
}
