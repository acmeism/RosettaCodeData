smd := [][]string{len: 4, init: []string{len:2, init: 'Hello'}}
imd := [][]int{len: 3, init: []int{len:4, init: it}}
mut mmd := [][]f64{len: 5, init: []f64{len: 5}}
mmd[0][2] = 2.0
mmd[1][3] = 4.2
mmd[2][4] = 1.8
mmd[3][0] = 5.0
mut omd := [][]bool{} // initialize without defining size
omd << [true, false, true]
println(smd)
println(imd)
println(mmd)
println(omd)
