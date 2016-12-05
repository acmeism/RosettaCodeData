use experimental :pack;
my $UR = open("/dev/urandom", :bin) or die "Can't open /dev/urandom: $!";
my @random-spigot = $UR.read(1024).unpack("L*") ... *;

.say for @random-spigot[^10];
