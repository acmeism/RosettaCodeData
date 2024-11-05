fn main() {
    println(lcs("thisisatest", "testing123testing"))
}

fn lcs(a string, b string) string {
    mut lengths := map[int]int{}
    mut output :=''
    mut greatest_length := 0
    for i, x in a {
        for j, y in b {
            if x == y {
                if i == 0 || j == 0 {lengths[i * b.len + j] = 1}
				else {lengths[i * b.len + j] = lengths[(i-1) * b.len + j-1] + 1}
                if lengths[i * b.len + j] > greatest_length {
                    greatest_length = lengths[i * b.len + j]
                    output += x.ascii_str()
                }
            }
        }
    }
    return output
}
