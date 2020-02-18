import std

// choleskyLower returns the cholesky decomposition of a symmetric real
// matrix.  The matrix must be positive definite but this is not checked
def choleskyLower(order, a) -> [float]:
    let l = map(a.length): 0.0
    var row, col = 1, 1
    var dr = 0 // index of diagonal element at end of row
    var dc = 0 // index of diagonal element at top of column
    for(a) e, i:
        if i < dr:
            let d = (e - l[i]) / l[dc]
            l[i] = d
            var ci, cx = col, dc
            var j = i + 1
            while j <= dr:
                cx += ci
                ci += 1
                l[j] += d * l[cx]
                j += 1
            col += 1
            dc += col
        else:
            l[i] = sqrt(e - l[i])
            row += 1
            dr += row
            col = 1
            dc = 0
    return l

// symmetric.print prints a square matrix from the packed representation,
// printing the upper triange as a transpose of the lower
def print_symmetric(order, s):
    //const eleFmt = "%10.5f "
    var str = ""
    var row, diag = 1, 0
    for(s) e, i:
        str += e + " " // format?
        if i == diag:
            var j, col = diag+row, row
            while col < order:
                str += s[j] + " " // format?
                col++
                j += col
            print(str); str = ""
            row += 1
            diag += row

// lower.print prints a square matrix from the packed representation,
// printing the upper triangle as all zeros.
def print_lower(order, l):
    //const eleFmt = "%10.5f "
    var str = ""
    var row, diag = 1, 0
    for(l) e, i:
        str += e + " " // format?
        if i == diag:
            var j = row
            while j < order:
                str += 0.0 + " " // format?
                j += 1
            print(str); str = ""
            row += 1
            diag += row

def demo(order, a):
    print("A:")
    print_symmetric(order, a)
    print("L:")
    print_lower(order, choleskyLower(order, a))

demo(3, [25.0,
         15.0, 18.0,
         -5.0, 0.0, 11.0])

demo(4, [18.0,
         22.0, 70.0,
         54.0, 86.0, 174.0,
         42.0, 62.0, 134.0, 106.0])
