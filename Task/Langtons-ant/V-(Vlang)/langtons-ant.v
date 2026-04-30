const size = 100
const white = false
const black = true

fn main() {
    dirs := [[0, -1], [1, 0], [0, 1], [-1, 0]]
    mut plane := [][]bool{len: size, init: []bool{len: size, init: white}}
    mut row, mut col, mut start_row, mut end_row, mut dir := 50, 50, 0, 0, 0
    for {
        if !(row >= 0 && row < size && col >= 0 && col < size) { break }
        color := plane[row][col]
        if color == black { dir = (dir + dirs.len - 1) % dirs.len }
        else { dir = (dir + 1) % dirs.len }
        dx := dirs[dir][0]
        dy := dirs[dir][1]
        plane[row][col] = !color
        row += dy
        col += dx
    }
    // find first and last rows containing black
    start_row = 0
    end_row = size - 1
    // find start_row
    for i in 0 .. size {
        if plane[i].any(it == black) {
            start_row = i
            break
        }
    }
    // find end_row
 	for i := size - 1; i >= 0; i-- {
        if plane[i].any(it == black) {
            end_row = i
            break
        }
    }
    // print cropped plane
    for i in start_row .. end_row + 1 {
        mut line := []string{}
        for color in plane[i] {
            if color == black { line << "#" }
            else { line << " " }
        }
        println(line.join(''))
    }
}
