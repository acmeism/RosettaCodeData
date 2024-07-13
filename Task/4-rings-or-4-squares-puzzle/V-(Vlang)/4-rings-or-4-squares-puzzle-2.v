import math.bits

fn main ( ) {
	mut n := 0
	mut t := []u8{len:7}
	
	n = solve ( 0, mut t, 1, 7, true )
	println ( "$n unique solutions in 1 to 7" )
	n = solve ( 0, mut t, 3, 9, true )
	println("$n unique solutions in 3 to 9")
	n = solve ( 0, mut t, 0, 9, false )
	println("$n non-unique solutions in 0 to 9")
}

fn solve ( lvl u8, mut t []u8, low u8, high u8,unique bool ) int {
	if lvl==7 {
		return int(suma(t) && (!unique || isunique( t )))
	}
	mut cnt:=0
	for v := low; v <= high; v++ {
		t[lvl] = v
		cnt += solve ( lvl + 1, mut t, low, high, unique )
	}
	return cnt
}

@[inline]
fn isunique ( t []u8 ) bool {
	return bits.ones_count_32(u32(1)<<t[0] | 1<<t[1] | 1<<t[2] | 1<<t[3] | 1<<t[4] | 1<<t[5] | 1<<t[6]) == 7
}

fn suma ( t []u8 ) bool {
	s1 := t[0] + t[1]
	s2 := t[1] + t[2] + t[3]
	s3 := t[3] + t[4] + t[5]
	s4 := t[5] + t[6]
	return s1 == s2 && s2 == s3 && s3 == s4	
}
