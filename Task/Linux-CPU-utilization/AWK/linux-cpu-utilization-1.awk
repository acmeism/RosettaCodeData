BEGIN {
  prev_total = 0
  prev_idle = 0
  while (getline < "/proc/stat") {
    close("/proc/stat")
    idle = $5
    total = 0
    for (i=2; i<=NF; i++)
      total += $i
    print (1-(idle-prev_idle)/(total-prev_total))*100"%"
    prev_idle = idle
    prev_total = total
    system("sleep 1")
  }
}
