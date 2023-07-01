import math

const (
minus_inf = math.inf(-1)
)

struct MaxTropical { r f64 }

fn new_max_tropical(r f64) ?MaxTropical {
    if math.is_inf(r, 1) || math.is_nan(r) {
        return error("Argument must be a real number or negative infinity.")
    }
    return MaxTropical{r}
}

fn (t MaxTropical) eq(other MaxTropical) bool {
    return t.r == other.r
}

// equivalent to ⊕ operator
fn (t MaxTropical) add(other MaxTropical) ?MaxTropical {
    if t.r == minus_inf {
        return other
    }
    if other.r == minus_inf {
        return t
    }
    return new_max_tropical(math.max(t.r, other.r))
}

// equivalent to ⊗ operator
fn (t MaxTropical) mul(other MaxTropical) ?MaxTropical {
    if t.r == 0 {
        return other
    }
    if other.r == 0 {
        return t
    }
    return new_max_tropical(t.r + other.r)
}

// exponentiation fntion
fn (t MaxTropical) pow(e int) ?MaxTropical {
    if e < 1 {
        return error("Exponent must be a positive integer.")
    }
    if e == 1 {
        return t
    }
    mut p := t
    for i := 2; i <= e; i++ {
        p = p.mul(t)?
    }
    return p
}

fn (t MaxTropical) str() string {
    return '${t.r}'
}

fn main() {
    // 0 denotes ⊕ and 1 denotes ⊗
    data := [
        [2.0, -2, 1],
        [-0.001, minus_inf, 0],
        [0.0, minus_inf, 1],
        [1.5, -1, 0],
        [-0.5, 0, 1],
    ]
    for d in data {
        a := new_max_tropical(d[0])?
        b := new_max_tropical(d[1])?
        c := a.add(b)?
        m := a.mul(b)?
        if d[2] == 0 {
            println("$a ⊕ $b = $c")
        } else {
            println("$a ⊗ $b = $m")
        }
    }

    c := new_max_tropical(5)?
    println("$c ^ 7 = ${c.pow(7)}")

    d := new_max_tropical(8)?
    e := new_max_tropical(7)?
    f := c.mul(d.add(e)?)?
    g := c.mul(d)?.add(c.mul(e)?)?
    println("$c ⊗ ($d ⊕ $e) = $f")
    println("$c ⊗ $d ⊕ $c ⊗ $e = $g")
    println("$c ⊗ ($d ⊕ $e) == $c ⊗ $d ⊕ $c ⊗ $e is ${f.eq(g)}")
}
