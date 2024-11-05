struct Mlist {value []int}

fn (m Mlist) bind(f fn (lst []int) Mlist) Mlist {return f(m.value)}

fn unit(lst []int) Mlist {return Mlist{lst}}

fn increment(lst []int) Mlist {
	mut lst2 := lst.clone()
	for i, v in lst {
		lst2[i] = v + 1
	}
	return unit(lst2)
}

fn double(lst []int) Mlist {
	mut lst2 := lst.clone()
	for i, v in lst {
		lst2[i] = 2 * v
	}
	return unit(lst2)
}

fn main() {
	ml1 := unit([3, 4, 5])
	ml2 := ml1.bind(increment).bind(double)
	println("${ml1.value} -> ${ml2.value}")
}
