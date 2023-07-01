import math
import arrays

fn hist(source string) map[string]int {
    mut hist := map[string]int{}
    for e in source.split('') {
        if e !in hist {
            hist[e] = 0
        }
        hist[e]+=1
    }
    return hist
}

fn entropy(hist map[string]int, l int) f64 {
    mut elist := []f64{}
    for _,v in hist {
        c := f64(v) / f64(l)
        elist << -c * math.log2(c)
    }
    return arrays.sum<f64>(elist) or {-1}
}

fn main(){
    input := "1223334444"
    h := hist(input)
    e := entropy(h, input.len)
    println(e)
}
