struct Oid {
    id string
}

fn (a Oid) str() string {
    return a.id
}

fn (a Oid) compare_to(b Oid) int {
    splits1 := a.id.split(".")
    splits2 := b.id.split(".")
    min_size := if splits1.len < splits2.len { splits1.len } else { splits2.len }
    for i in 0 .. min_size {
        val1 := splits1[i].int()
        val2 := splits2[i].int()
        if val1 < val2 { return -1 }
        else if val1 > val2 { return 1 }
    }
    // compare by length if all parts are equal
    return if splits1.len < splits2.len { -1 } else if splits1.len > splits2.len { 1 } else { 0 }
}

fn main() {
    mut oids := [
        Oid{"1.3.6.1.4.1.11.2.17.19.3.4.0.10"},
        Oid{"1.3.6.1.4.1.11.2.17.5.2.0.79"},
        Oid{"1.3.6.1.4.1.11.2.17.19.3.4.0.4"},
        Oid{"1.3.6.1.4.1.11150.3.4.0.1"},
        Oid{"1.3.6.1.4.1.11.2.17.19.3.4.0.1"},
        Oid{"1.3.6.1.4.1.11150.3.4.0"},
    ]
    // sorted using builtin comparator for arrays
    oids.sort_with_compare(fn (a &Oid, b &Oid) int {
        return a.compare_to(*b)
    })
    for oid in oids { println(oid.str()) }
}
