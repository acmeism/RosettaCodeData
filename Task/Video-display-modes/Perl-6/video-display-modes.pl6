my @info = QX('xrandr -q').lines;

@info[0] ~~ /<?after 'current '>(\d+) ' x ' (\d+)/;
my $current = "$0x$1";

my @resolutions;
@resolutions.push: $0 if $_ ~~ /^\s+(\d+'x'\d+)/ for @info;

QX("xrandr -s @resolutions[*-1]");
say "Current resolution {@resolutions[*-1]}.";
for 9 ... 1 {
    print "\rChanging back in $_ seconds...";
    sleep 1;
}
QX("xrandr -s $current");
say "\rResolution returned to {$current}.     ";
