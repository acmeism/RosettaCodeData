package main

import (
	"fmt"
	"math/rand"
	"strings"
	"time"
)

func main() {
	rand.Seed(time.Now().UnixNano())
	p := newPuzzle()
	p.play()
}

type board [16]cell
type cell uint8
type move uint8

const (
	up move = iota
	down
	right
	left
)

func randMove() move { return move(rand.Intn(4)) }

var solvedBoard = board{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0}

func (b *board) String() string {
	var buf strings.Builder
	for i, c := range b {
		if c == 0 {
			buf.WriteString("  .")
		} else {
			_, _ = fmt.Fprintf(&buf, "%3d", c)
		}
		if i%4 == 3 {
			buf.WriteString("\n")
		}
	}
	return buf.String()
}

type puzzle struct {
	board board
	empty int // board[empty] == 0
	moves int
	quit  bool
}

func newPuzzle() *puzzle {
	p := &puzzle{
		board: solvedBoard,
		empty: 15,
	}
	// Could make this configurable, 10==easy, 50==normal, 100==hard
	p.shuffle(50)
	return p
}

func (p *puzzle) shuffle(moves int) {
	// As with other Rosetta solutions, we use some number
	// of random moves to "shuffle" the board.
	for i := 0; i < moves || p.board == solvedBoard; {
		if p.doMove(randMove()) {
			i++
		}
	}
}

func (p *puzzle) isValidMove(m move) (newIndex int, ok bool) {
	switch m {
	case up:
		return p.empty - 4, p.empty/4 > 0
	case down:
		return p.empty + 4, p.empty/4 < 3
	case right:
		return p.empty + 1, p.empty%4 < 3
	case left:
		return p.empty - 1, p.empty%4 > 0
	default:
		panic("not reached")
	}
}

func (p *puzzle) doMove(m move) bool {
	i := p.empty
	j, ok := p.isValidMove(m)
	if ok {
		p.board[i], p.board[j] = p.board[j], p.board[i]
		p.empty = j
		p.moves++
	}
	return ok
}

func (p *puzzle) play() {
	fmt.Printf("Starting board:")
	for p.board != solvedBoard && !p.quit {
		fmt.Printf("\n%v\n", &p.board)
		p.playOneMove()
	}
	if p.board == solvedBoard {
		fmt.Printf("You solved the puzzle in %d moves.\n", p.moves)
	}
}

func (p *puzzle) playOneMove() {
	for {
		fmt.Printf("Enter move #%d (U, D, L, R, or Q): ", p.moves+1)
		var s string
		if n, err := fmt.Scanln(&s); err != nil || n != 1 {
			continue
		}

		s = strings.TrimSpace(s)
		if s == "" {
			continue
		}

		var m move
		switch s[0] {
		case 'U', 'u':
			m = up
		case 'D', 'd':
			m = down
		case 'L', 'l':
			m = left
		case 'R', 'r':
			m = right
		case 'Q', 'q':
			fmt.Printf("Quiting after %d moves.\n", p.moves)
			p.quit = true
			return
		default:
			fmt.Println(`
Please enter "U", "D", "L", or "R" to move the empty cell
up, down, left, or right. You can also enter "Q" to quit.
Upper or lowercase is accepted and only the first non-blank
character is important (i.e. you may enter "up" if you like).
`)
			continue
		}

		if !p.doMove(m) {
			fmt.Println("That is not a valid move at the moment.")
			continue
		}

		return
	}
}
