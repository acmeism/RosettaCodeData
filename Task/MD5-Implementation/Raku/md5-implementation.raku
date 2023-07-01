proto md5($msg) returns Blob is export {*}
multi md5(Str $msg) { md5 $msg.encode }
multi md5(Blob $msg) {
  sub rotl(uint32 \x, \n) returns uint32 { (x +< n) +| (x +> (32-n)) }
  sub little-endian($w, $n, *@v) { (@v X+> flat ($w X* ^$n)) X% (2 ** $w) }
  my \bits = 8 * $msg.elems;
  Blob.new: little-endian 8, 4,
    |reduce -> Blob $blob, blob32 $X {
      blob32.new: $blob Z+
        reduce -> $b, $i {
          blob32.new:
            $b[3],
            $b[1] + rotl(
              $b[0] + (BEGIN Array.new:
              { ($^x +& $^y) +| (+^$x +& $^z) },
              { ($^x +& $^z) +| ($^y +& +^$z) },
              { $^x +^ $^y +^ $^z },
              { $^y +^ ($^x +| +^$^z) }
              )[$i div 16](|$b[1..3]) +
              (BEGIN blob32.new: map &floor ∘ * * 2**32 ∘ &abs ∘ &sin ∘ * + 1, ^64)[$i] +
              $X[(BEGIN Blob.new: 16 X[R%] flat ($++, 5*$++ + 1, 3*$++ + 5, 7*$++) Xxx 16)[$i]],
              (BEGIN flat < 7 12 17 22 5 9 14 20 4 11 16 23 6 10 15 21 >.rotor(4) Xxx 4)[$i]
            ),
            $b[1],
            $b[2]
        }, $blob, |^64;
    },
    (BEGIN blob32.new: 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476),
    |map { blob32.new: @$_ },
      blob32.new(flat(@$msg, 0x80, 0x00 xx (-(bits div 8 + 1 + 8) % 64))
        .rotor(4).map({ :256[@^a.reverse] }), little-endian(32, 2, bits)
      )
    .rotor(16);
}

CHECK {
  use Test;

  for 'd41d8cd98f00b204e9800998ecf8427e', '',
      '0cc175b9c0f1b6a831c399e269772661', 'a',
      '900150983cd24fb0d6963f7d28e17f72', 'abc',
      'f96b697d7cb7938d525a2f31aaf161d0', 'message digest',
      'c3fcd3d76192e4007dfb496cca67e13b', 'abcdefghijklmnopqrstuvwxyz',
      'd174ab98d277d9f5a5611c2c9f419d9f', 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
      '57edf4a22be3c955ac49da2e2107b67a', '12345678901234567890123456789012345678901234567890123456789012345678901234567890'
        -> $expected, $msg {
          my $digest = md5($msg).list».fmt('%02x').join;
          is($digest, $expected, "$digest is MD5 digest of '$msg'");
        }
  done-testing;
}
