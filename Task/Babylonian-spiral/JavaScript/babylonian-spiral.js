function babylonianSpiral(stepCount) {
    const tau = 2 * Math.PI;
    const squares = Array(stepCount + 1).fill(0).map((_, i) => i * i);
    const points = [[0, 0], [0, 1]];
    let norm = 1;

    for (let step = 0; step < stepCount - 2; ++step) {
        const previousPoint = points[points.length - 1];
        const theta = Math.atan2(previousPoint[1], previousPoint[0]);
        let candidates = [];

        while (candidates.length === 0) {
            norm += 1;
            for (let i = 0; i < stepCount; ++i) {
                const a = squares[i];
                if (a > norm / 2) break;
                for (let j = Math.floor(Math.sqrt(norm)) + 1; j >= 0; --j) {
                    const b = squares[j];
                    if (a + b < norm) break;
                    if (a + b === norm) {
                        const nextPoints = [
                            [i, j], [-i, j], [i, -j], [-i, -j],
                            [j, i], [-j, i], [j, -i], [-j, -i]
                        ];
                        candidates.push(...nextPoints);
                    }
                }
            }
        }

        let minimum = null;
        let minimumValue = tau;
        for (const candidate of candidates) {
            const value = (theta - Math.atan2(candidate[1], candidate[0]) + tau) % tau;
            if (value < minimumValue) {
                minimumValue = value;
                minimum = candidate;
            }
        }
        points.push(minimum);
    }

    // Accumulate points
    for (let i = 0; i < points.length - 1; ++i) {
        points[i + 1] = [
            points[i][0] + points[i + 1][0],
            points[i][1] + points[i + 1][1]
        ];
    }

    return points;
}

function main() {
    const points = babylonianSpiral(40);
    console.log("The first 40 points of the Babylonian spiral are:");
    for (let i = 0, column = 0; i < 40; ++i) {
        const pointStr = `(${points[i][0]}, ${points[i][1]})`;
        process.stdout.write(pointStr.padStart(10));
        if (++column % 10 === 0) {
            console.log();
        }
    }
}

main();
