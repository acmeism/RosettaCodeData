sub postfix:<mod2³²>(\x) { x % 2**32 }
sub infix:<⊕>(\x,\y)     { (x + y)mod2³² }
sub S(\n,\X)             { (X +< n)mod2³² +| (X +> (32-n)) }

my \f = -> \B,\C,\D { (B +& C) +| ((+^B)mod2³² +& D)   },
        -> \B,\C,\D { B +^ C +^ D                      },
        -> \B,\C,\D { (B +& C) +| (B +& D) +| (C +& D) },
        -> \B,\C,\D { B +^ C +^ D                      };

my \K = 0x5A827999, 0x6ED9EBA1, 0x8F1BBCDC, 0xCA62C1D6;

sub sha1-pad(Buf $msg)
{
    my \bits = 8 * $msg.elems;
    my @padded = $msg.list, 0x80, 0x00 xx (-(bits div 8 + 1 + 8) % 64);
    @padded.map({ :256[$^a,$^b,$^c,$^d] }), (bits +> 32)mod2³², (bits)mod2³²;
}

sub sha1-block(@H is rw, @M)
{
    my @W = @M;
    @W.push: S(1, @W[$_-3] +^ @W[$_-8] +^ @W[$_-14] +^ @W[$_-16]) for 16..79;

    my ($A,$B,$C,$D,$E) = @H;
    for 0..79 -> \t {
        my \TEMP = S(5,$A) ⊕ f[t div 20]($B,$C,$D) ⊕ $E ⊕ @W[t] ⊕ K[t div 20];
        $E = $D; $D = $C; $C = S(30,$B); $B = $A; $A = TEMP;
    }
    @H «⊕=» ($A,$B,$C,$D,$E);
}

sub sha1(Buf $msg)
{
    my @M = sha1-pad($msg);
    my @H = 0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476, 0xC3D2E1F0;
    sha1-block(@H,@M[$_..$_+15]) for 0,16...^+@M;
    @H;
}

say sha1($_.encode('ascii'))».base(16), "  $_"
   for 'abc',
       'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq',
       'Rosetta Code',
       'Ars longa, vita brevis';
