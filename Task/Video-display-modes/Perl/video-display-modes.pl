$| = 1;

my @info = `xrandr -q`;
$info[0] =~ /current (\d+) x (\d+)/;
my $current = "$1x$2";

my @resolutions;
for (@info) {
    push @resolutions, $1 if /^\s+(\d+x\d+)/
}

system("xrandr -s $resolutions[-1]");
print "Current resolution $resolutions[-1].\n";
for (reverse 1 .. 9) {
    print "\rChanging back in $_ seconds...";
    sleep 1;
}
system("xrandr -s $current");
print "\rResolution returned to $current.\n";
