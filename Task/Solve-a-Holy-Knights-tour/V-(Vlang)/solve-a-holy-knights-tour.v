const moves = [
    [-1, -2], [1, -2], [-1, 2], [1, 2],
    [-2, -1], [-2, 1], [2, -1], [2, 1],
]

const board1 =
    " xxx    " +
    " x xx   " +
    " xxxxxxx" +
    "xxx  x x" +
    "x x  xxx" +
    "sxxxxxx " +
    "  xx x  " +
    "   xxx  "

const board2 =
    ".....s.x....." +
    ".....x.x....." +
    "....xxxxx...." +
    ".....xxx....." +
    "..x..x.x..x.." +
    "xxxxx...xxxxx" +
    "..xx.....xx.." +
    "xxxxx...xxxxx" +
    "..x..x.x..x.." +
    ".....xxx....." +
    "....xxxxx...." +
    ".....x.x....." +
    ".....x.x....."

fn solve(mut pz [][]int, sz int, sx int, sy int, idx int, cnt int) bool {
    if idx > cnt { return true }
    for move in moves {
        x := sx + move[0]
        y := sy + move[1]
        if x >= 0 && x < sz && y >= 0 && y < sz && pz[x][y] == 0 {
            pz[x][y] = idx
            if solve(mut pz, sz, x, y, idx + 1, cnt) { return true }
            pz[x][y] = 0
        }
    }
    return false
}

fn find_solution(b string, sz int) {
    mut pz := [][]int{len: sz, init: []int{len: sz, init: -1}}
    mut x := 0
    mut y := 0
    mut idx := 0
    mut cnt := 0
    for j in 0 .. sz {
        for i in 0 .. sz {
            ch := b[idx]
            if ch == `x` {
                pz[i][j] = 0
                cnt++
            } else if ch == `s` {
                pz[i][j] = 1
                cnt++
                x = i
                y = j
            }
            idx++
        }
    }

    if solve(mut pz, sz, x, y, 2, cnt) {
        for j in 0 .. sz {
            for i in 0 .. sz {
                if pz[i][j] != -1 { print("${pz[i][j]:02d}  ") }
				else { print("--  ") }
            }
            println("")
        }
    }
	else { println("Cannot solve this puzzle!") }
}

fn main() {
    find_solution(board1, 8)
    println("")
    find_solution(board2, 13)
}
