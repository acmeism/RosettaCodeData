import math

// Symmetric and Lower use a packed representation that stores only
// the Lower triangle.

struct Symmetric {
    order int
    ele   []f64
}

struct Lower  {
mut:
    order int
    ele   []f64
}

// Symmetric.print prints a square matrix from the packed representation,
// printing the upper triange as a transpose of the Lower.
fn (s Symmetric) print() {
    mut row, mut diag := 1, 0
    for i, e in s.ele {
        print("${e:10.5f} ")
        if i == diag {
            for j, col := diag+row, row; col < s.order; j += col {
                print("${s.ele[j]:10.5f} ")
                col++
            }
            println('')
            row++
            diag += row
        }
    }
}

// Lower.print prints a square matrix from the packed representation,
// printing the upper triangle as all zeros.
fn (l Lower) print() {
    mut row, mut diag := 1, 0
    for i, e in l.ele {
        print("${e:10.5f} ")
        if i == diag {
            for _ in row..l.order {
                print("${0.0:10.5f} ")
            }
            println('')
            row++
            diag += row
        }
    }
}

// cholesky_lower returns the cholesky decomposition of a Symmetric real
// matrix.  The matrix must be positive definite but this is not checked.
fn (a Symmetric) cholesky_lower() Lower {
    mut l := Lower{a.order, []f64{len: a.ele.len}}
    mut row, mut col := 1, 1
    mut dr := 0 // index of diagonal element at end of row
    mut dc := 0 // index of diagonal element at top of column
    for i, e in a.ele {
        if i < dr {
            d := (e - l.ele[i]) / l.ele[dc]
            l.ele[i] = d
            mut ci, mut cx := col, dc
            for j := i + 1; j <= dr; j++ {
                cx += ci
                ci++
                l.ele[j] += d * l.ele[cx]
            }
            col++
            dc += col
        } else {
            l.ele[i] = math.sqrt(e - l.ele[i])
            row++
            dr += row
            col = 1
            dc = 0
        }
    }
    return l
}

fn main() {
    demo(Symmetric{3, [
        f64(25),
        15, 18,
        -5, 0, 11]})
    demo(Symmetric{4, [
        f64(18),
        22, 70,
        54, 86, 174,
        42, 62, 134, 106]})
}

fn demo(a Symmetric) {
    println("A:")
    a.print()
    println("L:")
    a.cholesky_lower().print()
}
