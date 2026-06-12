$last_total = 0;
$last_idle  = 0;

while () {
    @cpu = split /\s+/, `head -1 /proc/stat`;
    shift @cpu;
    $this_total  = 0;
    $this_total += $_ for @cpu;
    $delta_total = $this_total - $last_total;
    $this_idle   = $cpu[3]     - $last_idle;
    $delta_idle  = $this_idle  - $last_idle;
    $last_total  = $this_total;
    $last_idle   = $this_idle;
    printf "Utilization: %0.1f%%\n", 100 * (1 - $delta_idle / $delta_total);
    sleep 1;
}
