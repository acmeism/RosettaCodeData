const trans = '___#_##_'

fn v(cell []u8, i int) bool {
    // false if index is out of bounds or cell[i] == '_'
    if i < 0 || i >= cell.len { return false }
    return cell[i] != `_`
}

fn evolve(mut cell []u8, mut backup []u8, len int) int {
    mut diff := 0
    for i in 0 .. len {
        // calculate index using left, self, right bits
        idx := int(v(cell, i - 1)) * 4 + int(v(cell, i)) * 2 + int(v(cell, i + 1))
        backup[i] = trans[idx]
        if backup[i] != cell[i] { diff++ }
    }
    // backup to cell
    for i in 0 .. len {
        cell[i] = backup[i]
    }
    return diff
}

fn main() {
    mut c := '_###_##_#_#_#_#__#__'.bytes()
    mut b := []u8{len: c.len, init: `_`}
    mut slice_c := c[1..c.len].clone()
    mut slice_b := b[1..b.len].clone()
    for {
        println(slice_c.bytestr())
        if evolve(mut slice_c, mut slice_b, slice_c.len) == 0 { break }
    }
}
