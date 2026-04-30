# syntax: GAWK -f MAC_VENDOR_LOOKUP.AWK
# operating system: Windows 11
@load "time"
BEGIN {
    fn = "CURL.TMP"
    n = split("88:53:2E:67:07:BE,FC:FB:FB:01:FA:21,D4:F4:6F:C9:EF:8D,FCA13E2A1C33,banana",arr,",")
    for (i=1; i<=n; i++) {
      cmd = sprintf("CURL.EXE --silent --output %s --url https://api.macvendors.com/%s",fn,arr[i])
      system(cmd)
      while (getline rec <fn > 0) {
        if (tolower(rec) ~ /error/) {
          rec = "N/A"
        }
        printf("%-17s %s\n",arr[i],rec)
      }
      close(fn)
      sleep(1)
    }
    system("DEL " fn)
    exit(0)
}
