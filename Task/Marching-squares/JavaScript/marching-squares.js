// Direction constants
const E = 0;
const N = 1;
const W = 2;
const S = 3;

// X generates coordinate pairs for a grid of given dimensions
function X(a, b) {
    const c = [];
    for (let aa = 0; aa <= a; aa++) {
        for (let bb = 0; bb <= b; bb++) {
            c.push([aa, bb]);
        }
    }
    return c;
}

// any checks if any element in the array equals val
function any(arr, val) {
    return arr.includes(val);
}

// identifyPerimeter identifies the perimeter of a shape in a 2D matrix
function identifyPerimeter(data) {
    for (const coords of X(data[0].length - 1, data.length - 1)) {
        const [x, y] = coords;

        if (y < data.length && x < data[0].length && data[y][x] !== 0) {
            let path = '';
            let cx = x, cy = y;
            let d = 0, p = 0;

            do {
                let mask = 0;

                const vals = [[0, 0, 1], [1, 0, 2], [0, 1, 4], [1, 1, 8]];
                for (const val of vals) {
                    const [dx, dy, b] = val;
                    const mx = cx + dx;
                    const my = cy + dy;

                    if (mx > 0 && my > 0 && my - 1 < data.length &&
                        mx - 1 < data[0].length && data[my - 1][mx - 1] !== 0) {
                        mask += b;
                    }
                }

                if (any([1, 5, 13], mask)) {
                    d = N;
                }
                if (any([2, 3, 7], mask)) {
                    d = E;
                }
                if (any([4, 12, 14], mask)) {
                    d = W;
                }
                if (any([8, 10, 11], mask)) {
                    d = S;
                }
                if (mask === 6) {
                    if (p === N) {
                        d = W;
                    } else {
                        d = E;
                    }
                }
                if (mask === 9) {
                    if (p === E) {
                        d = N;
                    } else {
                        d = S;
                    }
                }

                const dirChars = ['E', 'N', 'W', 'S'];
                path += dirChars[d];
                p = d;

                const dxVals = [1, 0, -1, 0];
                const dyVals = [0, -1, 0, 1];
                cx += dxVals[d];
                cy += dyVals[d];

            } while (!(cx === x && cy === y));

            return { x: x, y: -y, path: path };
        }
    }

    console.log("That did not work out...");
    return null;
}

// Example usage
const M = [
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 1, 1, 0],
    [0, 0, 1, 1, 0],
    [0, 0, 0, 1, 0],
    [0, 0, 0, 0, 0]
];

const result = identifyPerimeter(M);
if (result) {
    console.log(`X: ${result.x}, Y: ${result.y}, Path: ${result.path}`);
}
