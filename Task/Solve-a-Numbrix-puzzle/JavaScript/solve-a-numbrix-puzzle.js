const example1 = [
    "00,00,00,00,00,00,00,00,00",
    "00,00,46,45,00,55,74,00,00",
    "00,38,00,00,43,00,00,78,00",
    "00,35,00,00,00,00,00,71,00",
    "00,00,33,00,00,00,59,00,00",
    "00,17,00,00,00,00,00,67,00",
    "00,18,00,00,11,00,00,64,00",
    "00,00,24,21,00,01,02,00,00",
    "00,00,00,00,00,00,00,00,00",
];

const example2 = [
    "00,00,00,00,00,00,00,00,00",
    "00,11,12,15,18,21,62,61,00",
    "00,06,00,00,00,00,00,60,00",
    "00,33,00,00,00,00,00,57,00",
    "00,32,00,00,00,00,00,56,00",
    "00,37,00,01,00,00,00,73,00",
    "00,38,00,00,00,00,00,72,00",
    "00,43,44,47,48,51,76,77,00",
    "00,00,00,00,00,00,00,00,00",
];

const moves = [[1, 0], [0, 1], [-1, 0], [0, -1]];

let grid, clues, totalToFill;

function solve(r, c, count, nextClue) {
    if (count > totalToFill) {
        return true;
    }

    const back = grid[r][c];

    if (back !== 0 && back !== count) {
        return false;
    }

    if (back === 0 && nextClue < clues.length && clues[nextClue] === count) {
        return false;
    }

    let newNextClue = nextClue;
    if (back === count) {
        newNextClue++;
    }

    grid[r][c] = count;
    for (const move of moves) {
        if (solve(r + move[1], c + move[0], count + 1, newNextClue)) {
            return true;
        }
    }
    grid[r][c] = back;
    return false;
}

function printResult(n) {
    console.log(`Solution for example ${n}:`);
    for (const row of grid) {
        let line = "";
        for (const i of row) {
            if (i === -1) {
                continue;
            }
            line += `${i.toString().padStart(2)} `;
        }
        console.log(line);
    }
}

function main() {
    const boards = [example1, example2];

    for (let n = 0; n < boards.length; n++) {
        const board = boards[n];
        const nRows = board.length + 2;
        const nCols = board[0].split(',').length + 2;
        let startRow = 0, startCol = 0;
        grid = Array(nRows).fill().map(() => Array(nCols).fill(-1));
        totalToFill = (nRows - 2) * (nCols - 2);
        let lst = [];

        for (let r = 0; r < nRows; r++) {
            if (r >= 1 && r < nRows - 1) {
                const row = board[r - 1].split(',');
                for (let c = 1; c < nCols - 1; c++) {
                    const val = parseInt(row[c - 1]);
                    if (val > 0) {
                        lst.push(val);
                    }
                    if (val === 1) {
                        startRow = r;
                        startCol = c;
                    }
                    grid[r][c] = val;
                }
            }
        }

        lst.sort((a, b) => a - b);
        clues = lst;
        if (solve(startRow, startCol, 1, 0)) {
            printResult(n + 1);
        }
    }
}

main();
