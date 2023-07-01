const
(
	alist = ["john", "bob", "mary", "serena"]
	blist = ["jim", "mary", "john", "bob"]
)

fn main() {
	mut rlist := []string{}
	for elem in alist {
		if blist.any(it == elem) == false {
			println("a - b = $elem")
			rlist << elem
		}
	}
	for elem in blist {
		if alist.any(it == elem) == false {
			println("b - a = $elem")
			rlist << elem
		}
	}
	println("symmetric difference: $rlist")
}
