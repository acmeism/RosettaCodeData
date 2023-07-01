fn main(){
	mut n, mut c := get_combs(1,7,true)
	println("$n unique solutions in 1 to 7")
	println(c)
	n, c = get_combs(3,9,true)
	println("$n unique solutions in 3 to 9")
	println(c)
	n, _ = get_combs(0,9,false)
	println("$n non-unique solutions in 0 to 9")
}

fn get_combs(low int,high int,unique bool) (int, [][]int) {
    mut num := 0
    mut valid_combs := [][]int{}
	for a := low; a <= high; a++ {
		for b := low; b <= high; b++ {
			for c := low; c <= high; c++ {
				for d := low; d <= high; d++ {
					for e := low; e <= high; e++ {
						for f := low; f <= high; f++ {
							for g := low; g <= high; g++ {
								if valid_comb(a,b,c,d,e,f,g) {
									if !unique || is_unique(a,b,c,d,e,f,g) {
										num++
										valid_combs << [a,b,c,d,e,f,g]
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return num, valid_combs
}
fn is_unique(a int,b int,c int,d int,e int,f int,g int) bool {
	mut data := map[int]int{}
	data[a]++
	data[b]++
	data[c]++
	data[d]++
	data[e]++
	data[f]++
	data[g]++
	return data.len == 7
}
fn valid_comb(a int,b int,c int,d int,e int,f int,g int) bool {
	square1 := a + b
	square2 := b + c + d
	square3 := d + e + f
	square4 := f + g
	return square1 == square2 && square2 == square3 && square3 == square4
}
