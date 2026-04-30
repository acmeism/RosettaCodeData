const tests = [
    "banana",
    "appellee",
    "dogwood",
    "TO BE OR NOT TO BE OR WANT TO BE OR NOT?",
    "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES",
    "\x02ABC\x03"
]

struct BWT {
    mut:
    stx string = "\x02"
    etx string = "\x03"
}

fn (bwt BWT) bwt(sg string) !string {
    if sg.contains(bwt.stx) || sg.contains(bwt.etx) {
        return error("FormatException: String cannot contain STX or ETX")
    }
    ss := bwt.stx + sg + bwt.etx
    mut table := []string{}
    for ial in 0 .. ss.len {
        before := ss[ial..]
        after := ss[..ial]
        table << before + after
    }
    table.sort()
    return table.map(it[it.len - 1].ascii_str()).join("")
}

fn (bwt BWT) ibwt(r string) string {
    len := r.len
    mut table := []string{len: len, init: ""}
    for _ in 0 .. len {
        for ial in 0 .. len {
            table[ial] = r[ial].ascii_str() + table[ial]
        }
        table.sort()
    }
    for row in table {
        if row.ends_with(bwt.etx) { return row[1..len - 1] }
    }
    return ""
}

fn (bwt BWT) make_printable(sg string) string {
    return sg.replace(bwt.stx, "^").replace(bwt.etx, "|")
}

fn main() {
    mut bwt_inst := BWT{}
    mut tsg := ""
	for idx, test in tests {
        println(bwt_inst.make_printable(test))
        print(" --> ")
        tsg = bwt_inst.bwt(test) or {
            println("ERROR: {$err}")
            tsg = ""
            continue
        }
        println(bwt_inst.make_printable(tsg))
        rsg := bwt_inst.ibwt(tsg)
        if idx < tests.len { println(" --> $rsg\n") } else { println(" --> $rsg") }
    }
}
