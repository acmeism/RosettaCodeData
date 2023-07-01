use experimental :pack;
my $UR = open("/dev/urandom", :bin) orelse .die;
my @random-spigot = $UR.read(1024).unpack("L*") ... *;

.say for @random-spigot[^10];
