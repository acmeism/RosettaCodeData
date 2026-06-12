package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

// BLOSUM62 represents the BLOSUM62 scoring matrix
type BLOSUM62 struct {
	scoringMatrix map[string]int
}

// NewBLOSUM62 creates a new BLOSUM62 matrix from a file
func NewBLOSUM62() (*BLOSUM62, error) {
	file, err := os.Open("BLOSUM62.txt")
	if err != nil {
		return nil, err
	}
	defer file.Close()

	blosum := &BLOSUM62{
		scoringMatrix: make(map[string]int),
	}

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		entries := strings.Fields(line)
		if len(entries) >= 3 {
			key := entries[0] + "," + entries[1]
			value, err := strconv.Atoi(entries[2])
			if err != nil {
				return nil, err
			}
			blosum.scoringMatrix[key] = value
		}
	}

	if err := scanner.Err(); err != nil {
		return nil, err
	}

	return blosum, nil
}

// GetScore returns the score for a pair of amino acids
func (b *BLOSUM62) GetScore(a, c byte) int {
	key := string(a) + "," + string(c)
	return b.scoringMatrix[key]
}

// LocalAlignment performs local alignment of two sequences
func LocalAlignment(v, w string, scoringMatrix *BLOSUM62, gapStart, gapExtend int) (string, string, string) {
	// Initialize the 3 matrices
	M := make([][]int, len(v)+1)
	X := make([][]int, len(v)+1)
	Y := make([][]int, len(v)+1)
	backTrack := make([][]int, len(v)+1)

	for i := range M {
		M[i] = make([]int, len(w)+1)
		X[i] = make([]int, len(w)+1)
		Y[i] = make([]int, len(w)+1)
		backTrack[i] = make([]int, len(w)+1)
	}

	// Initialize the maximum scores
	maxScore := -1
	maxI, maxJ := 0, 0

	// Populate all three matrices
	for i := 1; i <= len(v); i++ {
		for j := 1; j <= len(w); j++ {
			Y[i][j] = max(Y[i-1][j]-gapExtend, M[i-1][j]-gapStart)
			X[i][j] = max(X[i][j-1]-gapExtend, M[i][j-1]-gapStart)

			curScores := []int{
				Y[i][j],
				M[i-1][j-1] + scoringMatrix.GetScore(v[i-1], w[j-1]),
				X[i][j],
				0,
			}

			M[i][j] = maxSlice(curScores)
			backTrack[i][j] = indexOf(curScores, M[i][j])

			if M[i][j] > maxScore {
				maxScore = M[i][j]
				maxI, maxJ = i, j
			}
		}
	}

	fmt.Println("Finished making the matrix")

	// Initialize the indices to start at the position of the high score
	i, j := maxI, maxJ

	// Initialize the aligned strings as the input strings up to the position of the high score
	vAligned, wAligned := v[:i], w[:j]

	// Backtrack to start of the local alignment starting at the highest scoring cell
	for backTrack[i][j] != 3 && i*j != 0 && i >= j {
		if backTrack[i][j] == 0 {
			i--
		} else if backTrack[i][j] == 1 {
			i--
			j--
		} else if backTrack[i][j] == 2 {
			j--
		}
	}

	fmt.Println("finished backtracking")

	// Cut the strings at the ending point of the backtrack
	vAligned = vAligned[i:]
	wAligned = wAligned[j:]

	return strconv.Itoa(maxScore), vAligned, wAligned
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func maxSlice(slice []int) int {
	if len(slice) == 0 {
		return math.MinInt32
	}
	max := slice[0]
	for _, value := range slice {
		if value > max {
			max = value
		}
	}
	return max
}

func indexOf(slice []int, item int) int {
	for i, v := range slice {
		if v == item {
			return i
		}
	}
	return -1
}

func main() {
	file, err := os.Open("rosalind_laff.txt")
	if err != nil {
		fmt.Println("Error opening file:", err)
		return
	}
	defer file.Close()

	var indata []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		indata = append(indata, scanner.Text())
	}
	indata = append(indata, ">")

	word1 := ""
	word2 := ""
	linenum := 0
	var chunk []string

	for _, line := range indata {
		line = strings.TrimSpace(line)
		linenum++

		if line == "" {
			continue
		} else {
			if line[0] == '>' {
				if linenum == 1 {
					chunk = nil
				} else if linenum > 1 && linenum != len(indata) {
					word1 = strings.Join(chunk, "")
					chunk = nil
				} else {
					word2 = strings.Join(chunk, "")
				}
			} else {
				chunk = append(chunk, line)
			}
		}
	}

	// Get the BLOSUM62 matrix
	blosum, err := NewBLOSUM62()
	if err != nil {
		fmt.Println("Error loading BLOSUM62 matrix:", err)
		return
	}

	// Get the local alignment (given sigma = 11, epsilon = 1 in problem statement)
	maxScore, vAligned, wAligned := LocalAlignment(word1, word2, blosum, 11, 1)

	// Print the results
	fmt.Println(maxScore)
	fmt.Println(vAligned)
	fmt.Println(wAligned)

	// Save the results to a file
	outFile, err := os.Create("out_localali_test.txt")
	if err != nil {
		fmt.Println("Error creating output file:", err)
		return
	}
	defer outFile.Close()

	_, err = fmt.Fprintf(outFile, "%s\n%s\n%s", maxScore, vAligned, wAligned)
	if err != nil {
		fmt.Println("Error writing to output file:", err)
	}
}
