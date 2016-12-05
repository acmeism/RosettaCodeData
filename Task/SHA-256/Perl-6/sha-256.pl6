say sha256 "Rosetta code";

sub init(&f) {
    map { my $f = $^p.&f; (($f - $f.Int)*2**32).Int },
    state @ = grep *.is-prime, 2 .. *;
}

sub infix:<m+> { ($^a + $^b) % 2**32 }
sub rotr($n, $b) { $n +> $b +| $n +< (32 - $b) }

proto sha256($) returns Blob {*}
multi sha256(Str $str where all($str.ords) < 128) {
    sha256 $str.encode: 'ascii'
}
multi sha256(Blob $data) {
    constant K = init(* **(1/3))[^64];
    my @b = flat $data.list, 0x80;
    push @b, 0 until (8 * @b - 448) %% 512;
    push @b, slip reverse (8 * $data).polymod(256 xx 7);
    my @word = :256[@b.shift xx 4] xx @b/4;

    my @H = init(&sqrt)[^8];
    my @w;
    loop (my $i = 0; $i < @word; $i += 16) {
        my @h = @H;
        for ^64 -> $j {
            @w[$j] = $j < 16 ?? @word[$j + $i] // 0 !!
            [m+]
            rotr(@w[$j-15], 7) +^ rotr(@w[$j-15], 18) +^ @w[$j-15] +> 3,
            @w[$j-7],
            rotr(@w[$j-2], 17) +^ rotr(@w[$j-2], 19)  +^ @w[$j-2] +> 10,
            @w[$j-16];
            my $ch = @h[4] +& @h[5] +^ +^@h[4] % 2**32 +& @h[6];
            my $maj = @h[0] +& @h[2] +^ @h[0] +& @h[1] +^ @h[1] +& @h[2];
            my $σ0 = [+^] map { rotr @h[0], $_ }, 2, 13, 22;
            my $σ1 = [+^] map { rotr @h[4], $_ }, 6, 11, 25;
            my $t1 = [m+] @h[7], $σ1, $ch, K[$j], @w[$j];
            my $t2 = $σ0 m+ $maj;
            @h = flat $t1 m+ $t2, @h[^3], @h[3] m+ $t1, @h[4..6];
        }
        @H [Z[m+]]= @h;
    }
    return Blob.new: map { |reverse .polymod(256 xx 3) }, @H;
}
