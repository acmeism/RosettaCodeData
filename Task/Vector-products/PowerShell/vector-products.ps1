function dot-product($a,$b) {
    $a[0]*$b[0] +  $a[1]*$b[1] +  $a[2]*$b[2]
}

function cross-product($a,$b) {
    $v1 = $a[1]*$b[2] - $a[2]*$b[1]
    $v2 = $a[2]*$b[0] - $a[0]*$b[2]
    $v3 = $a[0]*$b[1] - $a[1]*$b[0]
    @($v1,$v2,$v3)
}

function scalar-triple-product($a,$b,$c) {
    dot-product $a (cross-product $b $c)
}

function vector-triple-product($a,$b) {
    cross-product $a (cross-product $b $c)
}

$a = @(3, 4, 5)
$b = @(4, 3, 5)
$c = @(-5, -12, -13)

"a.b = $(dot-product $a $b)"
"axb = $(cross-product $a $b)"
"a.(bxc) = $(scalar-triple-product $a $b $c)"
"ax(bxc) = $(vector-triple-product $a $b $c)"
