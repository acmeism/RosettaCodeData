# syntax: GAWK -f TAKE_NOTES.AWK [notes ... ]
# examples:
#   GAWK -f TAKE_NOTES.AWK Hello world
#   GAWK -f TAKE_NOTES.AWK A "B C" D
#   GAWK -f TAKE_NOTES.AWK
BEGIN {
    log_name = "NOTES.TXT"
    (ARGC == 1) ? show_log() : update_log()
    exit(0)
}
function show_log(  rec) {
    while (getline rec <log_name > 0) {
      printf("%s\n",rec)
    }
}
function update_log(  i,q) {
    print(strftime("%Y-%m-%d %H:%M:%S")) >>log_name
    printf("\t") >>log_name
    for (i=1; i<=ARGC-1; i++) {
      q = (ARGV[i] ~ / /) ? "\"" : ""
      printf("%s%s%s ",q,ARGV[i],q) >>log_name
    }
    printf("\n") >>log_name
}
