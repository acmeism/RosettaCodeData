sub infix:<⊞>(uint32 $a, uint32 $b --> uint32) { ($a + $b) +& 0xffffffff }
sub infix:«<<<»(uint32 $a, UInt $n --> uint32) { ($a +< $n) +& 0xffffffff +| ($a +> (32-$n)) }

constant FGHI = { ($^a +& $^b) +| (+^$a +& $^c) },
                { ($^a +& $^c) +| ($^b +& +^$c) },
                { $^a +^ $^b +^ $^c             },
                { $^b +^ ($^a +| +^$^c)         };

constant _S = flat (7, 12, 17, 22) xx 4,
                  (5,  9, 14, 20) xx 4,
                  (4, 11, 16, 23) xx 4,
                  (6, 10, 15, 21) xx 4;

constant T = (floor(abs(sin($_ + 1)) * 2**32) for ^64);

constant k = flat (   $_           for ^16),
                  ((5*$_ + 1) % 16 for ^16),
                  ((3*$_ + 5) % 16 for ^16),
                  ((7*$_    ) % 16 for ^16);

sub little-endian($w, $n, *@v) {
    my \step1 = ($w X* ^$n).eager;  # temporary bug workaround
    my \step2 = (@v X+> step1);
    step2 X% (2 ** $w);
}

sub md5-pad(Blob $msg)
{
    my \bits = 8 * $msg.elems;
    my @padded = flat $msg.list, 0x80, 0x00 xx (-(bits div 8 + 1 + 8) % 64);
    flat @padded.map({ :256[$^d,$^c,$^b,$^a] }), little-endian(32, 2, bits);
}

sub md5-block(@H, @X)
{
    my uint32 ($A, $B, $C, $D) = @H;
    ($A, $B, $C, $D) = ($D, $B ⊞ (($A ⊞ FGHI[$_ div 16]($B, $C, $D) ⊞ T[$_] ⊞ @X[k[$_]]) <<< _S[$_]), $B, $C) for ^64;
    @H «⊞=» ($A, $B, $C, $D);
}

sub md5(Blob $msg --> Blob)
{
    my uint32 @M = md5-pad($msg);
    my uint32 @H = 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476;
    md5-block(@H, @M[$_ .. $_+15]) for 0, 16 ...^ +@M;
    Blob.new: little-endian(8, 4, @H);
}

use Test;
plan 7;

for 'd41d8cd98f00b204e9800998ecf8427e', '',
    '0cc175b9c0f1b6a831c399e269772661', 'a',
    '900150983cd24fb0d6963f7d28e17f72', 'abc',
    'f96b697d7cb7938d525a2f31aaf161d0', 'message digest',
    'c3fcd3d76192e4007dfb496cca67e13b', 'abcdefghijklmnopqrstuvwxyz',
    'd174ab98d277d9f5a5611c2c9f419d9f', 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
    '57edf4a22be3c955ac49da2e2107b67a', '12345678901234567890123456789012345678901234567890123456789012345678901234567890'
-> $expected, $msg {
    my $digest = md5($msg.encode('ascii')).list».fmt('%02x').join;
    is($digest, $expected, "$digest is MD5 digest of '$msg'");
}
