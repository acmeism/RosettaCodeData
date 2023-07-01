package main

import "fmt"

func maxl(hm []int ) []int{
	res := make([]int,len(hm))
	max := 1
	for i := 0; i < len(hm);i++{
		if(hm[i] > max){
			max = hm[i]
		}
		res[i] = max;
	}
	return res
}
func maxr(hm []int ) []int{
	res := make([]int,len(hm))
	max := 1
	for i := len(hm) - 1 ; i >= 0;i--{
		if(hm[i] > max){
			max = hm[i]
		}
		res[i] = max;
	}
	return res
}
func min(a,b []int)  []int {
	res := make([]int,len(a))
	for i := 0; i < len(a);i++{
		if a[i] >= b[i]{
			res[i] = b[i]
		}else {
			res[i] = a[i]
		}
	}
	return res
}
func diff(hm, min []int) []int {
	res := make([]int,len(hm))
	for i := 0; i < len(hm);i++{
		if min[i] > hm[i]{
			res[i] = min[i] - hm[i]
		}
	}
	return res
}
func sum(a []int) int {
	res := 0
	for i := 0; i < len(a);i++{
		res += a[i]
	}
	return res
}

func waterCollected(hm []int) int {
	maxr := maxr(hm)
	maxl := maxl(hm)
	min := min(maxr,maxl)
	diff := diff(hm,min)
	sum := sum(diff)
	return sum
}


func main() {
	fmt.Println(waterCollected([]int{1, 5, 3, 7, 2}))
	fmt.Println(waterCollected([]int{5, 3, 7, 2, 6, 4, 5, 9, 1, 2}))
	fmt.Println(waterCollected([]int{2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1}))
	fmt.Println(waterCollected([]int{5, 5, 5, 5}))
	fmt.Println(waterCollected([]int{5, 6, 7, 8}))
	fmt.Println(waterCollected([]int{8, 7, 7, 6}))
	fmt.Println(waterCollected([]int{6, 7, 10, 7, 6}))
}
