say sha256 "Rosetta code";

our proto sha256($) returns blob8 {*}

multi sha256(Str $str) { samewith $str.encode }
multi sha256(blob8 $data) {
  sub rotr { $^a +> $^b +| $a +< (32 - $b) }
  sub init { ^Inf .grep(&is-prime).map: { (($_ - .Int)*2**32).Int } o &^f }
  sub   Ch { $^x +& $^y +^ +^$x +& $^z }
  sub  Maj { $^x +& $^y +^ $x +& $^z +^ $y +& $z }
  sub   Σ0 { rotr($^x,  2) +^ rotr($x, 13) +^ rotr($x, 22) }
  sub   Σ1 { rotr($^x,  6) +^ rotr($x, 11) +^ rotr($x, 25) }
  sub   σ0 { rotr($^x,  7) +^ rotr($x, 18) +^ $x +>  3 }
  sub   σ1 { rotr($^x, 17) +^ rotr($x, 19) +^ $x +> 10 }

  return blob8.new:
    map |*.polymod(256 xx 3).reverse,
	|reduce -> $H, $block {
	  blob32.new: $H[] Z+
	    reduce -> $h, $j {
	      my uint32 ($T1, $T2) =
		$h[7] + Σ1($h[4]) + Ch(|$h[4..6])
		+ (BEGIN init(* **(1/3))[^64])[$j] +
		(
		 (state buf32 $w .= new)[$j] = $j < 16 ?? $block[$j] !!
		 σ0($w[$j-15]) + $w[$j-7] + σ1($w[$j-2]) + $w[$j-16]
		),
	      Σ0($h[0]) + Maj(|$h[0..2]);
	      blob32.new: $T1 + $T2, |$h[0..2], $h[3] + $T1, |$h[4..6];
	    }, $H, |^64;
	},
	(BEGIN init(&sqrt)[^8]),
	|blob32.new(
	    blob8.new(
	      @$data,
	      0x80,
	      0 xx (-($data + 1 + 8) mod 64),
	      (8*$data).polymod(256 xx 7).reverse
	      ).rotor(4)
	    .map: { :256[@$_] }
	  ).rotor(16)
}
