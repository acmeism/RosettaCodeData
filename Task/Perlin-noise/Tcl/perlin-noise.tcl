namespace eval perlin {
    proc noise {x y z} {
	# Find unit cube that contains point.
	set X [expr {int(floor($x)) & 255}]
	set Y [expr {int(floor($y)) & 255}]
	set Z [expr {int(floor($z)) & 255}]

	# Find relative x,y,z of point in cube.
	set x [expr {$x - floor($x)}]
	set y [expr {$y - floor($y)}]
	set z [expr {$z - floor($z)}]

	# Compute fade curves for each of x,y,z.
	set u [expr {fade($x)}]
	set v [expr {fade($y)}]
	set w [expr {fade($z)}]

	# Hash coordinates of the 8 cube corners...
	variable p
	set A  [expr {p($X)   + $Y}]
	set AA [expr {p($A)   + $Z}]
	set AB [expr {p($A+1) + $Z}]
	set B  [expr {p($X+1) + $Y}]
	set BA [expr {p($B)   + $Z}]
	set BB [expr {p($B+1) + $Z}]

	# And add blended results from 8 corners of cube
	return [expr {
	    lerp($w, lerp($v, lerp($u, grad(p($AA),   $x,   $y,   $z ),
				       grad(p($BA),   $x-1, $y,   $z )),
			      lerp($u, grad(p($AB),   $x,   $y-1, $z ),
				       grad(p($BB),   $x-1, $y-1, $z ))),
		     lerp($v, lerp($u, grad(p($AA+1), $x,   $y,   $z-1 ),
				       grad(p($BA+1), $x-1, $y,   $z-1 )),
			      lerp($u, grad(p($AB+1), $x,   $y-1, $z-1 ),
				       grad(p($BB+1), $x-1, $y-1, $z-1 ))))
	}]
    }

    namespace eval tcl::mathfunc {
	proc p    {idx}   {lindex $::perlin::permutation $idx}
	proc fade {t}     {expr { $t**3 * ($t * ($t * 6 - 15) + 10) }}
	proc lerp {t a b} {expr { $a + $t * ($b - $a) }}
	proc grad {hash x y z} {
	    # Convert low 4 bits of hash code into 12 gradient directions
	    set h [expr { $hash & 15 }]
	    set u [expr { $h<8 ? $x : $y }]
	    set v [expr { $h<4 ? $y : ($h==12 || $h==14) ? $x : $z }]
	    expr { (($h&1)==0 ? $u : -$u) + (($h&2)==0 ? $v : -$v) }
	}
    }

    apply {{} {
	binary scan [binary format H* [join {
	    97A0895B5A0F830DC95F6035C2E907E18C24671E458E086325F0150A17BE0694F7
	    78EA4B001AC53E5EFCDBCB75230B2039B12158ED953857AE147D88ABA844AF4AA5
            47868B301BA64D929EE7536FE57A3CD385E6DC695C29372EF528F4668F3641193F
	    A101D85049D14C84BBD05912A9C8C4878274BC9F56A4646DC6ADBA034034D9E2FA
            7C7B05CA2693767EFF5255D4CFCE3BE32F103A11B6BD1C2ADFB7AAD577F898022C
	    9AA346DD99659BA72BAC09811627FD13626C6E4F71E0E8B2B97068DAF661E4FB22
            F2C1EED2900CBFB3A2F1513391EBF90EEF6B31C0D61FB5C76A9DB854CCB0737932
	    2D7F0496FE8AECCD5DDE72431D1848F38D80C34E42D73D9CB4
	} ""]] cu* p
	variable ::perlin::permutation [concat $p $p]
    }}
}

puts [perlin::noise 3.14 42 7]
