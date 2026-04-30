import math

struct Splitmix64 {
	mut:
    state u64
}

fn splitmix64_new(state u64) &Splitmix64 {
    return &Splitmix64{state: state}
}

fn (mut sm64 Splitmix64) next_int() u64 {
    sm64.state += 0x9e3779b97f4a7c15
    mut z := sm64.state
    z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9
    z = (z ^ (z >> 27)) * 0x94d049bb133111eb
    return z ^ (z >> 31)
}

fn (mut sm64 Splitmix64) next_float() f64 {
    return f64(sm64.next_int()) / math.ldexp(1.0, 64)
}

fn main() {
    mut random_gen := splitmix64_new(1234567)
    mut counts := [5]int{}
    for _ in 0 .. 5 {
        println(random_gen.next_int())
    }
    random_gen = splitmix64_new(987654321)
    for _ in 0 .. 100_000 {
        j := int(math.floor(random_gen.next_float() * 5))
        counts[j]++
    }
    println("\nThe counts for 100,000 repetitions are:")
    for i in 0 .. counts.len {
        println("  $i : ${counts[i]}")
    }
}
