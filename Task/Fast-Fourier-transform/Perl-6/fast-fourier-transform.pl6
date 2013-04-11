sub fft {
    return @_ if @_ == 1;
    my @evn = fft( @_[0,2...^* >= @_] );
    my @odd = fft( @_[1,3...^* >= @_] );
    my $twd = 2i * pi / @_; # twiddle factor
    @odd  »*=« (^@odd).map(* * $twd)».exp;
    return @evn »+« @odd, @evn »-« @odd;
}

my @seq    = ^16;
my $cycles = 3;
my @wave   = (@seq »*» (2*pi / @seq * $cycles))».sin;
say "wave: ", @wave.fmt("%7.3f");

say "fft:  ", fft(@wave)».abs.fmt("%7.3f");
