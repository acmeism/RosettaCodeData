class Sokoban {
    constructor(board) {
        this.nCols = board[0].length;
        let destBuf = '';
        let currBuf = '';

        for (let r = 0; r < board.length; r++) {
            for (let c = 0; c < this.nCols; c++) {
                const ch = board[r].charAt(c);

                destBuf += (ch !== '$' && ch !== '@') ? ch : ' ';
                currBuf += (ch !== '.') ? ch : ' ';

                if (ch === '@') {
                    this.playerX = c;
                    this.playerY = r;
                }
            }
        }
        this.destBoard = destBuf;
        this.currBoard = currBuf;
    }

    move(x, y, dx, dy, trialBoard) {
        const newPlayerPos = (y + dy) * this.nCols + x + dx;

        if (trialBoard.charAt(newPlayerPos) !== ' ') {
            return null;
        }

        const trial = trialBoard.split('');
        trial[y * this.nCols + x] = ' ';
        trial[newPlayerPos] = '@';

        return trial.join('');
    }

    push(x, y, dx, dy, trialBoard) {
        const newBoxPos = (y + 2 * dy) * this.nCols + x + 2 * dx;

        if (trialBoard.charAt(newBoxPos) !== ' ') {
            return null;
        }

        const trial = trialBoard.split('');
        trial[y * this.nCols + x] = ' ';
        trial[(y + dy) * this.nCols + x + dx] = '@';
        trial[newBoxPos] = '$';

        return trial.join('');
    }

    isSolved(trialBoard) {
        for (let i = 0; i < trialBoard.length; i++) {
            if ((this.destBoard.charAt(i) === '.') !== (trialBoard.charAt(i) === '$')) {
                return false;
            }
        }
        return true;
    }

    solve() {
        class Board {
            constructor(cur, sol, x, y) {
                this.cur = cur;
                this.sol = sol;
                this.x = x;
                this.y = y;
            }
        }

        const dirLabels = [['u', 'U'], ['r', 'R'], ['d', 'D'], ['l', 'L']];
        const dirs = [[0, -1], [1, 0], [0, 1], [-1, 0]];

        const history = new Set();
        const open = [];

        history.add(this.currBoard);
        open.push(new Board(this.currBoard, "", this.playerX, this.playerY));

        while (open.length > 0) {
            const item = open.shift(); // poll() equivalent
            const cur = item.cur;
            const sol = item.sol;
            const x = item.x;
            const y = item.y;

            for (let i = 0; i < dirs.length; i++) {
                let trial = cur;
                const dx = dirs[i][0];
                const dy = dirs[i][1];

                // are we standing next to a box?
                if (trial.charAt((y + dy) * this.nCols + x + dx) === '$') {
                    // can we push it?
                    trial = this.push(x, y, dx, dy, trial);
                    if (trial !== null) {
                        // or did we already try this one?
                        if (!history.has(trial)) {
                            const newSol = sol + dirLabels[i][1];

                            if (this.isSolved(trial)) {
                                return newSol;
                            }

                            open.push(new Board(trial, newSol, x + dx, y + dy));
                            history.add(trial);
                        }
                    }
                // otherwise try changing position
                } else {
                    trial = this.move(x, y, dx, dy, trial);
                    if (trial !== null) {
                        if (!history.has(trial)) {
                            const newSol = sol + dirLabels[i][0];
                            open.push(new Board(trial, newSol, x + dx, y + dy));
                            history.add(trial);
                        }
                    }
                }
            }
        }
        return "No solution";
    }
}

// Example usage
const level = "#######,#     #,#     #,#. #  #,#. $$ #,#.$$  #,#.#  @#,#######";
const sokoban = new Sokoban(level.split(","));
console.log(sokoban.solve());
