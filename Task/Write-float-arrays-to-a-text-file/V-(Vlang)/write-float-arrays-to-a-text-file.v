import os
const (
    x = [1.0, 2, 3, 1e11]
    y = [1.0, 1.4142135623730951, 1.7320508075688772, 316227.76601683791]

    xprecision = 3
    yprecision = 5
)

fn main() {
    if x.len != y.len {
        println("x, y different length")
        return
    }
    mut f := os.create("filename")?
    defer {
        f.close()
    }
    for i,_ in x {
        f.write_string('${x[i]:3}, ${y[i]:1G}\n')?
    }
}
