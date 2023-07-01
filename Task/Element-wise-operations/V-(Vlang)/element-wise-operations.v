import math

struct Matrix {
mut:
    ele    []f64
    stride int
}

fn matrix_from_rows(rows [][]f64) Matrix {
    if rows.len == 0 {
        return Matrix{[], 0}
    }
    mut m := Matrix{[]f64{len: rows.len*rows[0].len}, rows[0].len}
    for rx, row in rows {
		m.ele = m.ele[..rx*m.stride]
		m.ele << row
		m.ele << m.ele[(rx+1)*m.stride..]
    }
    return m
}

fn like(m Matrix) Matrix {
    return Matrix{[]f64{len: m.ele.len}, m.stride}
}

fn (m Matrix) str() string {
    mut s := ""
    for e := 0; e < m.ele.len; e += m.stride {
        s += "${m.ele[e..e+m.stride]} \n"
    }
    return s
}

type BinaryFunc64 = fn(f64, f64) f64

fn element_wise_mm(m1 Matrix, m2 Matrix, f BinaryFunc64) Matrix {
    mut z := like(m1)
    for i, m1e in m1.ele {
        z.ele[i] = f(m1e, m2.ele[i])
    }
    return z
}

fn element_wise_ms(m Matrix, s f64, f BinaryFunc64) Matrix {
    mut z := like(m)
    for i, e in m.ele {
        z.ele[i] = f(e, s)
    }
    return z
}

fn add(a f64, b f64) f64 { return a + b }
fn sub(a f64, b f64) f64 { return a - b }
fn mul(a f64, b f64) f64 { return a * b }
fn div(a f64, b f64) f64 { return a / b }
fn exp(a f64, b f64) f64 { return math.pow(a, b) }

fn add_matrix(m1 Matrix, m2 Matrix) Matrix { return element_wise_mm(m1, m2, add) }
fn sub_matrix(m1 Matrix, m2 Matrix) Matrix { return element_wise_mm(m1, m2, sub) }
fn mul_matrix(m1 Matrix, m2 Matrix) Matrix { return element_wise_mm(m1, m2, mul) }
fn div_matrix(m1 Matrix, m2 Matrix) Matrix { return element_wise_mm(m1, m2, div) }
fn exp_matrix(m1 Matrix, m2 Matrix) Matrix { return element_wise_mm(m1, m2, exp) }

fn add_scalar(m Matrix, s f64) Matrix { return element_wise_ms(m, s, add) }
fn sub_scalar(m Matrix, s f64) Matrix { return element_wise_ms(m, s, sub) }
fn mul_scalar(m Matrix, s f64) Matrix { return element_wise_ms(m, s, mul) }
fn div_scalar(m Matrix, s f64) Matrix { return element_wise_ms(m, s, div) }
fn exp_scalar(m Matrix, s f64) Matrix { return element_wise_ms(m, s, exp) }

fn h(heading string, m Matrix) {
    println(heading)
    print(m)
}

fn main() {
    m1 := matrix_from_rows([[f64(3), 1, 4], [f64(1), 5, 9]])
    m2 := matrix_from_rows([[f64(2), 7, 1], [f64(8), 2, 8]])
    h("m1:", m1)
    h("m2:", m2)
    println('')
    h("m1 + m2:", add_matrix(m1, m2))
    h("m1 - m2:", sub_matrix(m1, m2))
    h("m1 * m2:", mul_matrix(m1, m2))
    h("m1 / m2:", div_matrix(m1, m2))
    h("m1 ^ m2:", exp_matrix(m1, m2))
    println('')
    s := .5
    println("s: $s")
    h("m1 + s:", add_scalar(m1, s))
    h("m1 - s:", sub_scalar(m1, s))
    h("m1 * s:", mul_scalar(m1, s))
    h("m1 / s:", div_scalar(m1, s))
    h("m1 ^ s:", exp_scalar(m1, s))
}
