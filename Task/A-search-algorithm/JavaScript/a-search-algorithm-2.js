function manhattan(x1, y1, x2, y2) {
    return Math.abs(x1 - x2) + Math.abs(y1 - y2);
}

function aStar (board, startx, starty, goalx, goaly,
    open = Array(8 * 8).fill(null),
    closed = Array(8 * 8).fill(null),
    current = {
        "coord": [startx, starty],
        "distance": 0,
        "heuristic": manhattan(startx, starty, goalx, goaly),
        "previous": null
    }) {
    const [x, y] = [...current.coord];

    if (x === goalx && y === goaly) {
        closed[x + y * 8] = current;
        return (lambda = (closed, x, y, startx, starty) => {
            if (x === startx && y === starty) {
                return [[x, y]];
            }
            const [px, py] = closed.filter(e => e !== null)
                .find(({coord: [nx, ny]}) => {
                    return  nx === x && ny === y
                }).previous;
            return lambda(closed, px, py, startx, starty).concat([[x,y]]);
        })(closed, x, y, startx, starty);
    }

    let newOpen = open.slice();
    [
        [x + 1, y + 1], [x - 1, y - 1], [x + 1, y], [x, y + 1],
        [x - 1, y + 1], [x + 1, y - 1], [x - 1, y], [x, y - 1]
    ].filter(([x,y]) => x >= 0 && x < 8 &&
                        y >= 0 && y < 8 &&
                        closed[x + y * 8] === null
    ).forEach(([x,y]) => {
        newOpen[x + y * 8] = {
            "coord": [x,y],
            "distance": current.distance + (board[x + y * 8] === 1 ? 100 : 1),
            "heuristic": manhattan(x, y, goalx, goaly),
            "previous": [...current.coord]
        };
    });

    let newClosed = closed.slice();
    newClosed[x + y * 8] = current;

    const [newCurrent,] = newOpen.filter(e => e !== null)
        .sort((a, b) => {
            return (a.distance + a.heuristic) - (b.distance + b.heuristic);
        });

    const [newx, newy] = [...newCurrent.coord];
    newOpen[newx + newy * 8] = null;

    return aStar(board, startx, starty, goalx, goaly,
        newOpen, newClosed, newCurrent);
}

const board = [
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,1,1,1,0,
    0,0,1,0,0,0,1,0,
    0,0,1,0,0,0,1,0,
    0,0,1,1,1,1,1,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0
];

console.log(aStar(board, 0,0, 7,7));
