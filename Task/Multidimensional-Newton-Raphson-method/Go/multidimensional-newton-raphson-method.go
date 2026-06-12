package main

import (
    "fmt"
    "math"
)

type vector = []float64
type matrix []vector
type fun = func(vector) float64
type funs = []fun
type jacobian = []funs

func (m1 matrix) mul(m2 matrix) matrix {
    rows1, cols1 := len(m1), len(m1[0])
    rows2, cols2 := len(m2), len(m2[0])
    if cols1 != rows2 {
        panic("Matrices cannot be multiplied.")
    }
    result := make(matrix, rows1)
    for i := 0; i < rows1; i++ {
        result[i] = make(vector, cols2)
        for j := 0; j < cols2; j++ {
            for k := 0; k < rows2; k++ {
                result[i][j] += m1[i][k] * m2[k][j]
            }
        }
    }
    return result
}

func (m1 matrix) sub(m2 matrix) matrix {
    rows, cols := len(m1), len(m1[0])
    if rows != len(m2) || cols != len(m2[0]) {
        panic("Matrices cannot be subtracted.")
    }
    result := make(matrix, rows)
    for i := 0; i < rows; i++ {
        result[i] = make(vector, cols)
        for j := 0; j < cols; j++ {
            result[i][j] = m1[i][j] - m2[i][j]
        }
    }
    return result
}

func (m matrix) transpose() matrix {
    rows, cols := len(m), len(m[0])
    trans := make(matrix, cols)
    for i := 0; i < cols; i++ {
        trans[i] = make(vector, rows)
        for j := 0; j < rows; j++ {
            trans[i][j] = m[j][i]
        }
    }
    return trans
}

func (m matrix) inverse() matrix {
    le := len(m)
    for _, v := range m {
        if len(v) != le {
            panic("Not a square matrix")
        }
    }
    aug := make(matrix, le)
    for i := 0; i < le; i++ {
        aug[i] = make(vector, 2*le)
        copy(aug[i], m[i])
        // augment by identity matrix to right
        aug[i][i+le] = 1
    }
    aug.toReducedRowEchelonForm()
    inv := make(matrix, le)
    // remove identity matrix to left
    for i := 0; i < le; i++ {
        inv[i] = make(vector, le)
        copy(inv[i], aug[i][le:])
    }
    return inv
}

// note: this mutates the matrix in place
func (m matrix) toReducedRowEchelonForm() {
    lead := 0
    rowCount, colCount := len(m), len(m[0])
    for r := 0; r < rowCount; r++ {
        if colCount <= lead {
            return
        }
        i := r

        for m[i][lead] == 0 {
            i++
            if rowCount == i {
                i = r
                lead++
                if colCount == lead {
                    return
                }
            }
        }

        m[i], m[r] = m[r], m[i]
        if div := m[r][lead]; div != 0 {
            for j := 0; j < colCount; j++ {
                m[r][j] /= div
            }
        }

        for k := 0; k < rowCount; k++ {
            if k != r {
                mult := m[k][lead]
                for j := 0; j < colCount; j++ {
                    m[k][j] -= m[r][j] * mult
                }
            }
        }
        lead++
    }
}

func solve(fs funs, jacob jacobian, guesses vector) vector {
    size := len(fs)
    var gu1 vector
    gu2 := make(vector, len(guesses))
    copy(gu2, guesses)
    jac := make(matrix, size)
    for i := 0; i < size; i++ {
        jac[i] = make(vector, size)
    }
    tol := 1e-8
    maxIter := 12
    iter := 0
    for {
        gu1 = gu2
        g := matrix{gu1}.transpose()
        t := make(vector, size)
        for i := 0; i < size; i++ {
            t[i] = fs[i](gu1)
        }
        f := matrix{t}.transpose()
        for i := 0; i < size; i++ {
            for j := 0; j < size; j++ {
                jac[i][j] = jacob[i][j](gu1)
            }
        }
        g1 := g.sub(jac.inverse().mul(f))
        gu2 = make(vector, size)
        for i := 0; i < size; i++ {
            gu2[i] = g1[i][0]
        }
        iter++
        any := false
        for i, v := range gu2 {
            if math.Abs(v)-gu1[i] > tol {
                any = true
                break
            }
        }
        if !any || iter >= maxIter {
            break
        }
    }
    return gu2
}

func main() {
    /*
       solve the two non-linear equations:
       y = -x^2 + x + 0.5
       y + 5xy = x^2
       given initial guesses of x = y = 1.2

       Example taken from:
       http://www.fixoncloud.com/Home/LoginValidate/OneProblemComplete_Detailed.php?problemid=286

       Expected results: x = 1.23332, y = 0.2122
    */
    f1 := func(x vector) float64 { return -x[0]*x[0] + x[0] + 0.5 - x[1] }
    f2 := func(x vector) float64 { return x[1] + 5*x[0]*x[1] - x[0]*x[0] }
    fs := funs{f1, f2}
    jacob := jacobian{
        funs{
            func(x vector) float64 { return -2*x[0] + 1 },
            func(x vector) float64 { return -1 },
        },
        funs{
            func(x vector) float64 { return 5*x[1] - 2*x[0] },
            func(x vector) float64 { return 1 + 5*x[0] },
        },
    }
    guesses := vector{1.2, 1.2}
    sol := solve(fs, jacob, guesses)
    fmt.Printf("Approximate solutions are x = %.7f,  y = %.7f\n", sol[0], sol[1])

    /*
       solve the three non-linear equations:
       9x^2 + 36y^2 + 4z^2 - 36 = 0
       x^2 - 2y^2 - 20z = 0
       x^2 - y^2 + z^2 = 0
       given initial guesses of x = y = 1.0 and z = 0.0

       Example taken from:
       http://mathfaculty.fullerton.edu/mathews/n2003/FixPointNewtonMod.html (exercise 5)

       Expected results: x = 0.893628, y = 0.894527, z = -0.0400893
    */

    fmt.Println()
    f3 := func(x vector) float64 { return 9*x[0]*x[0] + 36*x[1]*x[1] + 4*x[2]*x[2] - 36 }
    f4 := func(x vector) float64 { return x[0]*x[0] - 2*x[1]*x[1] - 20*x[2] }
    f5 := func(x vector) float64 { return x[0]*x[0] - x[1]*x[1] + x[2]*x[2] }
    fs = funs{f3, f4, f5}
    jacob = jacobian{
        funs{
            func(x vector) float64 { return 18 * x[0] },
            func(x vector) float64 { return 72 * x[1] },
            func(x vector) float64 { return 8 * x[2] },
        },
        funs{
            func(x vector) float64 { return 2 * x[0] },
            func(x vector) float64 { return -4 * x[1] },
            func(x vector) float64 { return -20 },
        },
        funs{
            func(x vector) float64 { return 2 * x[0] },
            func(x vector) float64 { return -2 * x[1] },
            func(x vector) float64 { return 2 * x[2] },
        },
    }
    guesses = vector{1, 1, 0}
    sol = solve(fs, jacob, guesses)
    fmt.Printf("Approximate solutions are x = %.7f,  y = %.7f,  z = %.7f\n", sol[0], sol[1], sol[2])
}
