struct HeapsAlgorithm {}

fn (mut ha HeapsAlgorithm) recursive(mut array []int) {
    ha.is_recursive(mut array, array.len, true)
}

fn (mut ha HeapsAlgorithm) is_recursive(mut array []int, nir int, plus bool) {
    if nir == 1 { ha.is_output(array, plus) }
	else {
        for ial := 0; ial < nir; ial++ {
            ha.is_recursive(mut array, nir - 1, ial == 0)
            if nir % 2 == 0 { ha.is_swap(mut array, ial, nir - 1) }
			else { ha.is_swap(mut array, 0, nir - 1) }
        }
    }
}

fn (mut ha HeapsAlgorithm) is_output(array []int, plus bool) {
    mut sign := " -1"
    if plus { sign = " +1" }
    println("${array} $sign")
}

fn (mut ha HeapsAlgorithm) is_swap(mut array []int, air int, bir int) {
    temp := array[air]
    array[air] = array[bir]
    array[bir] = temp
}

fn (mut ha HeapsAlgorithm) loop(mut array []int) {
    ha.is_loop(mut array, array.len)
}

fn (mut ha HeapsAlgorithm) is_loop(mut array []int, nir int) {
    mut cay := []int{len: nir, init: 0}
    mut plus := false
    mut ir := 0
    ha.is_output(array, true)	
    for ir < nir {
        if cay[ir] < ir {
            if ir % 2 == 0 { ha.is_swap(mut array, 0, ir) }
			else { ha.is_swap(mut array, cay[ir], ir) }
            ha.is_output(array, plus)
            plus = !plus
            cay[ir]++
            ir = 0
        }
		else {
            cay[ir] = 0
            ir++
        }
    }
}

fn main() {
    mut array := [0, 1, 2, 3]
    mut algorithm := HeapsAlgorithm{}
    algorithm.recursive(mut array)
    println("")
    algorithm.loop(mut array)
}
