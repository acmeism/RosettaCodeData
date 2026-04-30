import rand
import math

const nul = u8(0)

struct Game {
	mut:
    grid [][]u8 = [][]u8{len: 8, init: []u8{len: 8, init: nul}}
}

fn (mut gme Game) create_fen() string {
    gme.place_kings()
    gme.place_pieces("PPPPPPPP", true)
    gme.place_pieces("pppppppp", true)
    gme.place_pieces("RNBQBNR", false)
    gme.place_pieces("rnbqbnr", false)
    return gme.to_fen()
}

fn (mut gme Game) place_kings() {
    for {
        r1 := rand.intn(8) or {0}
        c1 := rand.intn(8) or {0}
        r2 := rand.intn(8) or {0}
        c2 := rand.intn(8) or {0}
        if r1 != r2 && math.abs(r1 - r2) > 1 && math.abs(c1 - c2) > 1 {
            gme.grid[r1][c1] = `K`
            gme.grid[r2][c2] = `k`
            return
        }
    }
}

fn (mut gme Game) place_pieces(pieces string, is_pawn bool) {
    num_to_place := rand.intn(pieces.len) or {0}
    mut rir, mut cir := 0, 0
    for nal in 0 .. num_to_place {
        rir = 0
        cir = 0
        for {
            rir = rand.intn(8) or {0}
            cir = rand.intn(8) or {0}
            if gme.grid[rir][cir] == nul && !(is_pawn && (rir == 0 || rir == 7)) { break }
        }
        gme.grid[rir][cir] = pieces[nal]
    }
}

fn (gme Game) to_fen() string {
    mut fen := ""
    mut count_empty := 0
    for rir in 0 .. 8 {
        for cir in 0 .. 8 {
            ch := gme.grid[rir][cir]
            print(if ch == nul { "." } else { ch.ascii_str() } + " ")
            if ch == nul { count_empty++ }
            else {
                if count_empty > 0 {
                    fen += count_empty.str()
                    count_empty = 0
                }
                fen += ch.ascii_str()
            }
        }
        if count_empty > 0 {
            fen += count_empty.str()
            count_empty = 0
        }
        fen += "/"
        println("")
    }
    fen += " w - - 0 1"
    return fen
}

fn main() {
    mut game := Game{}
    println(game.create_fen())
}
