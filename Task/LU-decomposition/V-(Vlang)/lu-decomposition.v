type Vector = []f64
type Matrix = [][]f64

fn matrix_multiply(amx Matrix, bmx Matrix) Matrix {
	rows1 := amx.len
	cols1 := amx[0].len
	rows2 := bmx.len
	cols2 := bmx[0].len
	assert cols1 == rows2
	mut result := [][]f64{len: rows1, init: []f64{len: cols2, init: 0.0}}
	mut sum := f64(0)
	for ial in 0 .. rows1 {
		for jal in 0 .. cols2 {
			sum = 0.0
			for kal in 0 .. rows2 {
				sum += amx[ial][kal] * bmx[kal][jal]
			}
			result[ial][jal] = sum
		}
	}
	return result
}

fn pivotize(mx Matrix) Matrix {
	nir := mx.len
	mut imx := [][]f64{len: nir, init: []f64{len: nir, init: 0.0}}
	mut max, mut row := f64(0), 0
	for ial in 0 .. nir {
		imx[ial][ial] = 1.0
	}
	for ial in 0 .. nir {
		max = mx[ial][ial]
		row = ial
		for jal in ial .. nir {
			if mx[jal][ial] > max {
				max = mx[jal][ial]
				row = jal
			}
		}
		if ial != row { imx[ial], imx[row] = imx[row], imx[ial] }
	}
	return imx
}

fn lu(amx Matrix) (Matrix, Matrix, Matrix) {
	nir := amx.len
	mut lmx := [][]f64{len: nir, init: []f64{len: nir, init: 0.0}}
	mut umx := [][]f64{len: nir, init: []f64{len: nir, init: 0.0}}
	mut sum, mut sum2 := f64(0), f64(0)
	pmx := pivotize(amx)
	a2 := matrix_multiply(pmx, amx)

	for jal in 0 .. nir {
		lmx[jal][jal] = 1.0
		for ial in 0 .. jal + 1 {
			sum = 0.0
			for kal in 0 .. ial {
				sum += umx[kal][jal] * lmx[ial][kal]
			}
			umx[ial][jal] = a2[ial][jal] - sum
		}
		for ial in jal .. nir {
			sum2 = 0.0
			for kal in 0 .. jal {
				sum2 += umx[kal][jal] * lmx[ial][kal]
			}
			lmx[ial][jal] = (a2[ial][jal] - sum2) / umx[jal][jal]
		}
	}
	return lmx, umx, pmx
}

fn print_matrix(title string, mx Matrix, fsg string) {
	nir := mx.len
	println("\n$title\n")
	for ial in 0 .. nir {
		for jal in 0 .. nir {
			match fsg {
				"%8.5f" { print("${mx[ial][jal]:8.5f}  ") }
				"%7.5f" { print("${mx[ial][jal]:7.5f}  ") }
				"%2.0f" { print("${mx[ial][jal]:2}  ") }
				"%1.0f" { print("${mx[ial][jal]:1}  ") }
				else { print("${mx[ial][jal]}  ") }
			}		
		}
		println("")
	}
}

fn main() {
	a1 := [
		[1.0, 3.0, 5.0],
		[2.0, 4.0, 7.0],
		[1.0, 1.0, 0.0],
	]
	l1, u1, p1 := lu(a1)
	println("EXAMPLE 1:-")
	print_matrix("A:", a1, "%1.0f")
	print_matrix("L:", l1, "%8.5f")
	print_matrix("U:", u1, "%8.5f")
	print_matrix("P:", p1, "%1.0f")
	a2 := [
		[11.0, 9.0, 24.0, 2.0],
		[1.0, 5.0, 2.0, 6.0],
		[3.0, 17.0, 18.0, 1.0],
		[2.0, 5.0, 7.0, 1.0],
	]
	l2, u2, p2 := lu(a2)
	println("\nEXAMPLE 2:-")
	print_matrix("A:", a2, "%2.0f")
	print_matrix("L:", l2, "%7.5f")
	print_matrix("U:", u2, "%8.5f")
	print_matrix("P:", p2, "%1.0f")
}
