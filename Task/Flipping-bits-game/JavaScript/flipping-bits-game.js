function numOfRows(board) { return board.length; }
function numOfCols(board) { return board[0].length; }
function boardToString(board) {
    // First the top-header
    var header = '   ';
    for (var c = 0; c < numOfCols(board); c++)
        header += c + ' ';

    // Then the side-header + board
    var sideboard = [];
    for (var r = 0; r < numOfRows(board); r++) {
        sideboard.push(r + ' [' + board[r].join(' ') + ']');
    }

    return header + '\n' + sideboard.join('\n');
}
function flipRow(board, row) {
    for (var c = 0; c < numOfCols(board); c++) {
        board[row][c] = 1 - board[row][c];
    }
}
function flipCol(board, col) {
    for (var r = 0; r < numOfRows(board); r++) {
        board[r][col] = 1 - board[r][col];
    }
}

function playFlippingBitsGame(rows, cols) {
    rows = rows | 3;
    cols = cols | 3;
    var targetBoard = [];
    var manipulatedBoard = [];
    // Randomly generate two identical boards.
    for (var r = 0; r < rows; r++) {
        targetBoard.push([]);
        manipulatedBoard.push([]);
        for (var c = 0; c < cols; c++) {
            targetBoard[r].push(Math.floor(Math.random() * 2));
            manipulatedBoard[r].push(targetBoard[r][c]);
        }
    }
    // Naive-scramble one of the boards.
    while (boardToString(targetBoard) == boardToString(manipulatedBoard)) {
        var scrambles = rows * cols;
        while (scrambles-- > 0) {
            if (0 == Math.floor(Math.random() * 2)) {
                flipRow(manipulatedBoard, Math.floor(Math.random() * rows));
            }
            else {
                flipCol(manipulatedBoard, Math.floor(Math.random() * cols));
            }
        }
    }
    // Get the user to solve.
    alert(
        'Try to match both boards.\n' +
        'Enter `r<num>` or `c<num>` to manipulate a row or col or enter `q` to quit.'
        );
    var input = '', letter, num, moves = 0;
    while (boardToString(targetBoard) != boardToString(manipulatedBoard) && input != 'q') {
        input = prompt(
            'Target:\n' + boardToString(targetBoard) +
            '\n\n\n' +
            'Board:\n' + boardToString(manipulatedBoard)
            );
        try {
            letter = input.charAt(0);
            num = parseInt(input.slice(1));
            if (letter == 'q')
				break;
            if (isNaN(num)
                || (letter != 'r' && letter != 'c')
                || (letter == 'r' && num >= rows)
                || (letter == 'c' && num >= cols)
                ) {
                throw new Error('');
            }
            if (letter == 'r') {
                flipRow(manipulatedBoard, num);
            }
            else {
                flipCol(manipulatedBoard, num);
            }
            moves++;
        }
        catch(e) {
            alert('Uh-oh, there seems to have been an input error');
        }
    }
    if (input == 'q') {
        alert('~~ Thanks for playing ~~');
    }
    else {
        alert('Completed in ' + moves + ' moves.');
    }
}
