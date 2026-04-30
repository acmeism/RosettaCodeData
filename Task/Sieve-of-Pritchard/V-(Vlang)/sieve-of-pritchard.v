import math

struct SievePritchard {
	mut:
	members    []bool
	primes     []int
	limit      int
	steplength int
	add_cnt    int
	rem_cnt    int
}

fn (mut sp SievePritchard) pritchard(verbose bool) []int {
	sp.primes = []int{}
	sp.members = []bool{len: sp.limit + 1, cap: sp.limit + 1}
	sp.members[1] = true
	sp.steplength = 1 // wheel size
	sp.add_cnt, sp.rem_cnt = 2, 1
	rtlim := int(math.sqrt(f64(sp.limit)))
	mut prime, mut np, mut nir := 2, 0, 0
	mut nlimit := prime * sp.steplength // wheel limit
	mut newprimes  := []int{}
	for prime < rtlim {
		if sp.steplength < sp.limit {
			for wir := 1; wir <= sp.steplength; wir++ {
				if sp.members[wir] {
					nir = wir + sp.steplength
					for nir <= nlimit {
						sp.members[nir] = true
						sp.add_cnt++
						nir += sp.steplength
					}
				}
			}
			sp.steplength = nlimit // advance wheel size
		}
		np = 5
		mcopy := sp.members.clone()
		for wir := 1; wir <= nlimit; wir++ {
			if mcopy[wir] {
				if np == 5 && wir > prime { np = wir }
				nir = prime * wir
				if nir > nlimit { break }
				sp.rem_cnt++
				sp.members[nir] = false
			}
		}
		if np < prime { break }
		sp.primes << prime
		if prime == 2 { prime = 3 } else { prime = np }
		nlimit = sp.steplength * prime // advance wheel limit
		if nlimit > sp.limit { nlimit = sp.limit }
	}
	sp.members[1] = false
	newprimes.clear()
	for i := 2; i <= sp.limit; i++ {
		if sp.members[i] { newprimes << i }
	}
	if verbose {
		print("up to ${sp.limit}, added ${sp.add_cnt}, removed ${sp.rem_cnt}, ")
		println("prime count ${sp.primes.len + newprimes.len}")
	}
	for pal in newprimes {
		sp.primes << pal
	}
	return sp.primes
}

fn main() {
	mut sieve := SievePritchard{limit: 150}
	mut sieve_verbose := SievePritchard{limit: 1_000_000}
	primes := sieve.pritchard(false)
	println(primes)
	sieve_verbose.pritchard(true)
}
