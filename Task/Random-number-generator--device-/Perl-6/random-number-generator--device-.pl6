my $UR = open("/dev/urandom", :bin) or die "Can't open /dev/urandom: $!";
my @random-spigot := gather loop { take $UR.read(1024).unpack("L*") }

.say for @random-spigot[^10];
