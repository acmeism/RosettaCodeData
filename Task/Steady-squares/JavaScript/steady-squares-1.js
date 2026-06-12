// Steady squares

function steady(n) {
    // Result: true if n * n is steady; false otherwise.
    var mask = 1;
    for (var d = n; d != 0; d = Math.floor(d / 10))
        mask *= 10;
    return (n * n) % mask == n;
}

for (var i = 1; i < 10000; i++)
    if (steady(i))
        console.log(i.toString().padStart(4, ' ') + "^2 = " +
            (i * i).toString().padStart(8, ' '));
