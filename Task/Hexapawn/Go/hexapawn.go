package main

import (
	"bytes"
	"errors"
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"math/rand"
	"os"
	"time"
)

// In the following `her*` is H.E.R. or Hexapawn Educable Robot

const (
	Rows = 3
	Cols = 3
)

var vlog *log.Logger

func main() {
	verbose := flag.Bool("v", false, "verbose")
	flag.Parse()
	if flag.NArg() != 0 {
		flag.Usage()
		os.Exit(2)
	}
	logOutput := ioutil.Discard
	if *verbose {
		logOutput = os.Stderr
	}
	vlog = log.New(logOutput, "hexapawn: ", 0)

	rand.Seed(time.Now().UnixNano())
	wins := make(map[spot]int, 2)
	for {
		h := New()
		var s herGameState
		for c := false; h[stateIdx] == empty; c = !c {
			if c {
				h = s.Move(h)
			} else {
				h = h.HumanMove()
			}
		}
		fmt.Printf("Board:\n%v is a win for %v\n", h, h[stateIdx])
		s.Result(h[stateIdx])
		wins[h[stateIdx]]++
		fmt.Printf("Wins: Black=%d, White=%d\n", wins[black], wins[white])
		fmt.Println()
	}
}

func (h Hexapawn) HumanMove() Hexapawn {
	fmt.Print("Board:\n", h, "\n")
	var from, to int
	for {
		fmt.Print("Your move: ")
		_, err := fmt.Scanln(&from, &to)
		if err != nil {
			fmt.Println(err)
			if err == io.EOF {
				os.Exit(0) // ick, exiting from here
			}
			continue
		}
		if err := h.doMove(white, from-1, to-1); err != nil {
			fmt.Println(err)
			continue
		}
		return h
	}
}

var herNextMove = make(map[Hexapawn][]move)

type herGameState struct {
	// Last "unknown" move was herNextMove[h][i]
	h Hexapawn
	i int
}

func (s *herGameState) Move(h Hexapawn) Hexapawn {
	known := false
	moves := herNextMove[h]
	if moves == nil { // Lazy init
		moves = possibleMoves(black, h)
		herNextMove[h] = moves
	} else if len(moves) == 0 {
		// From here all possibilities can lose
		vlog.Println("no good moves left to black, picking a random looser")
		known = true
		moves = possibleMoves(black, h)
	}
	vlog.Println("considering", moves)
	i := rand.Intn(len(moves))
	if !known {
		s.h = h
		s.i = i
	}
	fmt.Println("Computer moves", moves[i])
	if err := h.doMove(black, moves[i].from, moves[i].to); err != nil {
		panic(err)
	}
	return h
}

func (s herGameState) Result(winner spot) {
	if winner == black {
		return // Do nothing
	}
	// Throw out the last "unknown" move H.E.R. made
	moves := herNextMove[s.h]
	vlog.Printf("Training:\n%v will no longer do %v\n", s.h, moves[s.i])
	herNextMove[s.h] = append(moves[:s.i], moves[s.i+1:]...)
	vlog.Println("will instead do one of:", herNextMove[s.h])
}

type move struct{ from, to int }

func (m move) String() string { return fmt.Sprintf("%d→%d", m.from+1, m.to+1) }

var cachedMoves = []map[Hexapawn][]move{
	black: make(map[Hexapawn][]move),
	white: make(map[Hexapawn][]move),
}

func possibleMoves(s spot, h Hexapawn) []move {
	m := cachedMoves[s][h]
	if m != nil {
		return m
	}
	//vlog.Printf("calculating possible moves for %v\n%v\n", s, h)
	// These are cached so no effort at optimization is made
	// (e.g. skipping from==to or continuing the outer loop when h[from]!=s)
	m = make([]move, 0)
	for from := 0; from < Rows*Cols; from++ {
		for to := 0; to < Rows*Cols; to++ {
			if err := h.checkMove(s, from, to); err == nil {
				m = append(m, move{from, to})
			}
		}
	}
	cachedMoves[s][h] = m
	vlog.Printf("caclulated possible moves for %v\n%v as %v\n", s, h, m)
	return m
}

func (h *Hexapawn) doMove(p spot, from, to int) error {
	if err := h.checkMove(p, from, to); err != nil {
		return err
	}
	h[from] = empty
	h[to] = p
	if (p == white && to/Rows == Rows-1) || (p == black && to/Rows == 0) {
		h[stateIdx] = p
	} else if len(possibleMoves(p.Other(), *h)) == 0 {
		h[stateIdx] = p
	}
	return nil
}

func (h *Hexapawn) checkMove(p spot, from, to int) error {
	if h[from] != p {
		return fmt.Errorf("No %v located at spot %v", p, from+1)
	}
	if h[to] == p {
		return fmt.Errorf("%v already occupies spot %v", p, to+1)
	}
	Δr := from/Rows - to/Rows
	if (p == white && Δr != -1) || (p == black && Δr != 1) {
		return errors.New("must move forward one row")
	}
	Δc := from%Rows - to%Rows
	capture := h[to] != empty
	if (capture || Δc != 0) && (!capture || (Δc != 1 && Δc != -1)) {
		return errors.New("ilegal move")
	}
	return nil
}

type Hexapawn [Rows*Cols + 1]spot

func New() Hexapawn {
	// TODO for Rows,Cols != 3,3
	return Hexapawn{
		white, white, white,
		empty, empty, empty,
		black, black, black,
	}
}

func idx(r, c int) int { return r*Cols + c }

// The game winner (or empty) is stored at this index
const stateIdx = Rows * Cols

func (h Hexapawn) String() string {
	var b bytes.Buffer
	for r := Rows - 1; r >= 0; r-- {
		for c := 0; c < Cols; c++ {
			b.WriteByte(h[idx(r, c)].Byte())
		}
		b.WriteByte('\n')
	}
	// b.String() contains an extra newline
	return string(b.Next(Rows*(Cols+1) - 1))
}

type spot uint8

const (
	empty spot = iota
	black
	white
)

func (s spot) String() string {
	switch s {
	case black:
		return "Black"
	case white:
		return "White"
	}
	panic(s)
}

func (s spot) Byte() byte {
	switch s {
	case empty:
		return '.'
	case black:
		return 'B'
	case white:
		return 'W'
	}
	panic(s)
}

func (s spot) Other() spot {
	if s == black {
		return white
	}
	return black
}
