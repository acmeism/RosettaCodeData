class Point {
    constructor(x = 0, y = 0) {
        this.x = x;
        this.y = y;
    }

    lessThan(other) {
        if (this.x === other.x) {
            return this.y < other.y;
        }
        return this.x < other.x;
    }

    equals(other) {
        return this.x === other.x && this.y === other.y;
    }

    notEquals(other) {
        return !this.equals(other);
    }
}

function flipped(points) {
    const result = [];
    for (const point of points) {
        result.push(new Point(-point.x, -point.y));
    }
    return result;
}

function quickselect(ls, index, lo = 0, hi = -1, depth = 0) {
    if (hi === -1) {
        hi = ls.length - 1;
    }

    if (lo === hi) {
        return ls[lo];
    }

    const pivot = lo + Math.floor(Math.random() * (hi - lo + 1));
    [ls[lo], ls[pivot]] = [ls[pivot], ls[lo]]; // swap

    let cur = lo;
    for (let run = lo + 1; run <= hi; run++) {
        if (ls[run] < ls[lo] || (ls[run] instanceof Point && ls[run].lessThan(ls[lo]))) {
            cur++;
            [ls[cur], ls[run]] = [ls[run], ls[cur]]; // swap
        }
    }

    [ls[cur], ls[lo]] = [ls[lo], ls[cur]]; // swap

    if (index < cur) {
        return quickselect(ls, index, lo, cur - 1, depth + 1);
    } else if (index > cur) {
        return quickselect(ls, index, cur + 1, hi, depth + 1);
    } else {
        return ls[cur];
    }
}

function bridge(pointsSet, verticalLine) {
    const points = Array.from(pointsSet);

    if (points.length === 2) {
        return [points[0], points[1]];
    }

    let candidates = new Set();
    let pairs = [];
    let modifyS = [...points];

    while (modifyS.length >= 2) {
        const p1 = modifyS.shift();
        const p2 = modifyS.shift();

        if (p1.lessThan(p2)) {
            pairs.push([p1, p2]);
        } else {
            pairs.push([p2, p1]);
        }
    }

    if (modifyS.length === 1) {
        candidates.add(modifyS[0]);
    }

    let slopes = [];

    for (let i = 0; i < pairs.length; i++) {
        const [pi, pj] = pairs[i];

        if (pi.x === pj.x) {
            candidates.add(pi.y > pj.y ? pi : pj);
            pairs.splice(i, 1);
            i--;
        } else {
            slopes.push((pi.y - pj.y) / (pi.x - pj.x));
        }
    }

    if (slopes.length === 0) {
        // Handle case when no valid pairs with slopes are found
        if (candidates.size >= 2) {
            const candidatesArray = Array.from(candidates);
            return [candidatesArray[0], candidatesArray[1]];
        }
        // If we don't have enough candidates, return the first pair
        return [points[0], points[1]];
    }

    const medianIndex = Math.floor(slopes.length / 2) - (slopes.length % 2 === 0 ? 1 : 0);
    const medianSlope = quickselect([...slopes], medianIndex);

    let small = [], equal = [], large = [];

    for (let i = 0; i < slopes.length; i++) {
        if (slopes[i] < medianSlope) {
            small.push(pairs[i]);
        } else if (slopes[i] === medianSlope) {
            equal.push(pairs[i]);
        } else {
            large.push(pairs[i]);
        }
    }

    let maxSlope = -Infinity;
    for (const point of points) {
        maxSlope = Math.max(maxSlope, point.y - medianSlope * point.x);
    }

    let maxSet = [];
    for (const point of points) {
        if (point.y - medianSlope * point.x === maxSlope) {
            maxSet.push(point);
        }
    }

    const left = maxSet.reduce((min, p) => min.lessThan(p) ? min : p, maxSet[0]);
    const right = maxSet.reduce((max, p) => !max.lessThan(p) ? max : p, maxSet[0]);

    if (left.x <= verticalLine && right.x > verticalLine) {
        return [left, right];
    }

    if (right.x <= verticalLine) {
        for (const pair of large) {
            candidates.add(pair[1]);
        }
        for (const pair of equal) {
            candidates.add(pair[1]);
        }
        for (const pair of small) {
            candidates.add(pair[0]);
            candidates.add(pair[1]);
        }
    }

    if (left.x > verticalLine) {
        for (const pair of small) {
            candidates.add(pair[0]);
        }
        for (const pair of equal) {
            candidates.add(pair[0]);
        }
        for (const pair of large) {
            candidates.add(pair[0]);
            candidates.add(pair[1]);
        }
    }

    return bridge(candidates, verticalLine);
}

function connect(lower, upper, pointsSet) {
    const points = Array.from(pointsSet);

    if (lower.equals(upper)) {
        return [lower];
    }

    const pointsVec = [...points];
    const midIndex = Math.floor(pointsVec.length / 2) - 1;

    const maxLeft = quickselect([...pointsVec], midIndex);
    const minRight = quickselect([...pointsVec], midIndex + 1);

    const [left, right] = bridge(new Set(points), (maxLeft.x + minRight.x) / 2);

    let pointsLeft = new Set([left]);
    let pointsRight = new Set([right]);

    for (const point of points) {
        if (point.x < left.x) {
            pointsLeft.add(point);
        } else if (point.x > right.x) {
            pointsRight.add(point);
        }
    }

    const leftResult = connect(lower, left, pointsLeft);
    const rightResult = connect(right, upper, pointsRight);

    return [...leftResult, ...rightResult];
}

function upperHull(pointsSet) {
    const points = Array.from(pointsSet);

    // Find the leftmost point
    let lower = points.reduce((min, p) => p.x < min.x || (p.x === min.x && p.y < min.y) ? p : min, points[0]);

    // Find the lowest point with the same x-coordinate as the minimum
    for (const point of points) {
        if (point.x === lower.x && point.y > lower.y) {
            lower = point;
        }
    }

    // Find the rightmost point
    const upper = points.reduce((max, p) => p.x > max.x || (p.x === max.x && p.y > max.y) ? p : max, points[0]);

    const filteredPoints = new Set([lower, upper]);
    for (const p of points) {
        if (lower.x < p.x && p.x < upper.x) {
            filteredPoints.add(p);
        }
    }

    return connect(lower, upper, filteredPoints);
}

function convexHull(pointsSet) {
    const points = Array.from(pointsSet);
    const upper = upperHull(new Set(points));

    const flippedPoints = new Set();
    for (const p of points) {
        flippedPoints.add(new Point(-p.x, -p.y));
    }

    const flippedUpper = upperHull(flippedPoints);
    const lower = flipped(flippedUpper);

    if (upper[upper.length - 1].equals(lower[0])) {
        upper.pop();
    }

    if (upper[0].equals(lower[lower.length - 1])) {
        lower.pop();
    }

    return [...upper, ...lower];
}

// Test case for a simplex
function main() {
    // Create points for a 2D projection of a 3D simplex
    const points = new Set([
        new Point(0.0, 0.0),   // projection of [0.0, 0.0, 0.0]
        new Point(1.0, 0.0),   // projection of [1.0, 0.0, 0.0]
        new Point(0.0, 1.0),   // projection of [0.0, 1.0, 0.0]
        new Point(0.5, 0.5)    // projection of [0.0, 0.0, 1.0] (projected to 2D)
    ]);

    console.log("Input points:");
    for (const p of points) {
        console.log(`(${p.x}, ${p.y})`);
    }

    const hull = convexHull(points);

    console.log("\nConvex hull points:");
    for (const p of hull) {
        console.log(`(${p.x}, ${p.y})`);
    }
}

main();
