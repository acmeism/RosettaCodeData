struct PancakeSolver {
	nir int
    mut:
	fact        []int
	visited     []bool
	dist        []int
	perm_string []string
	queue       []string
}

fn flip_string(s string, k int) string {
	mut res := ""
	for ial := k - 1; ial >= 0; ial-- {
		res += s[ial].ascii_str()
	}
	if k < s.len { res += s[k..] }
	return res
}

fn (ps PancakeSolver) permutation_rank(s string) int {
	mut rank := 0
	for ial := 0; ial < ps.nir - 1; ial++ {
		mut cnt := 0
		for j := ial + 1; j < ps.nir; j++ {
			if s[j] < s[ial] { cnt++ }
		}
		rank += cnt * ps.fact[ps.nir - ial - 1]
	}
	return rank
}

fn new_pancake_solver(pir int) PancakeSolver {
	mut vact := []int{len: pir + 1}
	vact[0] = 1
	for ial := 1; ial <= pir; ial++ {
		vact[ial] = vact[ial - 1] * ial
	}
	total_states := vact[pir]
	return PancakeSolver{
		nir: pir
		fact: vact
		visited: []bool{len: total_states}
		dist: []int{len: total_states}
		perm_string: []string{len: total_states}
		queue: []string{len: total_states}
	}
}

fn (mut ps PancakeSolver) pancake_number() {
	mut max_dist, mut head, mut tail := 0, 0, 1
	mut max_perm, mut start := "", ""
	mut ordered_parts := []string{}
	for ial := 1; ial <= ps.nir; ial++ {
		start += ial.str()
	}
	start_rank := ps.permutation_rank(start)
	ps.visited[start_rank] = true
	ps.dist[start_rank] = 0
	ps.perm_string[start_rank] = start
	ps.queue[0] = start
	for head < tail {
		pir := ps.queue[head]
		head++
		current_rank := ps.permutation_rank(pir)
		for ial := 2; ial <= ps.nir; ial++ {
			qir := flip_string(pir, ial)
			rir := ps.permutation_rank(qir)
			if !ps.visited[rir] {
				ps.visited[rir] = true
				ps.dist[rir] = ps.dist[current_rank] + 1
				ps.perm_string[rir] = qir
				ps.queue[tail] = qir
				tail++
			}
		}
	}
	for idx, val in ps.visited {
		if val && ps.dist[idx] > max_dist {
			max_dist = ps.dist[idx]
			max_perm = ps.perm_string[idx]
		}
	}
	if max_perm.len == 0 {
		for ial := 1; ial <= ps.nir; ial++ {
			max_perm += ial.str()
		}
	}
	max_perm_formatted := max_perm.split("").join("; ")
	for ial := 1; ial <= ps.nir; ial++ {
		ordered_parts << ial.str()
	}
	ordered := ordered_parts.join("; ")
	print("Maximum number of flips to sort ${ps.nir} ")
	println("elements is  ${max_dist}. e.g [${max_perm_formatted}] -> [${ordered}]")
}

fn main() {
	for nal := 1; nal <= 9; nal++ {
		mut solver := new_pancake_solver(nal)
		solver.pancake_number()
	}
}
