const int_max = max_int // builtin const

struct MatrixChain {
	mut:
	may [][]int
	say [][]int
	dim []int
	nir int
}

fn (mut mc MatrixChain) mat_chain_order() {
	mc.may = [][]int{len: mc.nir, init: []int{len: mc.nir, init: 0}}
	mc.say = [][]int{len: mc.nir, init: []int{len: mc.nir, init: 0}}
	for ial in 0 .. mc.nir {
		mc.may[ial][ial] = 0
	}
	for length in 2 .. mc.nir + 1 {
		for ial in 0 .. mc.nir - length + 1 {
			jir := ial + length - 1
			mc.may[ial][jir] = int_max
			for kal in ial .. jir {
				cost := mc.may[ial][kal] + mc.may[kal + 1][jir]
				+ mc.dim[ial] * mc.dim[kal + 1] * mc.dim[jir + 1]
				if cost < mc.may[ial][jir] {
					mc.may[ial][jir] = cost
					mc.say[ial][jir] = kal
				}
			}
		}
	}
}

fn (mut mc MatrixChain) path(air int, bir int) string {
	if air == bir { return (rune(65 + air)).str() }
	return "(" + mc.path(air, mc.say[air][bir]) + mc.path(mc.say[air][bir] + 1, bir) + ")"
}

fn (mut mc MatrixChain) pr_chain_order() {
	println("Order : " + mc.path(0, mc.nir - 1))
}

fn main() {
	dims_2d := [
		[5, 6, 3, 1],
		[1, 5, 25, 30, 100, 70, 2, 1, 100, 250, 1, 1000, 2],
		[1000, 1, 500, 12, 1, 700, 2500, 3, 2, 5, 14, 10],
	]
	mut mc := &MatrixChain{}
	for dims in dims_2d {
		mc.dim = dims
		mc.nir = dims.len - 1
		println("Dims  : $dims")
		mc.mat_chain_order()
		mc.pr_chain_order()
		println("Cost  : ${mc.may[0][mc.nir - 1]}")
		println("")
	}
}
