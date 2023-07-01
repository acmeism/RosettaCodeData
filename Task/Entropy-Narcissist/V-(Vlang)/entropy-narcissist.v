import os
import math

fn main() {
    println("Binary file entropy: ${entropy(os.args[0])?}")
}

fn entropy(file string) ?f64 {
    d := os.read_bytes(file)?

    mut f := [256]f64{}
    for b in d {
        f[b]++
    }
    mut hm := 0.0
    for c in f {
        if c > 0 {
            hm += c * math.log2(c)
        }
    }
    l := f64(d.len)
    return math.log2(l) - hm/l
}
