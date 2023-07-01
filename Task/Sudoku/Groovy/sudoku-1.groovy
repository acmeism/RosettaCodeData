final CELL_VALUES = ('1'..'9')

class GridException extends Exception {
    GridException(String message) { super(message) }
}

def string2grid = { string ->
    assert string.size() == 81
    (0..8).collect { i -> (0..8).collect { j -> string[9*i+j] } }
}

def gridRow = { grid, slot -> grid[slot.i] as Set }

def gridCol = { grid, slot -> grid.collect { it[slot.j] } as Set }

def gridBox = { grid, slot ->
    def t, l; (t, l) = [slot.i.intdiv(3)*3, slot.j.intdiv(3)*3]
    (0..2).collect { row -> (0..2).collect { col -> grid[t+row][l+col] } }.flatten() as Set
}

def slotList = { grid ->
    def slots = (0..8).collect { i -> (0..8).findAll { j -> grid[i][j] == '.' } \
            .collect {j -> [i: i, j: j] } }.flatten()
}

def assignCandidates = { grid, slots = slotList(grid) ->
    slots.each { slot ->
        def unavailable = [gridRow, gridCol, gridBox].collect { it(grid, slot) }.sum() as Set
        slot.candidates = CELL_VALUES - unavailable
    }
    slots.sort { - it.candidates.size() }
    if (slots && ! slots[-1].candidates) {
        throw new GridException('Invalid Sudoku Grid, overdetermined slot: ' + slots[-1])
    }
    slots
}

def isSolved = { grid -> ! (grid.flatten().find { it == '.' }) }

def solve
solve = { grid ->
    def slots = assignCandidates(grid)
    if (! slots) { return grid }
    while (slots[-1].candidates.size() == 1) {
        def slot = slots.pop()
        grid[slot.i][slot.j] = slot.candidates[0]
        if (! slots) { return grid }
        slots = assignCandidates(grid, slots)
    }
    if (! slots) { return grid }
    def slot = slots.pop()
    slot.candidates.each {
        if (! isSolved(grid)) {
            try {
                def sGrid = grid.collect { row -> row.collect { cell -> cell } }
                sGrid[slot.i][slot.j] = it
                grid = solve(sGrid)
            } catch (GridException ge) {
                grid[slot.i][slot.j] = '.'
            }
        }
    }
    if (!isSolved(grid)) {
        slots = assignCandidates(grid)
        throw new GridException('Invalid Sudoku Grid, underdetermined slots: ' + slots)
    }
    grid
}
