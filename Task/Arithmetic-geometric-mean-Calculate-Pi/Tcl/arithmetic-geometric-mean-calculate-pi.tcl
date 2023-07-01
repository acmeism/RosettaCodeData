package require math::bigfloat
namespace import math::bigfloat::*

proc agm/π {N {precision 8192}} {
    set 1 [int2float 1 $precision]
    set 2 [int2float 2 $precision]
    set n 1
    set a $1
    set g [div $1 [sqrt $2]]
    set z [div $1 [int2float 4 $precision]]
    for {set i 0} {$i <= $N} {incr i} {
	set x0 [div [add $a $g] $2]
	set x1 [sqrt [mul $a $g]]
	set var [sub $x0 $a]
	set z [sub $z [mul [mul $var $n] $var]]
	incr n $n
	set a $x0
	set g $x1
    }
    return [tostr [div [mul $a $a] $z]]
}

puts [agm/π 17]
