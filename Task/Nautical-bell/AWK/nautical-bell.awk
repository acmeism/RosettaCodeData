# syntax: GAWK -f NAUTICAL_BELL.AWK
BEGIN {
#   sleep_cmd = "sleep 55s" # Unix
    sleep_cmd = "TIMEOUT /T 55 >NUL" # MS-Windows
    split("Middle,Morning,Forenoon,Afternoon,Dog,First",watch_arr,",")
    split("One,Two,Three,Four,Five,Six,Seven,Eight",bells_arr,",")
    simulate1day()
    while (1) {
      t = systime()
      h = strftime("%H",t) + 0
      m = strftime("%M",t) + 0
      if (m == 0 || m == 30) {
        nb(h,m)
        while (systime() < t + 5) {}
      }
      system(sleep_cmd)
    }
    exit(0)
}
function nb(h,m,  bells,hhmm,plural,sounds,watch) {
#   hhmm = sprintf("%02d:%02d",h,m)
#   if (hhmm == "00:00") { watch = 6 }
#   else if (hhmm <= "04:00") { watch = 1 }
#   else if (hhmm <= "08:00") { watch = 2 }
#   else if (hhmm <= "12:00") { watch = 3 }
#   else if (hhmm <= "16:00") { watch = 4 }
#   else if (hhmm <= "20:00") { watch = 5 }
#   else { watch = 6}
# determining watch: verbose & readable (above) vs. terse & cryptic (below)
    watch = 60 * h + m
    watch = (watch < 1 ) ? 6 : int((watch - 1) / 240 + 1)
    bells = (h % 4) * 2 + int(m / 30)
    if (bells == 0) { bells = 8 }
    plural = (bells == 1) ? " " : "s"
    sounds = strdup("\x07",bells)
    printf("%02d:%02d %9s watch %5s bell%s  %s\n",h,m,watch_arr[watch],bells_arr[bells],plural,sounds)
}
function simulate1day(   h,m) {
    for (h=0; h<=23; h++) {
      for (m=0; m<=59; m+=30) {
        nb(h,m)
      }
    }
}
function strdup(str,n,  i,new_str) {
    for (i=1; i<=n; i++) {
      new_str = new_str str
    }
    gsub(str str,"& ",new_str)
    return(new_str)
}
