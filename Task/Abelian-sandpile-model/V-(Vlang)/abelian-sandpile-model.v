import os
import strings

const dim = 16

// Outputs the result to the terminal using UTF-8 block characters.
fn draw_pile(pile [][]int) {
    chars:= [` `,`░`,`▓`,`█`]
    for row in pile {
        mut line := []rune{len: row.len}
        for i, e in row {
            mut elem := e
            if elem > 3 { // only possible when algorithm not yet completed.
                elem = 3
            }
            line[i] = chars[elem]
        }
        println(line.string())
    }
}

// Creates a .ppm file in the current directory, which contains
// a colored image of the pile.
fn write_pile(pile [][]int) {
    mut file := os.create("output.ppm") or {panic('ERROR creating file')}
    defer {
file.close()
}
    // Write the signature, image dimensions and maximum color value to the file.
    file.writeln("P3\n$dim $dim\n255") or {panic('ERROR writing ln')}
    bcolors := ["125 0 25 ", "125 80 0 ", "186 118 0 ", "224 142 0 "]
    mut line := strings.new_builder(128)
    for row in pile {
        for elem in row {
            line.write_string(bcolors[elem])
        }
        file.write_string('${line.str()}\n') or {panic('ERROR writing str')}
        line = strings.new_builder(128)
    }
}

// Main part of the algorithm, a simple, recursive implementation of the model.
fn handle_pile(x int, y int, mut pile [][]int) {
    if pile[y][x] >= 4 {
        pile[y][x] -= 4
        // Check each neighbor, whether they have enough "sand" to collapse and if they do,
        // recursively call handle_pile on them.
        if y > 0 {
            pile[y-1][x]++
            if pile[y-1][x] >= 4 {
                handle_pile(x, y-1, mut pile)
            }
        }
        if x > 0 {
            pile[y][x-1]++
            if pile[y][x-1] >= 4 {
                handle_pile(x-1, y, mut pile)
            }
        }
        if y < dim-1 {
            pile[y+1][x]++
            if pile[y+1][x] >= 4 {
                handle_pile(x, y+1, mut pile)
            }
        }
        if x < dim-1 {
            pile[y][x+1]++
            if pile[y][x+1] >= 4 {
                handle_pile(x+1, y, mut pile)
            }
        }

        // Uncomment this line to show every iteration of the program.
        // Not recommended with large input values.
        // draw_pile(pile)

        // Finally call the fntion on the current cell again,
        // in case it had more than 4 particles.
        handle_pile(x, y, mut pile)
    }
}

fn main() {
    // Create 2D grid and set size using the 'dim' constant.
    mut pile := [][]int{len: dim, init: []int{len: dim}}

    // Place some sand particles in the center of the grid and start the algorithm.
    hdim := int(dim/2 - 1)
    pile[hdim][hdim] = 16
    handle_pile(hdim, hdim, mut pile)
    draw_pile(pile)

    // Uncomment this to save the final image to a file
    // after the recursive algorithm has ended.
    // write_pile(pile)
}
