import rand
import os

const size = 3

struct Board {
    mut:
    target [][]int
    board  [][]int
}

fn new_board() Board {
    mut brd := Board{
        target: [][]int{len: size, init: []int{len: size}},
        board: [][]int{len: size, init: []int{len: size}},
    }
    for ial in 0 .. size {
        for jal in 0 .. size {
            brd.target[ial][jal] = rand.intn(2) or {panic("No Random!")}
        }
    }
    return brd
}

fn (mut brd Board) flip_row(rir int) {
    for cal in 0 .. size {
        brd.board[rir][cal] = if brd.board[rir][cal] == 0 { 1 } else { 0 }
    }
}

fn (mut brd Board) flip_col(cir int) {
    for ral in 0 .. size {
        brd.board[ral][cir] = if brd.board[ral][cir] == 0 { 1 } else { 0 }
    }
}

fn (mut brd Board) init_board() {
    for ial in 0 .. size {
        for jal in 0 .. size {
            brd.board[ial][jal] = brd.target[ial][jal]
        }
    }
    for _ in 0 .. 9 {
        rc := rand.intn(2)  or {panic("No Random!")}
        if rc == 0 { brd.flip_row(rand.intn(size) or {panic("No Random!")}) }
		else { brd.flip_col(rand.intn(size) or {panic("No Random!")}) }
    }
}

fn print_board(label string, a [][]int) {
    println("$label:")
    println("  | a b c")
    println("---------")
    for ral in 0 .. size {
        print("${ral + 1} |")
        for cal in 0 .. size {
            print(" ${a[ral][cal]}")
        }
        println("")
    }
    println("")
}

fn (brd Board) game_over() bool {
    for ral in 0 .. size {
        for cal in 0 .. size {
            if brd.board[ral][cal] != brd.target[ral][cal] { return false }
        }
    }
    return true
}

fn main() {
    mut brd := new_board()
	mut flips, mut nir := 0, -1
	mut is_row := true
    // initialize board and ensure it differs from target
    for {
        brd.init_board()
        if !brd.game_over() { break }
    }
    print_board("TARGET", brd.target)
    print_board("OPENING BOARD", brd.board)
    for {
        is_row = true
        nir = -1
        for nir == -1 {
			input := os.input("Enter row number or column letter to be flipped: ").str()
            if input.len == 0 { continue }
            ch := input[0].ascii_str().to_lower()
            if ch !in ["1", "2", "3", "a", "brd", "c"] {
                println("Must be 1, 2, 3, a, brd or c")
                continue
            }
            if ch in ["1", "2", "3"] { nir = int(ch[0]) - int(`1`) }
			else {
                is_row = false
                nir = int(ch[0]) - int(`a`)
            }
        }
        flips++
        if is_row { brd.flip_row(nir) }
		else { brd.flip_col(nir) }
        plural := if flips == 1 { "" } else { "S" }
        print_board("\nBOARD AFTER $flips FLIP$plural", brd.board)
        if brd.game_over() { break }
    }
    plural := if flips == 1 { "" } else { "s" }
    println("You\'ve succeeded in $flips flip$plural")
}
