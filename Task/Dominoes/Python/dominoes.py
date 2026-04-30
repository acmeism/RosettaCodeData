from typing import Final, Generator, Iterator, Optional
import random
from dataclasses import dataclass

# Use a cryptographically secure random number generator
rnd = random.SystemRandom()

# Sentinel value to represent an empty/unfilled cell in the grid during solving
EMPTY: Final = -1

# Predefined 8x8 grid of integers (0–6), representing a domino puzzle board
tableau = [
    [0, 5, 1, 3, 2, 2, 3, 1],
    [0, 5, 5, 0, 5, 2, 4, 6],
    [4, 3, 0, 3, 6, 6, 2, 0],
    [0, 6, 2, 3, 5, 1, 2, 6],
    [1, 1, 3, 0, 0, 2, 4, 5],
    [2, 1, 4, 3, 3, 4, 6, 6],
    [6, 4, 5, 1, 5, 4, 1, 4]
]
# Randomly generated 8x8 grid using values 0–6 for testing alternative puzzles
customTableau = [[rnd.randint(0, 6) for _ in range(8)] for _ in range(8)]

# # Represents a domino tile with two ends (a and b).
# It is treated as unordered (i.e., (1,2) == (2,1)) via custom hash and equality.
@dataclass(frozen=True)
class Domino:
    a: int
    b: int

    # Hash based on sorted tuple so (a,b) and (b,a) are considered the same domino
    def __hash__(self) -> int:
        return hash(tuple(sorted((self.a, self.b))))

    # String representation for debugging/printing
    def __repr__(self) -> str:
        return f"({self.a},{self.b})"

# Represents a coordinate (x, y) on the grid
@dataclass
class Point:
    x: int
    y: int

    def __repr__(self) -> str:
        return f"({self.x},{self.y})"

# Bundles a solved layout: the filled grid, list of placed dominoes, and their positions
@dataclass
class Pattern:
    tableau: list[list[int]]  # Final filled grid (copied from solver state)
    dominoes: list[Domino]    # List of dominoes used (in placement order)
    points: list[Point]       # Paired list of points indicating domino placements

def findPatterns(
    source: list[list[int]],
    *,
    maxSolutions: Optional[int] = None,
    asGenerator: bool = False
) -> Iterator[Pattern] | list[Pattern]:
    """
    Solves a domino tiling puzzle where each domino must be unique (unordered pair),
    and every cell must be covered exactly once.

    Args:
        source: 2D grid of integers (0-6) representing the puzzle.
        maxSolutions: Optional limit on number of solutions to find.
        asGenerator: If True, returns a generator yielding solutions one by one;
                     otherwise returns a list of all found solutions (up to maxSolutions).

    Returns:
        Either a list of Pattern objects or a generator yielding them.
    """
    nRows = len(source)
    assert nRows > 0
    nCols = len(source[0])
    # Ensure all rows have the same length
    for row in source:
        if len(row) != nCols:
            raise ValueError("All rows must have same length")

    # Total number of dominoes needed to cover the board
    dominoGoal = (nRows * nCols) // 2
    # If total cells is odd, tiling is impossible
    if (nRows * nCols) % 2 != 0:
        return []

    # Working grid: EMPTY (-1) means not yet covered
    grid = [[EMPTY for _ in range(nCols)] for _ in range(nRows)]
    usedDominoes: set[Domino] = set()    # For O(1) uniqueness checks
    usedDominoesList: list[Domino] = []  # To preserve order of placement
    points: list[Point] = []             # Stores paired coordinates of domino placements
    solutions: list[Pattern] = []        # Accumulates found solutions

    def findFirstEmpty(startIndex: int = 0) -> Optional[int]:
        """Find the first empty cell in row-major order starting from `startIndex`."""
        total = nRows * nCols
        for i in range(startIndex, total):
            r = i // nCols
            c = i % nCols
            if grid[r][c] == EMPTY:
                return i
        return  # No empty cell found

    def collectSolution() -> Pattern:
        """Create a deep copy of the current solution state."""
        tableauCopy = [row[:] for row in grid]
        return Pattern(tableauCopy, usedDominoesList.copy(), points.copy())

    def dfs(startIndex: int = 0):
        """
        Depth-first search to place dominoes recursively.
        Stops early if `maxSolutions` is reached.
        """
        if maxSolutions is not None and len(solutions) >= maxSolutions:
            return

        index = findFirstEmpty(startIndex)
        if index is None:
            # All cells filled — check if we used exactly the right number of dominoes
            if len(usedDominoesList) == dominoGoal:
                solutions.append(collectSolution())
            return

        r = index // nCols
        c = index % nCols

        # Try placing a vertical domino (downwards)
        if r + 1 < nRows and grid[r+1][c] == EMPTY:
            d = Domino(source[r][c], source[r+1][c])
            if d not in usedDominoes:
                # Place domino
                grid[r][c] = source[r][c]
                grid[r+1][c] = source[r+1][c]
                usedDominoes.add(d)
                usedDominoesList.append(d)
                points.extend([Point(r, c), Point(r+1, c)])

                dfs(index+1)

                # Backtrack
                points.pop()
                points.pop()
                usedDominoesList.pop()
                usedDominoes.remove(d)
                grid[r][c] = EMPTY
                grid[r+1][c] = EMPTY

                # Early exit if enough solutions found
                if maxSolutions is not None and len(solutions) >= maxSolutions:
                    return

        # Try placing a horizontal domino (rightwards)
        if c + 1 < nCols and grid[r][c+1] == EMPTY:
            d = Domino(source[r][c], source[r][c+1])
            if d not in usedDominoes:
                # Place domino
                grid[r][c] = source[r][c]
                grid[r][c+1] = source[r][c+1]
                usedDominoes.add(d)
                usedDominoesList.append(d)
                points.extend([Point(r, c), Point(r, c+1)])

                dfs(index+1)

                # Backtrack
                points.pop()
                points.pop()
                usedDominoesList.pop()
                usedDominoes.remove(d)
                grid[r][c] = EMPTY
                grid[r][c+1] = EMPTY

                # Early exit if enough solutions found
                if maxSolutions is not None and len(solutions) >= maxSolutions:
                    return

    # If requested, return a generator instead of collecting all solutions upfront
    if asGenerator:
        def gen() -> Generator:
            def dfsGen(startIndex: int = 0) -> Generator:
                """Generator version of DFS that yields solutions as they are found."""
                index = findFirstEmpty(startIndex)
                if index is None:
                    if len(usedDominoesList) == dominoGoal:
                        yield collectSolution()
                    return
                r = index // nCols
                c = index % nCols

                # Vertical placement
                if r + 1 < nRows and grid[r+1][c] == EMPTY:
                    d = Domino(source[r][c], source[r+1][c])
                    if d not in usedDominoes:
                        grid[r][c] = source[r][c]
                        grid[r+1][c] = source[r+1][c]
                        usedDominoes.add(d)
                        usedDominoesList.append(d)
                        points.extend([Point(r, c), Point(r+1, c)])

                        yield from dfsGen(index+1)

                        # Backtrack
                        points.pop()
                        points.pop()
                        usedDominoesList.pop()
                        usedDominoes.remove(d)
                        grid[r][c] = EMPTY
                        grid[r+1][c] = EMPTY

                # Horizontal placement
                if c + 1 < nCols and grid[r][c+1] == EMPTY:
                    d = Domino(source[r][c], source[r][c+1])
                    if d not in usedDominoes:
                        grid[r][c] = source[r][c]
                        grid[r][c+1] = source[r][c+1]
                        usedDominoes.add(d)
                        usedDominoesList.append(d)
                        points.extend([Point(r, c), Point(r, c+1)])

                        yield from dfsGen(index+1)

                        # Backtrack
                        points.pop()
                        points.pop()
                        usedDominoesList.pop()
                        usedDominoes.remove(d)
                        grid[r][c] = EMPTY
                        grid[r][c+1] = EMPTY

            yield from dfsGen(0)

        return gen()

    # Run standard DFS and return collected solutions
    dfs(0)
    return solutions

def printLayout(pattern: Pattern):
    """
    Pretty-prints a solved domino layout with ASCII art:
    - Numbers represent tile values.
    - '-' connects horizontally adjacent domino halves.
    - '|' connects vertically adjacent domino halves.
    """
    nRows = len(pattern.tableau)
    nCols = len(pattern.tableau[0]) if nRows > 0 else 0

    # Create a character grid large enough to show connections
    output = [[" " for _ in range(nCols*3-1)] for _ in range(nRows*2-1)]

    # Place numbers in the output grid
    for i in range(nRows):
        for j in range(nCols):
            val = pattern.tableau[i][j]
            ch = "?" if val == EMPTY else str(val)
            output[i*2][j*3] = ch

    # Draw connections between paired points (domino halves)
    for k in range(0, len(pattern.points), 2):
        if k + 1 >= len(pattern.points):
            break

        p0 = pattern.points[k]
        p1 = pattern.points[k+1]

        # Horizontal domino: same row, adjacent columns
        if p0.x == p1.x and p0.y + 1 == p1.y:
            output[p0.x*2][p0.y*3+1] = "-"
            output[p0.x*2][p0.y*3+2] = "-"
        # Vertical domino: same column, adjacent rows
        elif p0.y == p1.y and p0.x+1 == p1.x:
            output[p0.x*2+1][p0.y*3] = "|"

    # Print the final layout line by line
    for line in output:
        print("".join(line))

# Entry point: solve both the predefined and random tableaus, print first solution if found
if __name__ == "__main__":
    for t in [tableau, customTableau]:
        sols = findPatterns(t, maxSolutions=1)
        print(f"Layouts found: {len(sols)}")
        if len(sols) > 0:
            printLayout(sols[0])
