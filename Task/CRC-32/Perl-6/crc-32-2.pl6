sub crc(
    Blob $buf,
             # polynomial including leading term, default: ISO 3309/PNG/gzip
    :@poly = (1,0,0,0,0,0,1,0,0,1,1,0,0,0,0,0,1,0,0,0,1,1,1,0,1,1,0,1,1,0,1,1,1),
    :$n = @poly.end,      # degree of polynomial
    :@init = 1 xx $n,     # initial XOR bits
    :@fini = 1 xx $n,     # final XOR bits
    :@bitorder = 0..7,    # default: eat bytes LSB-first
    :@crcorder = 0..$n-1, # default: MSB of checksum is coefficient of x⁰
) {
    my @bit = ($buf.list X+& (1 X+< @bitorder))».so».Int, 0 xx $n;

    @bit[0   .. $n-1] «+^=» @init;
    @bit[$_  ..$_+$n] «+^=» @poly if @bit[$_] for 0..@bit.end-$n;
    @bit[*-$n..  *-1] «+^=» @fini;

    :2[@bit[@bit.end X- @crcorder]];
}

say crc('The quick brown fox jumps over the lazy dog'.encode('ascii')).base(16);
