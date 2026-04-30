const max = 12

struct SuperPerm {
	mut:
    sp    []rune
    count []int
    pos   int
}

fn fact_sum(nir int) int {
    mut sir, mut xir, mut fir := 0, 0, 1
    for xir < nir {
        xir++
        fir *= xir
        sir += fir
    }
    return sir
}

fn (mut spm SuperPerm) rbl(nir int) bool {
    if nir == 0 { return false }
    cir := spm.sp[spm.pos - nir]
    spm.count[nir]--
    if spm.count[nir] == 0 {
        spm.count[nir] = nir
        if !spm.rbl(nir - 1) { return false }
    }
    spm.sp[spm.pos] = cir
    spm.pos++
    return true
}

fn (mut spm SuperPerm) super_perm(nir int) {
    spm.pos = nir
    len := fact_sum(nir)
    if len > 0 { spm.sp = []rune{len: len} }
    for ial in 0 .. max {
        spm.count[ial] = ial
    }
    for ial in 1 .. nir + 1 {
        spm.sp[ial - 1] = rune(`0` + ial)
    }
    for spm.rbl(nir) {}
}

fn main() {
    mut spm := SuperPerm{count: []int{len: max}}
    for nal in 0 .. max {
        spm.super_perm(nal)
        println("superPerm(${nal:2d}) len = ${spm.sp.len}")
    }
}
