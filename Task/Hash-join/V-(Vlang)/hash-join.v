struct Table_a {
  value int
  key   string
}

struct Table_b {
  key   string
  value string
}

fn main() {
    table_a := [Table_a{27, "Jonah"}, Table_a{18, "Alan"}, Table_a{28, "Glory"},
  Table_a{18, "Popeye"}, Table_a{28, "Alan"}]

  table_b := [Table_b{"Jonah", "Whales"}, Table_b{"Jonah", "Spiders"}, Table_b{"Alan", "Ghosts"},
  Table_b{"Alan", "Zombies"}, Table_b{"Glory", "Buffy"}]

  mut h := map[string][]int{}

    // hash phase
    for i, r in table_a {
    h[r.key] << i
    }

    // join phase
    for x in table_b {
        for a in h[x.key] {
            println("${table_a[a].value} ${table_a[a].key}, ${x.key} ${x.value}")
        }
    }
}
