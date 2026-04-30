import math

struct JugglerResult {
	mut:
    cnt    i64
    max    i64
    maxidx i64
}

fn juggler(pir i64) JugglerResult {
    mut ir := pir
    mut res := JugglerResult{
        cnt: 0
        max: ir
        maxidx: 0
    }
    for ir != 1 {
        if ir % 2 == 0 { ir = i64(math.floor(math.sqrt(f64(ir)))) }
		else { ir = i64(math.floor(f64(ir) * math.sqrt(f64(ir)))) }
        res.cnt += 1
        if ir > res.max {
            res.max = ir
            res.maxidx = res.cnt
        }
    }
    return res
}

fn main() {
	println(" n  l[n]             h[n]  i[n]")
    println("-------------------------------------")
    for nir := i64(20); nir <= i64(39); nir++ {
        res := juggler(nir)
        println("${nir:3} ${res.cnt:3} ${res.max:16} ${res.maxidx:5}")
    }
}
