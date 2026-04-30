import strconv

struct FifteenSolver {
	mut:
    n      int
    n1     int
    n0     []int
    n2     []u64
    n3     []rune
    n4     []int
    xx     u64
}

const nr      = [3, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3]
const nc      = [3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2]
const i_flag  = 1
const g_flag  = 8
const e_flag  = 2
const l_flag  = 4
const fifteen = u64(15)

fn u64_from_hex(s string) u64 {
    return strconv.parse_uint(s, 16, 64) or { 0 }
}

fn (mut fs FifteenSolver) f_y() bool {
    if fs.n2[fs.n] == fs.xx { return true }
    if fs.n4[fs.n] <= fs.n1 { return fs.f_n() }
    return false
}

fn (mut fs FifteenSolver) f_i() {
    g := (11 - fs.n0[fs.n]) * 4
    a := fs.n2[fs.n] & (fifteen << g)
    fs.n0[fs.n + 1] = fs.n0[fs.n] + 4
    fs.n2[fs.n + 1] = fs.n2[fs.n] - a + (a << 16)
    fs.n3[fs.n + 1] = `d`
    fs.n4[fs.n + 1] = fs.n4[fs.n]
    cond := nr[(a >> g) & 0xF] <= (fs.n0[fs.n] >> 2)
    if !cond { fs.n4[fs.n + 1] = fs.n4[fs.n + 1] + 1 }
    fs.n++
}

fn (mut fs FifteenSolver) f_g() {
    g := (19 - fs.n0[fs.n]) * 4
    a := fs.n2[fs.n] & (fifteen << g)
    fs.n0[fs.n + 1] = fs.n0[fs.n] - 4
    fs.n2[fs.n + 1] = fs.n2[fs.n] - a + (a >> 16)
    fs.n3[fs.n + 1] = `u`
    fs.n4[fs.n + 1] = fs.n4[fs.n]
    cond := nr[(a >> g) & 0xF] >= (fs.n0[fs.n] >> 2)
    if !cond { fs.n4[fs.n + 1] = fs.n4[fs.n + 1] + 1 }
    fs.n++
}

fn (mut fs FifteenSolver) f_e() {
    g := (14 - fs.n0[fs.n]) * 4
    a := fs.n2[fs.n] & (fifteen << g)
    fs.n0[fs.n + 1] = fs.n0[fs.n] + 1
    fs.n2[fs.n + 1] = fs.n2[fs.n] - a + (a << 4)
    fs.n3[fs.n + 1] = `r`
    fs.n4[fs.n + 1] = fs.n4[fs.n]
    cond := nc[(a >> g) & 0xF] <= fs.n0[fs.n] % 4
    if !cond { fs.n4[fs.n + 1] = fs.n4[fs.n + 1] + 1 }
    fs.n++
}

fn (mut fs FifteenSolver) f_l() {
    g := (16 - fs.n0[fs.n]) * 4
    a := fs.n2[fs.n] & (fifteen << g)
    fs.n0[fs.n + 1] = fs.n0[fs.n] - 1
    fs.n2[fs.n + 1] = fs.n2[fs.n] - a + (a >> 4)
    fs.n3[fs.n + 1] = `l`
    fs.n4[fs.n + 1] = fs.n4[fs.n]
    cond := nc[(a >> g) & 0xF] >= fs.n0[fs.n] % 4
    if !cond { fs.n4[fs.n + 1] = fs.n4[fs.n + 1] + 1 }
    fs.n++
}

fn (mut fs FifteenSolver) f_z(w int) bool {
    if w & i_flag > 0 {
        fs.f_i()
        if fs.f_y() { return true }
        fs.n--
    }
    if w & g_flag > 0 {
        fs.f_g()
        if fs.f_y() { return true }
        fs.n--
    }
    if w & e_flag > 0 {
        fs.f_e()
        if fs.f_y() { return true }
        fs.n--
    }
    if w & l_flag > 0 {
        fs.f_l()
        if fs.f_y() { return true }
        fs.n--
    }
    return false
}

fn (mut fs FifteenSolver) f_n() bool {
    p0 := fs.n0[fs.n]
    p3 := fs.n3[fs.n]
    return match p0 {
        0 {
            if p3 == `l` { fs.f_z(i_flag) }
			else if p3 == `u` { fs.f_z(e_flag) }
			else { fs.f_z(i_flag + e_flag) }
        }
        3 {
            if p3 == `r` { fs.f_z(i_flag) }
			else if p3 == `u` { fs.f_z(l_flag) }
			else { fs.f_z(i_flag + l_flag) }
        }
        1, 2 {
            if p3 == `l` { fs.f_z(i_flag + l_flag) }
			else if p3 == `r` { fs.f_z(i_flag + e_flag) }
			else if p3 == `u` { fs.f_z(e_flag + l_flag) }
			else { fs.f_z(l_flag + e_flag + i_flag) }
        }
        12 {
            if p3 == `l` { fs.f_z(g_flag) }
			else if p3 == `d` { fs.f_z(e_flag) }
			else { fs.f_z(e_flag + g_flag) }
        }
        15 {
            if p3 == `r` { fs.f_z(g_flag) }
			else if p3 == `d` { fs.f_z(l_flag) }
			else { fs.f_z(g_flag + l_flag) }
        }
        13, 14 {
            if p3 == `l` { fs.f_z(g_flag + l_flag) }
			else if p3 == `r` { fs.f_z(e_flag + g_flag) }
			else if p3 == `d` { fs.f_z(e_flag + l_flag) }
			else { fs.f_z(g_flag + e_flag + l_flag) }
        }
        4, 8 {
            if p3 == `l` { fs.f_z(i_flag + g_flag) }
			else if p3 == `u` { fs.f_z(g_flag + e_flag) }
			else if p3 == `d` { fs.f_z(i_flag + e_flag) }
			else { fs.f_z(i_flag + g_flag + e_flag) }
        }
        7, 11 {
            if p3 == `d` { fs.f_z(i_flag + l_flag) }
			else if p3 == `u` { fs.f_z(g_flag + l_flag) }
			else if p3 == `r` { fs.f_z(i_flag + g_flag) }
			else { fs.f_z(i_flag + g_flag + l_flag) }
        }
        else {
            if p3 == `d` { fs.f_z(i_flag + e_flag + l_flag) }
			else if p3 == `l` { fs.f_z(i_flag + g_flag + l_flag) }
			else if p3 == `r` { fs.f_z(i_flag + g_flag + e_flag) }
			else if p3 == `u` { fs.f_z(g_flag + e_flag + l_flag) }
			else { fs.f_z(i_flag + g_flag + e_flag + l_flag) }
        }
    }
}

fn (mut fs FifteenSolver) fifteen_solver(n_val int, g_val u64) {
    fs.n0[0] = n_val
    fs.n2[0] = g_val
    fs.n4[0] = 0
}

fn (mut fs FifteenSolver) solve() {
    if fs.f_n() {
        println("Solution found in $fs.n moves: ")
        for g in 1 .. fs.n + 1 {
            print(fs.n3[g].str())
        }
        println("")
    } else {
        fs.n = 0
        fs.n1++
        fs.solve()
    }
}

fn main() {
    mut fs := FifteenSolver{
        n0: []int{len: 85, init: 0}
        n2: []u64{len: 85, init: 0}
        n3: []rune{len: 85, init: ` `}
        n4: []int{len: 85, init: 0}
        n: 0
        n1: 0
        xx: u64_from_hex("123456789abcdef0")
    }
    fs.fifteen_solver(8, u64_from_hex("fe169b4c0a73d852"))
    fs.solve()
}
