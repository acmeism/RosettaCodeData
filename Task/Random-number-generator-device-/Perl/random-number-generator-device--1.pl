use Crypt::Random::Seed;
my $source = Crypt::Random::Seed->new( NonBlocking => 1 ); # Allow non-blocking sources like /dev/urandom
print "$_\n" for $source->random_values(10);               # A method returning an array of 32-bit values
