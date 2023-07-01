import math

fn main() {
    aa := [1.0,0.5,0]
    bb := [1.0,0.5,0]
    mut res :=''

    for a in aa {
        res += '\tTernary_Not\t' + a.str() + '\t=\t' + ternary_not(a) + '\n'
    }
    res += '-------------\n'

    for a in aa {
        for b in bb {
            res += a.str() + '\tTernary_And\t' + b.str() + '\t=\t' + ternary_and(a,b) + '\n'
        }
    }
    res += '-------------\n'

    for a in aa {
        for b in bb {
            res += a.str() + '\tTernary_or\t' + b.str() + '\t=\t' + ternary_or(a,b) + '\n'
        }
    }
    res += '-------------\n'

    for a in aa {
        for b in bb {
            res += a.str() + '\tTernary_then\t' + b.str() + '\t=\t' + ternary_if_then(a,b) + '\n'
        }
    }
    res += '-------------\n'

    for a in aa {
        for b in bb {
            res += a.str() + '\tTernary_equiv\t' + b.str() + '\t=\t' + ternary_equiv(a,b) + '\n'
        }
    }
    res = res.replace('1.', 'true')
    res = res.replace('0.5', 'maybe')
    res = res.replace('0', 'false')
    println(res)
}

fn ternary_not(a f64) string {
    return math.abs(a-1).str()
}

fn ternary_and(a f64, b f64) string {
    return if a < b {a.str()} else {b.str()}
}

fn ternary_or(a f64, b f64) string {
    return if a > b {a.str()} else {b.str()}
}

fn ternary_if_then(a f64, b f64) string {
    return if a == 1 {b.str()} else if a == 0 {'1.'} else if a + b > 1 {'1.'} else {'0.5'}
}

fn ternary_equiv(a f64, b f64) string {
    return if a == b {'1.'} else if a == 1 {b.str()} else if b == 1 {a.str()} else {'0.5'}
}
