# syntax: GAWK -f TIME_A_FUNCTION.AWK [-v delay=x] [<NUL}
# examples:
#   GAWK -f TIME_A_FUNCTION.AWK
#   GAWK -f TIME_A_FUNCTION.AWK -v delay=1
#   GAWK -f TIME_A_FUNCTION.AWK -v delay=1.0 <NUL
@load "time"
BEGIN {
    delay += 0
    printf("delay=%s\n",delay)
#
    start = systime()
    do_something()
    stop = systime()
    show("accurate to one second using GAWK's builtin systime()")
#
    start = dos_time()
    do_something()
    stop = dos_time()
    show("accurate to 1/100th of a second using Windows TIME command ")
#
    start = gettimeofday()
    do_something()
    stop = gettimeofday()
    show("accurate to 1/1000000th of a second using GAWK's time extension")
#
    exit(0)
}
function dos_time(  cmd,seconds,x) {   # Windows time in HH:MM:SS.hh format
# assumes 24 hour clock
    cmd = "TIME <NUL"
    cmd | getline x                    # The current time is: 12:34:56.78
    close(cmd)
    seconds = substr(x,22,2) * 3600    # hour
    seconds += substr(x,25,2) * 60     # minute
    seconds += substr(x,28,2)          # second
    seconds += substr(x,31,2) / 100    # hundred second
    return(seconds)
}
function do_something() {
    sleep(delay)
    print("press ENTER to continue")
    getline
}
function show(msg) {
    if (start > stop) {
      print("next day rollover occurred")
    }
    printf("%.6f seconds (%017.6f-%017.6f)\n",stop-start,stop,start)
    printf("%s\n\n",msg)
}
