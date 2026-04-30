import math

struct Square {
    x int
    y int
}

struct Pair[T] {
    first  T
    second T
}

fn all_pairs[T](a []T) []Pair[T] {
    mut result := []Pair[T]{}
    for i in a {
        for j in a {
            result << Pair[T]{i, j}
        }
    }
    return result
}

fn on_board(sq Square, board []Square) bool {
        for b in board {
            if b == sq { return true }
        }
        return false
}

fn knight_moves(s Square, board []Square, axis_moves []int) []Square {
    mut candidates := []Square{}
    moves := all_pairs(axis_moves).filter(fn (p Pair[int]) bool {
        return math.abs(p.first) != math.abs(p.second)})
    for m in moves {
        candidate := Square{s.x + m.first, s.y + m.second}
        if on_board(candidate, board) { candidates << candidate }
    }
    return candidates
}

fn find_moves(s Square, moves []Square, board []Square, axis_moves []int) []Square {
    kmoves := knight_moves(s, board, axis_moves)
    mut filtered := []Square{}
    mut found := false
    for m in kmoves {
        found = false
        for v in moves {
            if v == m {
                found = true
                break
            }
        }
        if !found { filtered << m }
    }
    return filtered
}

fn knight_tour(pmoves []Square, board []Square, axis_moves []int) []Square {
  mut moves := pmoves.clone()
    if moves.len == 0 { return moves }
    last_move := moves.last()
    next_moves := find_moves(last_move, moves, board, axis_moves)
    if next_moves.len == 0 { return moves }
    mut best_move := next_moves[0]
    mut min_count := find_moves(best_move, moves, board, axis_moves).len
    for m in next_moves[1..] {
        count := find_moves(m, moves, board, axis_moves).len
        if count < min_count {
            best_move = m
            min_count = count
        }
    }
  moves << [best_move]
    return knight_tour(moves, board, axis_moves)
}

fn knight_tour_from(start Square, board []Square, axis_moves []int) []Square {
    return knight_tour([start], board, axis_moves)
}

fn main() {
    mut board := []Square{}
    mut col := 0
    for i in 0 .. 64 {
        board << Square{i / 8 + 1, i % 8 + 1}
    }
    axis_moves := [1, 2, -1, -2]
    tour := knight_tour_from(Square{1, 1}, board, axis_moves)
    for sq in tour {
        print("$sq.x,$sq.y")
        if col == 7 { println("") }
    else { print(" ") }
        col = (col + 1) % 8
    }
}
