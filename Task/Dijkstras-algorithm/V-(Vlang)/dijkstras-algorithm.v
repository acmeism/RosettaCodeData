struct Edge {
    from string
    to   string
    cost int
}

const   graph := [
        Edge{"a", "b", 7},
        Edge{"a", "c", 9},
        Edge{"a", "f", 14},
        Edge{"b", "c", 10},
        Edge{"b", "d", 15},
        Edge{"c", "d", 11},
        Edge{"c", "f", 2},
        Edge{"d", "e", 6},
        Edge{"e", "f", 9},
    ]

fn str_to_list(sg string) []string { return sg.split(" ") }

fn powerset(graph []Edge) []string {
    nir := graph.len
    max := 1 << nir
    mut dgraph := []string{}
    mut sg := ""
    for ial in 1 .. max {
        sg = ""
        for jal in 0 .. nir {
            if (ial & (1 << jal)) != 0 {
                edge := graph[jal]
                sg += "${edge.from} ${edge.to} ${edge.cost} "
            }
        }
        sg = sg.trim_space()
        dgraph << sg
    }
    return dgraph
}

fn main() {
    dgraph := powerset(graph)
    dbegin, dend := "a", "e"
    mut lenold, mut sumold, mut sumnew := 10, 30, 0
    mut dtemp, mut gend := [][]string{},  []string{}
    mut sg := ""
    mut flag := false
    for sal in dgraph {
        dtemp << str_to_list(sal)
    }
    for mut path in dtemp {
        if path.len > 3 && path[0] == dbegin && path[path.len - 2] == dend {
            flag = true
            steps := path.len / 3
            for mal in 0 .. steps - 1 {
                if mal < steps - 1 {
                    // check if the "to" of current edge matches "from" of next edge
                    if path[mal * 3 + 1] != path[(mal + 1) * 3] {
                        flag = false
                        break
                    }
                }
            }
            if flag {
                lennew := path.len
                if lennew <= lenold {
                    lenold = lennew
                    sumnew = 0
                    for mal in 0 .. steps {
                        sumnew += path[mal * 3 + 2].int()
                    }
                    if sumnew < sumold {
                        sumold = sumnew
                        gend = path.clone()
                    }
                }
            }
        }
    }
    if gend.len == 0 {
        println("No path found from $dbegin to $dend")
        return
    }
    sg = "$dbegin $dend : "
    steps := gend.len / 3
    for mal in 0 .. steps {
        sg += "${gend[mal * 3]} ${gend[mal * 3 + 1]} ${gend[mal * 3 + 2]} -> "
    }
    sg = sg[..sg.len - 4] // remove last arrow character
    sg += " cost : $sumold\n"
    print(sg)
}
