#!/usr/bin/awk -f

# Remember: AWK is 1-based, for better or worse.

BEGIN {
    # The maze dimensions.
    width = 20;  # Global
    height = 20; # Global
    resetMaze();

    # Some constants.
    top = 1;
    bottom = 2;
    left = 3;
    right = 4;

    # Randomize the PRNG.
    randomize();

    # Visit all the cells starting at a random point.
    visitCell(getRandX(), getRandY());

    # Show the result.
    printMaze();
}

# Wander through the maze removing walls as we go.
function visitCell(x, y,    dirList, dir, nx, ny, ndir, pi) {
    setVisited(x, y);   # This cell has been visited.

    # Visit neighbors in a random order.
    dirList = getRandDirList();
    for (dir = 1; dir <= 4; dir++) {
        # Get coordinates of a random neighbor (next in random direction list).
        ndir = substr(dirList, dir, 1);
        nx = getNextX(x, ndir);
        ny = getNextY(y, ndir);

        # Visit an unvisited neighbor, removing the separating walls.
        if (wasVisited(nx, ny) == 0) {
            rmWall(x, y, ndir);
            rmWall(nx, ny, getOppositeDir(ndir));
            visitCell(nx, ny)
        }
    }
}

# Display the text-mode maze.
function printMaze(    x, y, r, w) {
    for (y = 1; y <= height; y++) {
        for (pass = 1; pass <= 2; pass++) { # Go over each row twice: top, middle
            for (x = 1; x <= width; x++) {
                if (pass == 1) { # top
                    printf("+");
                    printf(hasWall(x, y, top) == 1 ? "---" : "   ");
                    if (x == width) printf("+");
                }
                else if (pass == 2) { # left, right
                    printf(hasWall(x, y, left) == 1 ? "|" : " ");
                    printf("   ");
                    if (x == width) printf(hasWall(x, y, right) == 1 ? "|" : " ");
                }
            }
            print;
        }
    }
    for (x = 1; x <= width; x++) printf("+---"); # bottom row
    print("+"); # bottom right corner
}

# Given a direction, get its opposite.
function getOppositeDir(d) {
    if (d == top) return bottom;
    if (d == bottom) return top;
    if (d == left) return right;
    if (d == right) return left;
}

# Build a list (string) of the four directions in random order.
function getRandDirList(    dirList, randDir, nx, ny, idx) {
    dirList = "";
    while (length(dirList) < 4) {
        randDir = getRandDir();
        if (!index(dirList, randDir)) {
            dirList = dirList randDir;
        }
    }
    return dirList;
}

# Get x coordinate of the neighbor in a given a direction.
function getNextX(x, dir) {
    if (dir == left) x = x - 1;
    if (dir == right) x = x + 1;
    if (!isGoodXY(x, 1)) return -1; # Off the edge.
    return x;
}

# Get y coordinate of the neighbor in a given a direction.
function getNextY(y, dir) {
    if (dir == top) y = y - 1;
    if (dir == bottom) y = y + 1;
    if (!isGoodXY(1, y)) return -1; # Off the edge.
    return y;
}

# Mark a cell as visited.
function setVisited(x, y,    cell) {
    cell = getCell(x, y);
    if (cell == -1) return;
    cell = substr(cell, 1, 4) "1"; # walls plus visited
    setCell(x, y, cell);
}

# Get the visited state of a cell.
function wasVisited(x, y,    cell) {
    cell = getCell(x, y);
    if (cell == -1) return 1; # Off edges already visited.
    return substr(getCell(x,y), 5, 1);
}

# Remove a cell's wall in a given direction.
function rmWall(x, y, d,    i, oldCell, newCell) {
    oldCell = getCell(x, y);
    if (oldCell == -1) return;
    newCell = "";
    for (i = 1; i <= 4; i++) { # Ugly as concat of two substrings and a constant?.
        newCell = newCell (i == d ? "0" : substr(oldCell, i, 1));
    }
    newCell = newCell wasVisited(x, y);
    setCell(x, y, newCell);
}

# Determine if a cell has a wall in a given direction.
function hasWall(x, y, d,    cell) {
    cell = getCell(x, y);
    if (cell == -1) return 1; # Cells off edge always have all walls.
    return substr(getCell(x, y), d, 1);
}

# Plunk a cell into the maze.
function setCell(x, y, cell,    idx) {
    if (!isGoodXY(x, y)) return;
    maze[x, y] = cell
}

# Get a cell from the maze.
function getCell(x, y,    idx) {
    if (!isGoodXY(x, y)) return -1; # Bad cell marker.
    return maze[x, y];
}

# Are the given coordinates in the maze?
function isGoodXY(x, y) {
    if (x < 1 || x > width) return 0;
    if (y < 1 || y > height) return 0;
    return 1;
}

# Build the empty maze.
function resetMaze(    x, y) {
    delete maze;
    for (y = 1; y <= height; y++) {
        for (x = 1; x <= width; x++) {
            maze[x, y] = "11110"; # walls (up, down, left, right) and visited state.
        }
    }
}

# Random things properly scaled.

function getRandX() {
    return 1 + int(rand() * width);
}

function getRandY() {
    return 1 +int(rand() * height);
}

function getRandDir() {
    return 1 + int(rand() * 4);
}

function randomize() {
    "echo $RANDOM" | getline t;
    srand(t);
}
