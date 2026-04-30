struct Point {
    x int
    y int
}

const image = [
        "                                                          ",
        " #################                   #############        ",
        " ##################               ################        ",
        " ###################            ##################        ",
        " ########     #######          ###################        ",
        "   ######     #######         #######       ######        ",
        "   ######     #######        #######                      ",
        "   #################         #######                      ",
        "   ################          #######                      ",
        "   #################         #######                      ",
        "   ######     #######        #######                      ",
        "   ######     #######        #######                      ",
        "   ######     #######         #######       ######        ",
        " ########     #######          ###################        ",
        " ########     ####### ######    ################## ###### ",
        " ########     ####### ######      ################ ###### ",
        " ########     ####### ######         ############# ###### ",
        "                                                          ",
    ]

const nbrs = [
        [0, -1], [1, -1], [1, 0],
        [1, 1], [0, 1], [-1, 1],
        [-1, 0], [-1, -1], [0, -1],
]

const nbr_groups = [
        [[0, 2, 4], [2, 4, 6]],
        [[0, 2, 6], [0, 4, 6]],
]


fn num_neighbors(grid [][]u8, r int, c int) int {
    mut count := 0
    for i := 0; i < nbrs.len - 1; i++ {
        dx := nbrs[i][0]
        dy := nbrs[i][1]
        if grid[r + dy][c + dx] == `#` { count++ }
    }
    return count
}

fn num_transitions(grid [][]u8, r int, c int) int {
    mut count := 0
    for i := 0; i < nbrs.len - 1; i++ {
        dx1 := nbrs[i][0]
        dy1 := nbrs[i][1]
        dx2 := nbrs[i + 1][0]
        dy2 := nbrs[i + 1][1]
        if grid[r + dy1][c + dx1] == ` ` && grid[r + dy2][c + dx2] == `#` { count++ }
    }
    return count
}

fn at_least_one_is_white(grid [][]u8, r int, c int, step int) bool {
    mut count := 0
    group := nbr_groups[step]
    for i in 0..2 {
        for j in 0..group[i].len {
            nbr := nbrs[group[i][j]]
            if grid[r + nbr[1]][c + nbr[0]] == ` ` {
                count++
                break
            }
        }
    }
    return count > 1
}

fn thin_image() {
    mut to_white := []Point{}
    mut grid := [][]u8{}
    mut first_step := false
    mut has_changed := false	
    for line in image {
        grid << line.bytes() // line.bytes() returns []u8
    }
    for {
        has_changed = false
        first_step = !first_step
        for r := 1; r < grid.len - 1; r++ {
            for c := 1; c < grid[0].len - 1; c++ {
                if grid[r][c] != `#` { continue }
                nn := num_neighbors(grid, r, c)
                if nn < 2 || nn > 6 { continue }
                if num_transitions(grid, r, c) != 1 { continue }
                step := if first_step { 0 } else { 1 }
                if !at_least_one_is_white(grid, r, c, step) { continue }
                to_white << Point{c, r}
                has_changed = true
            }
        }
        for p in to_white {
            grid[p.y][p.x] = ` `
        }
        to_white.clear()
        if !first_step && !has_changed { break }
    }
    for row in grid {
        println(row.bytestr())
    }
}

fn main() {
    thin_image()
}
