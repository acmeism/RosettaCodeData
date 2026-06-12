import math

const n = 6000

fn main() {
    mut p := []bool{len:n, init:false}
    for i in 2..int(math.round(math.pow(n,.5))) {
        if !p[i] {
            for j:=i*2;j<n;j+=i {
                p[j] = true
            }
        }
    }
    for i in 3..n {
        if p[i-1] || p[i+3] || p[i+5] {
            continue
        }
        else {
            println('$i : ${i-1} ${i+3} ${i+5}')
        }
    }
}
