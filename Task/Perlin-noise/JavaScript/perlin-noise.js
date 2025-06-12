let p = Array(512).fill(0);

function fade(t) {
    return t * t * t * (t * (t * 6 - 15) + 10);
}

function lerp(t, a, b) {
    return a + t * (b - a);
}

function grad(hash, x, y, z) {
    const h = hash & 15;                           // CONVERT LOW 4 BITS OF HASH CODE
    const u = h < 8 ? x : y;                       // INTO 12 GRADIENT DIRECTIONS.
    const v = h < 4 ? y : (h == 12 || h == 14) ? x : z;
    return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v);
}

function perlinNoise(x, y, z) {
    const X = Math.floor(x) & 0xff;                // FIND UNIT CUBE THAT
    const Y = Math.floor(y) & 0xff;                // CONTAINS POINT.
    const Z = Math.floor(z) & 0xff;
    x -= Math.floor(x);                            // FIND RELATIVE X,Y,Z
    y -= Math.floor(y);                            // OF POINT IN CUBE.
    z -= Math.floor(z);

    const u = fade(x);                             // COMPUTE FADE CURVES
    const v = fade(y);                             // FOR EACH OF X,Y,Z.
    const w = fade(z);

    const A  = p[X]     + Y;
    const AA = p[A]     + Z;
    const AB = p[A + 1] + Z;                       // HASH COORDINATES OF
    const B  = p[X + 1] + Y;
    const BA = p[B]     + Z;
    const BB = p[B + 1] + Z;                       // THE 8 CUBE CORNERS,

    return lerp(w, lerp(v, lerp(u, grad(p[AA    ], x    , y    , z    ),    // AND ADD
                               grad(p[BA    ], x - 1, y    , z    )),   // BLENDED
                       lerp(u, grad(p[AB    ], x    , y - 1, z    ),    // RESULTS
                               grad(p[BB    ], x - 1, y - 1, z    ))),  // FROM  8
               lerp(v, lerp(u, grad(p[AA + 1], x    , y    , z - 1),    // CORNERS
                               grad(p[BA + 1], x - 1, y    , z - 1)),   // OF CUBE
                       lerp(u, grad(p[AB + 1], x    , y - 1, z - 1),
                               grad(p[BB + 1], x - 1, y - 1, z - 1))));
}

async function readFile(fileName) {
    try {
        const response = await fetch('../' + fileName);
        if (!response.ok) {
            throw new Error('Cannot open file');
        }
        const text = await response.text();
        const lines = text.split('\n');
        let index = 0;

        for (const line of lines) {
            const numbers = line.split(',');
            for (const word of numbers) {
                if (word.trim()) {
                    const number = parseInt(word);
                    p[index] = number;
                    p[256 + index] = number;
                    index++;
                }
            }
        }
    } catch (error) {
        console.error(error.message);
    }
}

async function main() {
    await readFile('permutation.txt');

    console.log('Perlin noise applied to (3.14, 42.0, 7.0) gives ' +
                perlinNoise(3.14, 42.0, 7.0).toFixed(16));
}

main();
