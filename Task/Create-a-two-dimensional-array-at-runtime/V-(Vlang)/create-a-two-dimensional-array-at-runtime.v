import os

fn main() {
	// input
	mut row := os.input("enter rows: ").str()
	for elem in row {if elem.is_digit() == false {println('Input Error!') exit(1)}}
	mut col := os.input("enter cols: ").str()	
	for elem in col {if elem.is_digit() == false {println('Input Error!') exit(1)}}
	
	// create 2d array of specified size
	mut arr2d := [][]int{len: row.int(), init: []int{len: col.int()}}

	// assign values
	arr2d[0][0] = 7

	// view
	println(arr2d)

	// clear
	arr2d.clear()
}
