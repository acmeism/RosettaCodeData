function main() {
    const start = Date.now();
    const pieces = ["Q", "B", "K"];
    const limits = { "Q": 10, "B": 10, "K": 10 };
    const names = { "Q": "Queens", "B": "Bishops", "K": "Knights" };

    for (const piece of pieces) {
        console.log(names[piece]);
        console.log("=======\n");

        for (let n = 1; ; n++) {
            let board = Array(n).fill(null).map(() => Array(n).fill(false));
            let diag1 = null;
            let diag2 = null;
            let diag1Lookup = null;
            let diag2Lookup = null;

            if (piece !== "K") {
                diag1 = Array(n).fill(null).map(() => Array(n).fill(0));
                for (let i = 0; i < n; i++) {
                    for (let j = 0; j < n; j++) {
                        diag1[i][j] = i + j;
                    }
                }

                diag2 = Array(n).fill(null).map(() => Array(n).fill(0));
                for (let i = 0; i < n; i++) {
                    for (let j = 0; j < n; j++) {
                        diag2[i][j] = i - j + n - 1;
                    }
                }

                diag1Lookup = Array(2 * n - 1).fill(false);
                diag2Lookup = Array(2 * n - 1).fill(false);
            }

            let minCount = Number.MAX_SAFE_INTEGER;
            let layout = "";

            for (let maxCount = 1; maxCount <= n * n; maxCount++) {
                const result = placePiece(piece, 0, maxCount, n, board, diag1, diag2, diag1Lookup, diag2Lookup, minCount, layout);
                minCount = result.minCount;
                layout = result.layout;

                if (minCount <= n * n) {
                    break;
                }
            }

            console.log(`${n.toString().padStart(2, ' ')} x ${n.toString().padEnd(2, ' ')} : ${minCount}`);
            if (n === limits[piece]) {
                console.log(`\n${names[piece]} on a ${n} x ${n} board:`);
                console.log("\n" + layout);
                break;
            }
        }
    }

    const elapsed = Date.now() - start;
    console.log(`Took ${elapsed}ms`);
}


function isAttacked(piece, row, col, n, board, diag1, diag2, diag1Lookup, diag2Lookup) {
    if (piece === "Q") {
        for (let i = 0; i < n; i++) {
            if (board[i][col] || board[row][i]) {
                return true;
            }
        }
        if (diag1Lookup[diag1[row][col]] || diag2Lookup[diag2[row][col]]) {
            return true;
        }
    } else if (piece === "B") {
        if (diag1Lookup[diag1[row][col]] || diag2Lookup[diag2[row][col]]) {
            return true;
        }
    } else { // piece == "K"
        if (board[row][col]) {
            return true;
        }
        if (row + 2 < n && col - 1 >= 0 && board[row + 2][col - 1]) {
            return true;
        }
        if (row - 2 >= 0 && col - 1 >= 0 && board[row - 2][col - 1]) {
            return true;
        }
        if (row + 2 < n && col + 1 < n && board[row + 2][col + 1]) {
            return true;
        }
        if (row - 2 >= 0 && col + 1 < n && board[row - 2][col + 1]) {
            return true;
        }
        if (row + 1 < n && col + 2 < n && board[row + 1][col + 2]) {
            return true;
        }
        if (row - 1 >= 0 && col + 2 < n && board[row - 1][col + 2]) {
            return true;
        }
        if (row + 1 < n && col - 2 >= 0 && board[row + 1][col - 2]) {
            return true;
        }
        if (row - 1 >= 0 && col - 2 >= 0 && board[row - 1][col - 2]) {
            return true;
        }
    }
    return false;
}

function abs(i) {
    if (i < 0) {
        i = -i;
    }
    return i;
}

function attacks(piece, row, col, trow, tcol) {
    if (piece === "Q") {
        return row === trow || col === tcol || abs(row - trow) === abs(col - tcol);
    } else if (piece === "B") {
        return abs(row - trow) === abs(col - tcol);
    } else { // piece == "K"
        const rd = abs(trow - row);
        const cd = abs(tcol - col);
        return (rd === 1 && cd === 2) || (rd === 2 && cd === 1);
    }
}

function storeLayout(piece, board, n) {
    let sb = "";
    for (const row of board) {
        for (const cell of row) {
            if (cell) {
                sb += piece + " ";
            } else {
                sb += ". ";
            }
        }
        sb += "\n";
    }
    return sb;
}


function placePiece(piece, countSoFar, maxCount, n, board, diag1, diag2, diag1Lookup, diag2Lookup, minCount, layout) {
    if (countSoFar >= minCount) {
        return {minCount: minCount, layout:layout};
    }
    let allAttacked = true;
    let ti = 0;
    let tj = 0;
    for (let i = 0; i < n; i++) {
        for (let j = 0; j < n; j++) {
            if (!isAttacked(piece, i, j, n, board, diag1, diag2, diag1Lookup, diag2Lookup)) {
                allAttacked = false;
                ti = i;
                tj = j;
                break;
            }
        }
        if (!allAttacked) {
            break;
        }
    }
    if (allAttacked) {
        minCount = countSoFar;
        layout = storeLayout(piece, board, n);
        return {minCount: minCount, layout: layout};
    }
    if (countSoFar <= maxCount) {
        let si = ti;
        let sj = tj;
        if (piece === "K") {
            si = si - 2;
            sj = sj - 2;
            if (si < 0) {
                si = 0;
            }
            if (sj < 0) {
                sj = 0;
            }
        }

        for (let i = si; i < n; i++) {
            for (let j = sj; j < n; j++) {
                if (!isAttacked(piece, i, j, n, board, diag1, diag2, diag1Lookup, diag2Lookup)) {
                    if ((i === ti && j === tj) || attacks(piece, i, j, ti, tj)) {
                        board[i][j] = true;
                        if (piece !== "K") {
                            diag1Lookup[diag1[i][j]] = true;
                            diag2Lookup[diag2[i][j]] = true;
                        }

                        const nextResult = placePiece(piece, countSoFar + 1, maxCount, n, board, diag1, diag2, diag1Lookup, diag2Lookup, minCount, layout);
                        minCount = nextResult.minCount;
                        layout = nextResult.layout;

                        board[i][j] = false;
                        if (piece !== "K") {
                            diag1Lookup[diag1[i][j]] = false;
                            diag2Lookup[diag2[i][j]] = false;
                        }
                    }
                }
            }
        }
    }

    return {minCount: minCount, layout: layout};
}

main();
