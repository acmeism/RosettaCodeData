const fs = require('fs');
const data = fs.readFileSync(0, 'utf-8');

const COLORS = [
    [255, 0, 0],     // RED
    [0, 255, 0],     // GREEN
    [255, 255, 0],   // YELLOW
    [0, 0, 255],     // BLUE
    [255, 0, 255],   // MAGENTA
    [0, 255, 255]    // CYAN
];

function hexToRgb(hex) {
    var bigint = parseInt(hex.padEnd(6, 0), 16);
    var r = (bigint >> 16) & 255;
    var g = (bigint >> 8) & 255;
    var b = bigint & 255;

    return [r, g, b];
}

function colorDistance(color1, color2) {
    const [r1, g1, b1] = color1;
    const [r2, g2, b2] = color2;

    const dr = r2 - r1;
    const dg = g2 - g1;
    const db = b2 - b1;

    return Math.sqrt(dr * dr + dg * dg + db * db);
}

function closestColor(r, g, b) {
    let d = Infinity;
    let closest;

    for (const color of COLORS) {
        const distance = colorDistance([r, g, b], color);
        if(distance < d) {
            closest = color;
            d = distance;
        }
    }

    return closest;
}

function chunk_arr(arr, n) {
    const chunks = [];

    for(let i = 0; i < arr.length; i += n) {
        chunks.push(arr.slice(i, i+n));
    }

    return chunks;
}

data.trim('\n').split('\n').forEach(line => {
    const tokens = line.split(' ');

    const checksum = tokens[0];
    const name = tokens.slice(1, tokens.length).join('');

    const chunks = chunk_arr(checksum, 3);
    const newString = []

    for (const chunk of chunks) {
        let [r, g, b] = hexToRgb(chunk);
        [r, g, b] = closestColor(r, g, b);
        newString.push(`\x1b[38;2;${r};${g};${b}m${chunk}\x1b[0m`);
    }

    console.log(newString.join(''), name);
});
