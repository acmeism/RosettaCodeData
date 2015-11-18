sub fft {
    return @_ if @_ == 1;
    my @evn = fft( @_[0, 2 ... *] );
    my @odd = fft( @_[1, 3 ... *] ) Z*
    map &cis, (0, 2 * pi / @_ ... *);
    return flat @evn »+« @odd, @evn »-« @odd;
}

my @seq    = ^16;
my $cycles = 3;
my @wave   = map { sin( 2*pi * $_ / @seq * $cycles ) }, @seq;
say "wave: ", @wave.fmt("%7.3f");

say "fft:  ", fft(@wave)».abs.fmt("%7.3f");
