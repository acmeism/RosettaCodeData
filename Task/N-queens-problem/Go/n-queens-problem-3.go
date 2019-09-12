package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"time"

	"rosettacode.org/dlx" // or where ever you put the dlx package
)

func main() {
	log.SetPrefix("N-queens: ")
	log.SetFlags(0)
	profile := flag.Bool("profile", false, "show DLX profile")
	flag.Parse()

	for N := 2; N <= 18; N++ {
		err := nqueens(N, N == 8, *profile)
		if err != nil {
			log.Fatal(err)
		}
	}
}

func nqueens(N int, printFirst, profile bool) error {
	// Build a new DLX matrix with 2N primary columns and 4N-6 secondary
	// columns: R0..R(N-1), F0..F(N-1), A1..A(2N-3), B1..B(2N-3).
	// We also know the number of cells and solution rows required.
	m := dlx.NewWithHint(2*N, 4*N-6, N*N*4-4, 8)

	s := solution{
		N:          N,
		renumFwd:   make([]int, 0, 2*N),
		renumBack:  make([]int, 2*N),
		printFirst: printFirst,
	}

	// column indexes
	iR0 := 0
	iF0 := iR0 + N
	iA1 := iF0 + N
	iB1 := iA1 + 2*N - 3

	// Use "organ-pipe" ordering. E.g. for N=8:
	// R4 F4 R3 F3 R5 F5 R2 F2 R6 F6 R1 F1 R7 F7 R0 F0
	// This can reduce the number of link updates required by
	// almost half for large N; see Knuth's paper for details.
	mid := N / 2
	for off := 0; off <= N-mid; off++ {
		i := mid - off
		if i >= 0 {
			s.renumBack[iR0+i] = len(s.renumFwd)
			s.renumBack[iF0+i] = len(s.renumFwd) + 1
			s.renumFwd = append(s.renumFwd, iR0+i, iF0+i)
		}
		if i = mid + off; off != 0 && i < N {
			s.renumBack[iR0+i] = len(s.renumFwd)
			s.renumBack[iF0+i] = len(s.renumFwd) + 1
			s.renumFwd = append(s.renumFwd, iR0+i, iF0+i)
		}
	}

	// Add constraint rows.
	// TODO: pre-eliminate symetrical possibilities.
	cols := make([]int, 4)
	for i := 0; i < N; i++ {
		for j := 0; j < N; j++ {
			cols[0] = iR0 + i    // Ri,         rank i
			cols[1] = iF0 + j    // Fj,         file j
			a := (i + j)         // A(i+j),     diagonals
			b := (N - 1 - i + j) // B(N-1-i+j), reverse diagonals
			cols = cols[:2]
			// Do organ-pipe reordering for R and F.
			for i, c := range cols {
				cols[i] = s.renumBack[c]
			}

			// Only add diagonals with more than one space; that
			// is we omit the corners: A0, A(2N-2), B0, and B(2N-2)
			if 0 < a && a < 2*N-2 {
				cols = append(cols, iA1+a-1)
			}
			if 0 < b && b < 2*N-2 {
				cols = append(cols, iB1+b-1)
			}

			m.AddRow(cols)
		}
	}

	// Search for solutions.
	start := time.Now()
	err := m.Search(s.found)
	if err != nil {
		return err
	}
	elapsed := time.Since(start)
	fmt.Printf("%d×%d queens has %2d solutions, found in %v\n", N, N, s.count, elapsed)
	if profile {
		m.ProfileWrite(os.Stderr)
	}
	return nil
}

type solution struct {
	N          int
	count      int
	renumFwd   []int // for "organ-pipe" column ordering
	renumBack  []int
	printFirst bool
}

func (s *solution) found(m *dlx.Matrix) error {
	s.count++
	if s.printFirst && s.count == 1 {
		fmt.Printf("First %d×%d queens solution:\n", s.N, s.N)
		for _, cols := range m.SolutionIDs(nil) {
			var r, f int
			for _, c := range cols {
				// Undo organ-pipe reodering
				if c < len(s.renumFwd) {
					c = s.renumFwd[c]
				}
				if c < s.N {
					r = c + 1
				} else if c < 2*s.N {
					f = c - s.N + 1
				}
			}
			fmt.Printf("    R%d F%d\n", r, f)
		}
	}
	return nil
}
