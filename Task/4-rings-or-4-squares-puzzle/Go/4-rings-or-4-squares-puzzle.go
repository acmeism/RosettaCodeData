package main

import "fmt"

func main(){
	n, c := getCombs(1,7,true)
	fmt.Printf("%d unique solutions in 1 to 7\n",n)
	fmt.Println(c)
	n, c = getCombs(3,9,true)
	fmt.Printf("%d unique solutions in 3 to 9\n",n)
	fmt.Println(c)
	n, _ = getCombs(0,9,false)
	fmt.Printf("%d non-unique solutions in 0 to 9\n",n)
}

func getCombs(low,high int,unique bool) (num int,validCombs [][]int){
	for a := low; a <= high; a++ {
		for b := low; b <= high; b++ {
			for c := low; c <= high; c++ {
				for d := low; d <= high; d++ {
					for e := low; e <= high; e++ {
						for f := low; f <= high; f++ {
							for g := low; g <= high; g++ {
								if validComb(a,b,c,d,e,f,g) {
									if !unique || isUnique(a,b,c,d,e,f,g) {
										num++
										validCombs = append(validCombs,[]int{a,b,c,d,e,f,g})
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return
}
func isUnique(a,b,c,d,e,f,g int) (res bool) {
	data := make(map[int]int)
	data[a]++
	data[b]++
	data[c]++
	data[d]++
	data[e]++
	data[f]++
	data[g]++
	return len(data) == 7
}
func validComb(a,b,c,d,e,f,g int) bool{
	square1 := a + b
	square2 := b + c + d
	square3 := d + e + f
	square4 := f + g
	return square1 == square2 && square2 == square3 && square3 == square4
}
