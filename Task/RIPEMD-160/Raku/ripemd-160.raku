# https://github.com/grondilu/libdigest-raku/blob/master/lib/Digest/RIPEMD.rakumod

say rmd160 "Rosetta Code";

=begin CREDITS
Crypto-JS v2.0.0
http:#code.google.com/p/crypto-js/
Copyright (c) 2009, Jeff Mott. All rights reserved.
=end CREDITS

proto rmd160($) returns Blob is export {*}
multi rmd160(Str $str) { samewith $str.encode }

multi rmd160(Blob $data) {

  sub rotl(uint32 $n, $b) { $n +< $b +| $n +> (32 - $b) }

  blob8.new:
    map |*.polymod(256 xx 3),
    |reduce
      -> blob32 $h, @words {
        blob32.new: [Z+] map {$_[[^5].rotate(++$)]}, $h, |await
          map -> [&f, $r, @K, $s] {
            start {
              reduce -> $A, $j {
                $A[4],
                rotl(
                  ($A[0] + (BEGIN [
                    * +^ * +^ *,
                    { $^x +& $^y +| +^$x +& $^z },
                    (* +| +^*) +^ *,
                    { $^x +& $^z +| $^y +& +^$^z },
                    { $^x +^ ($^y +| +^$^z) }
                  ])[&f($j) div 16](|$A[1..3])
                  + @words[$r[$j]] + @K[$j]) mod 2**32,
                  $s[$j]
                ) + $A[4],
                $A[1],
                rotl($A[2], 10),
                $A[3]
              }, $h, |^80
            }
          },
          BEGIN Array.new:
            map -> [ &a,$b,@c,$d ] {
              [&a,.($b),(flat @c »xx» 16),.($d)] given *.comb».parse-base(16)
            },
            (  +*,
              "0123456789ABCDEF74D1A6F3C0952EB83AE49F812706DB5C19BA08C4D37FE56240597C2AE138B6FD",
              <0x00000000 0x5a827999 0x6ed9eba1 0x8f1bbcdc 0xa953fd4e>,
              "BEFC5879BDEF6798768DB97F7CF9B7DCBD67E9DFE8D65C75BCEFEF989E56865C9F5B68DC5CDEB856"
            ),
            (79-*,
              "5E7092B4D6F81A3C6B370D5AEF8C4912F5137E69B8C2A04D86413BF05C2D97AECFA4158762DE039B",
              <0x50a28be6 0x5c4dd124 0x6d703ef3 0x7a6d76e9 0x00000000>,
              "899BDFF5778BEEC69DF7C89B77C76FDB97FB866ECD5EDD75F58BEE6E69C9C5F885C9C5E68D65FDBB"
            )
          ;
      },
      (BEGIN blob32.new: 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0),
      |blob32.new(
        blob8.new(
          $data.list,
          0x80,
          0 xx (-($data.elems + 1 + 8) % 64),
          |(8 * $data).polymod: 256 xx 7
        ).rotor(4).map: { :256[@^x.reverse] }
      ).rotor(16);
}
