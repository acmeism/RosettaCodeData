use Crypt::Random::Source qw/get_weak/;    # Alternately get_strong
print unpack('L*',get_weak(4)), "\n" for 1..10;
