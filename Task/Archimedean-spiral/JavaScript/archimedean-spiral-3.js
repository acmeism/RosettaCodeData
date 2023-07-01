const main = strColor => intCycles => {
    const
        ai = 0.05,
        ri = 0.1,
        cvs = document.getElementById('spiral'),
        ctx = cvs.getContext('2d'),
        s = cvs.width / 2,

        points = enumFromTo(1)(
            Math.PI * 2 * intCycles / ai
        ).map(i => [Math.cos, Math.sin].map(
            f => ri * i * f(ai * i) + s
        ));

    return (
        console.log(points),
        ctx.fillStyle = 'white',
        ctx.fillRect(0, 0, cvs.width, cvs.height),
        ctx.beginPath(),

        points.forEach(xy => ctx.lineTo(...xy)),

        ctx.strokeStyle = strColor,
        ctx.stroke(),
        points
    );
};

// enumFromTo :: Int -> Int -> [Int]
const enumFromTo = m => n =>
    Array.from({
        length: 1 + n - m
    }, (_, i) => m + i);
