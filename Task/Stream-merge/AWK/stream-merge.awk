# syntax: GAWK -f STREAM_MERGE.AWK filename(s) >output
# handles 1 .. N files
#
# variable   purpose
# ---------- -------
# data_arr   holds last record read
# fn_arr     filenames on command line
# fnr_arr    record counts for each file
# status_arr file status: 1=more data, 0=EOF, -1=error
#
BEGIN {
    files = ARGC-1
# get filename, file status and first record
    for (i=1; i<=files; i++) {
      fn_arr[i] = ARGV[i]
      status_arr[i] = getline <fn_arr[i]
      if (status_arr[i] == 1) {
        nr++ # records read
        fnr_arr[i]++
        data_arr[i] = $0
      }
      else if (status_arr[i] < 0) {
        error(sprintf("FILENAME=%s, status=%d, file not found",fn_arr[i],status_arr[i]))
      }
    }
    while (1) { # until EOF in all files
# get file number of the first file still containing data
      fno = 0 # file number
      for (i=1; i<=files; i++) {
        if (status_arr[i] == 1) {
          fno = i
          break
        }
      }
      if (fno == 0) { # EOF in all files
        break
      }
# determine which file has the lowest record in collating sequence
      for (i=1; i<=files; i++) {
        if (status_arr[i] == 1) {
          if (data_arr[i] < data_arr[fno]) {
            fno = i
          }
        }
      }
# output record, get next record, if not EOF then check sequence
      printf("%s\n",data_arr[fno])
      status_arr[fno] = getline <fn_arr[fno] # get next record from this file
      if (status_arr[fno] == 1) {
        nr++
        fnr_arr[fno]++
        if (data_arr[fno] > $0) {
          error(sprintf("FILENAME=%s, FNR=%d, out of sequence",fn_arr[fno],fnr_arr[fno]))
        }
        data_arr[fno] = $0
      }
    }
# EOJ
    printf("input: %d files, %d records, %d errors\n",files,nr,errors) >"con"
    exit(0)
}
function error(message) {
    printf("error: %s\n",message) >"con"
    errors++
}
