fn main(){
	println(sum(1000))
}

fn sum(num int) int{
	mut n:=0
	for i in 0..num{
		if i%3==0 || i%5==0 {n+=i}
	}
	return n
}
