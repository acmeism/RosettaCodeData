package main

import (
    "fmt"
    "log"
    "os"
    "strings"
)

const dim = 16 // image size

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

// Outputs the result to the terminal using UTF-8 block characters.
func drawPile(pile [][]uint) {
    chars:= []rune(" ░▓█")
    for _, row := range pile {
        line := make([]rune, len(row))
        for i, elem := range row {
            if elem > 3 { // only possible when algorithm not yet completed.
                elem = 3
            }
            line[i] = chars[elem]
        }
        fmt.Println(string(line))
    }
}

// Creates a .ppm file in the current directory, which contains
// a colored image of the pile.
func writePile(pile [][]uint) {
    file, err := os.Create("output.ppm")
    check(err)
    defer file.Close()
    // Write the signature, image dimensions and maximum color value to the file.
    fmt.Fprintf(file, "P3\n%d %d\n255\n", dim, dim)
    bcolors := []string{"125 0 25 ", "125 80 0 ", "186 118 0 ", "224 142 0 "}
    var line strings.Builder
    for _, row := range pile {
        for _, elem := range row {
            line.WriteString(bcolors[elem])
        }
        file.WriteString(line.String() + "\n")
        line.Reset()
    }
}

// Main part of the algorithm, a simple, recursive implementation of the model.
func handlePile(x, y uint, pile [][]uint) {
    if pile[y][x] >= 4 {
        pile[y][x] -= 4
        // Check each neighbor, whether they have enough "sand" to collapse and if they do,
        // recursively call handlePile on them.
        if y > 0 {
            pile[y-1][x]++
            if pile[y-1][x] >= 4 {
                handlePile(x, y-1, pile)
            }
        }
        if x > 0 {
            pile[y][x-1]++
            if pile[y][x-1] >= 4 {
                handlePile(x-1, y, pile)
            }
        }
        if y < dim-1 {
            pile[y+1][x]++
            if pile[y+1][x] >= 4 {
                handlePile(x, y+1, pile)
            }
        }
        if x < dim-1 {
            pile[y][x+1]++
            if pile[y][x+1] >= 4 {
                handlePile(x+1, y, pile)
            }
        }

        // Uncomment this line to show every iteration of the program.
        // Not recommended with large input values.
        // drawPile(pile)

        // Finally call the function on the current cell again,
        // in case it had more than 4 particles.
        handlePile(x, y, pile)
    }
}

func main() {
    // Create 2D grid and set size using the 'dim' constant.
    pile := make([][]uint, dim)
    for i := 0; i < dim; i++ {
        pile[i] = make([]uint, dim)
    }

    // Place some sand particles in the center of the grid and start the algorithm.
    hdim := uint(dim/2 - 1)
    pile[hdim][hdim] = 16
    handlePile(hdim, hdim, pile)
    drawPile(pile)

    // Uncomment this to save the final image to a file
    // after the recursive algorithm has ended.
    // writePile(pile)
}
