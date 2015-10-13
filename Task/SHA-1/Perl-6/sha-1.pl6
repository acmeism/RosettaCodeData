sub postfix:<mod2³²> { $^x % 2**32 }
sub infix:<⊕>        { ($^x + $^y)mod2³² }
sub S                { ($^x +< $^n)mod2³² +| ($x +> (32-$n)) }

my \f = -> \B,\C,\D { (B +& C) +| ((+^B)mod2³² +& D)   },
        -> \B,\C,\D { B +^ C +^ D                      },
        -> \B,\C,\D { (B +& C) +| (B +& D) +| (C +& D) },
        -> \B,\C,\D { B +^ C +^ D                      };

my \K = 0x5A827999, 0x6ED9EBA1, 0x8F1BBCDC, 0xCA62C1D6;

sub sha1-pad(Blob $msg)
{
    my \bits = 8 * $msg.elems;
    my @padded = flat $msg.list, 0x80, 0x00 xx (-($msg.elems + 1 + 8) % 64);
    flat @padded.map({ :256[$^a,$^b,$^c,$^d] }), (bits +> 32)mod2³², (bits)mod2³²;
}

sub sha1-block(@H is rw, @M is copy)
{
    @M.push: S(1, [+^] @M[$_ «-« <3 8 14 16>] ) for 16 .. 79;

    my ($A,$B,$C,$D,$E) = @H;
    for 0..79 -> \t {
        ($A, $B, $C, $D, $E) =
        S(5,$A) ⊕ f[t div 20]($B,$C,$D) ⊕ $E ⊕ @M[t] ⊕ K[t div 20],
        $A, S(30,$B), $C, $D;
    }
    @H »⊕=« ($A,$B,$C,$D,$E);
}

sub sha1(Blob $msg) returns Blob
{
    my @M = sha1-pad($msg);
    my @H = 0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476, 0xC3D2E1F0;
    sha1-block(@H,@M[$_..$_+15]) for 0, 16...^ +@M;
    Blob.new: flat map { reverse .polymod(256 xx 3) }, @H;
}

say sha1(.encode('ascii')), "  $_"
   for 'abc',
       'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq',
       'Rosetta Code',
       'Ars longa, vita brevis';
