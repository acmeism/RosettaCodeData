use strict;
use warnings;

my %base = ("name" => "Rocket Skates", "price" => 12.75, "color" => "yellow");
my %more = ("price" => 15.25, "color" => "red", "year" => 1974);

print "Update\n";
my %update = (%base, %more);
printf "%-7s %s\n", $_, $update{$_} for sort keys %update;

print "\nMerge\n";
my %merge;
$merge{$_} = [$base{$_}] for keys %base;
push @{$merge{$_}}, $more{$_} for keys %more;
printf "%-7s %s\n", $_, join ', ', @{$merge{$_}} for sort keys %merge;
