struct MultiplicationTable {
    mut:
    nir int
    nir_size int
}

fn (mut mt MultiplicationTable) fsize(xir int, nir int) string {
    sg := xir.str()
    return sg + " ".repeat(nir - sg.len)
}

fn (mut mt MultiplicationTable) multiplication_table() {
    print(" ".repeat(mt.nir_size) + "|")
    for tir := 1; tir <= mt.nir; tir++ {
        print(mt.fsize(tir, mt.nir_size))
    }
    println("")
    println("----+" + "-".repeat(mt.nir_size * mt.nir))
    for t1 := 1; t1 <= mt.nir; t1++ {
        print(mt.fsize(t1, mt.nir_size) + "|")
        for t2 := 1; t2 <= mt.nir; t2++ {
            if t2 >= t1 { print(mt.fsize(t1 * t2, mt.nir_size)) }
			else { print(" ".repeat(mt.nir_size)) }
        }
        println("")
    }
}

fn main() {
    mut mt := MultiplicationTable{12, 4}
    mt.multiplication_table()
}
