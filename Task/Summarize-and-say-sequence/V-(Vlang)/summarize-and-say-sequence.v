import arrays

const limit = 1_000_000

struct SelfRefSeqSolver {
	mut:
    sb       []u8
    sieve    []int
    limit    int
}

fn new_self_ref_seq_solver(limit int) SelfRefSeqSolver {
    return SelfRefSeqSolver{
        sb: []u8{cap: 20}
        sieve: []int{len: limit, init: 0}
        limit: limit
    }
}

fn (mut s SelfRefSeqSolver) clear_sb() {
    unsafe { s.sb.len = 0 }
}

fn (mut s SelfRefSeqSolver) append_sb(str string) {
    for b in str.bytes() {
        s.sb << b
    }
}

fn (s &SelfRefSeqSolver) sb_to_string() string {
    return s.sb.bytestr()
}

fn (s &SelfRefSeqSolver) contains_char(str string, c u8) bool {
    for b in str.bytes() {
        if b == c { return true }
    }
    return false
}

fn (s &SelfRefSeqSolver) count_char(str string, c u8) int {
    mut cnt := 0
    for b in str.bytes() {
        if b == c { cnt++ }
    }
    return cnt
}

fn (mut s SelfRefSeqSolver) self_ref_seq(str string) string {
    s.clear_sb()
    for d := u8(`9`); d >= u8(`0`); d-- {
        if !s.contains_char(str, d) { continue }
        count := s.count_char(str, d)
        s.append_sb(count.str())
        s.append_sb(d.ascii_str())
    }
    return s.sb_to_string()
}

fn permute(input []u8) [][]u8 {
	mut perms := [][]u8{}
    if input.len == 1 { return [input] }
    to_insert := input[0]
    for perm in permute(input[1..]) {
        for i in 0 .. perm.len + 1 {
            mut new_perm := perm.clone()
            new_perm.insert(i, to_insert)
            perms << new_perm
        }
    }
    return perms
}

fn main() {
    mut solver := new_self_ref_seq_solver(limit)
	mut seen := map[string]bool{}
    mut elements := []string{}
	mut next := ""

    for n := 1; n < solver.limit; n++ {
        if solver.sieve[n] > 0 { continue }
        elements.clear()
        next = n.str()
        elements << next

        for {
            next = solver.self_ref_seq(next)
            if next in elements {
                size := elements.len
                solver.sieve[n] = size

                if n > 9 {
                    perms := permute(n.str().bytes())
                    seen.clear()
                    for perm in perms {
                        s := perm.bytestr()
                        if s[0] == `0` || s in seen { continue }
                        seen[s] = true
                        k := s.int()
                        if k < solver.limit { solver.sieve[k] = size }
                    }
                }
                break
            }
            elements << next
        }
    }
	max_iterations := arrays.max(solver.sieve)!
    for n := 1; n < solver.limit; n++ {
        if solver.sieve[n] < max_iterations { continue }
        println("$n -> Iterations = $max_iterations")
        next = n.str()
        for _ in 1 .. max_iterations + 1 {
            println(next)
            next = solver.self_ref_seq(next)
        }
        println("")
    }
}
