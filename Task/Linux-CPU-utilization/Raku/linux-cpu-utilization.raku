my $last-total = 0;
my $last-idle  = 0;

loop {
    my $Δ-total = (my $this-total = [+] my @cpu = "/proc/stat".IO.lines[0].words[1..*]) - $last-total;
    my $Δ-idle  = (my $this-idle  = @cpu[3]) - $last-idle;
    $last-total = $this-total;
    $last-idle  = $this-idle;
    print "\b" x 40, (100 * (1 - $Δ-idle / $Δ-total)).fmt("Utilization: %0.1f%% ");
    sleep(1);
}
