import rand
import rand.seed

const bases = "ACGT"

// 'w' contains the weights out of 300 for each
// of swap, delete or insert in that order.
fn mutate(dna string, w [3]int) string {
    le := dna.len
    // get a random position in the dna to mutate
    p := rand.intn(le) or {0}
    // get a random number between 0 and 299 inclusive
    r := rand.intn(300) or {0}
    mut bytes := dna.bytes()
    match true {
		r < w[0] { // swap
			base := bases[rand.intn(4) or {0}]
			println("  Change @${p:3} ${[bytes[p]].bytestr()} to ${[base].bytestr()}")
			bytes[p] = base
		}
		r < w[0]+w[1] { // delete
			println("  Delete @${p:3} ${bytes[p]}")
			bytes.delete(p)
			//copy(bytes[p:], bytes[p+1:])
			bytes = bytes[0..le-1]
		}
		else { // insert
			base := bases[rand.intn(4) or {0}]
			bytes << 0
			bytes.insert(p,bytes[p])
			//copy(bytes[p+1:], bytes[p:])
			println("  Insert @${p:3} $base")
			bytes[p] = base
		}
    }
    return bytes.bytestr()
}

// Generate a random dna sequence of given length.
fn generate(le int) string {
    mut bytes := []u8{len:le}
    for i := 0; i < le; i++ {
        bytes[i] = bases[rand.intn(4) or {0}]
    }
    return bytes.bytestr()
}

// Pretty print dna and stats.
fn pretty_print(dna string, rowLen int) {
    println("SEQUENCE:")
    le := dna.len
    for i := 0; i < le; i += rowLen {
        mut k := i + rowLen
        if k > le {
            k = le
        }
        println("${i:5}: ${dna[i..k]}")
    }
    mut base_map := map[byte]int{} // allows for 'any' base
    for i in 0..le {
        base_map[dna[i]]++
    }
    mut bb := base_map.keys()
	bb.sort()

    println("\nBASE COUNT:")
    for base in bb {
        println("    $base: ${base_map[base]:3}")
    }
    println("    ------")
    println("    Σ: $le")
    println("    ======\n")
}

// Express weights as a string.
fn wstring(w [3]int) string {
    return "  Change: ${w[0]}\n  Delete: ${w[1]}\n  Insert: ${w[2]}\n"
}

fn main() {
    rand.seed(seed.time_seed_array(2))
    mut dna := generate(250)
    pretty_print(dna, 50)
    muts := 10
    w := [100, 100, 100]! // use e.g. {0, 300, 0} to choose only deletions
    println("WEIGHTS (ex 300):\n${wstring(w)}")
    println("MUTATIONS ($muts):")
    for _ in 0..muts {
        dna = mutate(dna, w)
    }
    println('')
    pretty_print(dna, 50)
}
