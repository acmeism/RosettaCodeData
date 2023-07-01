const (
    width = 81
    height = 5
)

fn cantor(mut lines [][]u8, start int, len int, index int) {
    seg := len / 3
    if seg == 0 {
        return
    }
    for i in index.. height {
        for j in start + seg..start + 2 * seg {
            lines[i][j] = ' '[0]
        }
    }
    cantor(mut lines, start, seg, index + 1)
    cantor(mut lines, start + seg * 2, seg, index + 1)
}

fn main() {
	mut lines := [][]u8{len:height, init: []u8{len:width, init:'*'[0]}}
    cantor(mut lines, 0, width, 1)
    for line in lines {
        println(line.bytestr())
    }
}
