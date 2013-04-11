# syntax: GAWK -f SLEEP.AWK [seconds]
BEGIN {
    print("Sleeping...")
    loop(ARGV[1])
    print("Awake!")
    exit(0)
}
function loop(seconds,  t) {
# awk lacks a sleep mechanism, so simulate one by looping
    t = systime()
    while (systime() < t + seconds) {}
}
