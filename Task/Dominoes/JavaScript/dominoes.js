const EMPTY = -1;

const tableauOne = [
    [0, 5, 1, 3, 2, 2, 3, 1],
    [0, 5, 5, 0, 5, 2, 4, 6],
    [4, 3, 0, 3, 6, 6, 2, 0],
    [0, 6, 2, 3, 5, 1, 2, 6],
    [1, 1, 3, 0, 0, 2, 4, 5],
    [2, 1, 4, 3, 3, 4, 6, 6],
    [6, 4, 5, 1, 5, 4, 1, 4]
];

const tableauTwo = [
    [6, 4, 2, 2, 0, 6, 5, 0],
    [1, 6, 2, 3, 4, 1, 4, 3],
    [2, 1, 0, 2, 3, 5, 5, 1],
    [1, 3, 5, 0, 5, 6, 1, 0],
    [4, 2, 6, 0, 4, 0, 1, 1],
    [4, 4, 2, 0, 5, 3, 6, 3],
    [6, 6, 5, 2, 5, 3, 3, 4]
];

class Domino {
    constructor(aOne, aTwo) {
        this.one = Math.min(aOne, aTwo);
        this.two = Math.max(aOne, aTwo);
    }

    equals(other) {
        return this.one === other.one && this.two === other.two;
    }
}

class Point {
    constructor(aX, aY) {
        this.x = aX;
        this.y = aY;
    }

    equals(other) {
        return this.x === other.x && this.y === other.y;
    }
}

class Pattern {
    constructor(tableau, dominoes, points) {
        this.tableau = tableau;
        this.dominoes = dominoes;
        this.points = points;
    }
}

function firstEmptyCell(tableau) {
    for (let row = 0; row < tableau.length; ++row) {
        for (let col = 0; col < tableau[0].length; ++col) {
            if (tableau[row][col] === EMPTY) {
                return row * tableau[0].length + col;
            }
        }
    }
    return EMPTY;
}

function printLayout(pattern) {
    const output = Array(2 * pattern.tableau.length)
        .fill()
        .map(() => Array(2 * pattern.tableau[0].length - 1).fill(' '));

    for (let i = 0; i < pattern.points.length - 1; i += 2) {
        const x1 = pattern.points[i].x;
        const y1 = pattern.points[i].y;
        const x2 = pattern.points[i + 1].x;
        const y2 = pattern.points[i + 1].y;
        const n1 = pattern.tableau[x1][y1];
        const n2 = pattern.tableau[x2][y2];

        output[2 * x1][2 * y1] = String.fromCharCode('0'.charCodeAt(0) + n1);
        output[2 * x2][2 * y2] = String.fromCharCode('0'.charCodeAt(0) + n2);

        if (x1 === x2) {
            output[2 * x1][2 * y1 + 1] = '+';
        } else if (y1 === y2) {
            output[2 * x1 + 1][2 * y1] = '+';
        }
    }

    for (const line of output) {
        console.log(line.join(''));
    }
}

function findPatterns(tableau) {
    const nRows = tableau.length;
    const nCols = tableau[0].length;
    const dominoCount = (nRows * nCols) / 2;

    const emptyTableau = Array(nRows)
        .fill()
        .map(() => Array(nCols).fill(EMPTY));

    let patterns = [new Pattern(emptyTableau, [], [])];

    while (true) {
        const nextPatterns = [];

        for (const pattern of patterns) {
            const nextTableau = pattern.tableau.map(row => [...row]);
            const dominoes = [...pattern.dominoes];
            const points = [...pattern.points];

            const index = firstEmptyCell(nextTableau);
            if (index === EMPTY) continue;

            const row = Math.floor(index / nCols);
            const col = index % nCols;

            // Check down
            if (row + 1 < nRows && nextTableau[row + 1][col] === EMPTY) {
                const domino = new Domino(tableau[row][col], tableau[row + 1][col]);
                if (!dominoes.some(d => d.equals(domino))) {
                    const finalTableau = nextTableau.map(row => [...row]);
                    finalTableau[row][col] = tableau[row][col];
                    finalTableau[row + 1][col] = tableau[row + 1][col];

                    const nextDominoes = [...dominoes, domino];
                    const nextPoints = [...points, new Point(row, col), new Point(row + 1, col)];

                    nextPatterns.push(new Pattern(finalTableau, nextDominoes, nextPoints));
                }
            }

            // Check right
            if (col + 1 < nCols && nextTableau[row][col + 1] === EMPTY) {
                const domino = new Domino(tableau[row][col], tableau[row][col + 1]);
                if (!dominoes.some(d => d.equals(domino))) {
                    nextTableau[row][col] = tableau[row][col];
                    nextTableau[row][col + 1] = tableau[row][col + 1];

                    const nextDominoes = [...dominoes, domino];
                    const nextPoints = [...points, new Point(row, col), new Point(row, col + 1)];

                    nextPatterns.push(new Pattern(nextTableau, nextDominoes, nextPoints));
                }
            }
        }

        if (nextPatterns.length === 0) break;
        patterns = nextPatterns;
        if (patterns[0].dominoes.length === dominoCount) break;
    }

    return patterns;
}

// Main execution
for (const tableau of [tableauOne, tableauTwo]) {
    const patterns = findPatterns(tableau);
    console.log(`Layouts found: ${patterns.length}`);
    if (patterns.length > 0) {
        printLayout(patterns[0]);
    }
}
