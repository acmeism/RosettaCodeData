proc isHermitian {matrix {epsilon 1e-14}} {
    if {[$matrix rows] != [$matrix columns]} {
	# Must be square!
	return 0
    }
    set cc [complexMatrix.conjugateTranspose $matrix]
    set result [complexMatrix.equal $matrix $cc $epsilon]
    $cc destroy
    return $result
}

proc isNormal {matrix {epsilon 1e-14}} {
    if {[$matrix rows] != [$matrix columns]} {
	# Must be square!
	return 0
    }
    set mh [complexMatrix.conjugateTranspose $matrix]
    set mhm [complexMatrix.multiply $mh $matrix]
    set mmh [complexMatrix.multiply $matrix $mh]
    $mh destroy
    set result [complexMatrix.equal $mhm $mmh $epsilon]
    $mhm destroy
    $mmh destroy
    return $result
}

proc isUnitary {matrix {epsilon 1e-14}} {
    if {[$matrix rows] != [$matrix columns]} {
	# Must be square!
	return 0
    }
    set mh [complexMatrix.conjugateTranspose $matrix]
    set mhm [complexMatrix.multiply $mh $matrix]
    set mmh [complexMatrix.multiply $matrix $mh]
    $mh destroy
    set result [complexMatrix.equal $mhm $mmh $epsilon]
    $mhm destroy
    if {$result} {
	set id [struct::matrix]
	$id = $matrix;   # Just for its dimensions
	for {set c 0} {$c < [$id columns]} {incr c} {
	    for {set r 0} {$r < [$id rows]} {incr r} {
		$id set cell $c $r \
		    [math::complexnumbers::complex [expr {$c==$r}] 0]
	    }
	}
	set result [complexMatrix.equal $mmh $id $epsilon]
	$id destroy
    }
    $mmh destroy
    return $result
}
