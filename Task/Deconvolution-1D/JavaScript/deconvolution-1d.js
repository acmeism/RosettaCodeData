function deconv(g, f) {
    const h = new Array(g.length - f.length + 1);
    for (let n = 0; n < h.length; n++) {
        h[n] = g[n];
        const lower = Math.max(n - f.length + 1, 0);
        for (let i = lower; i < n; i++)
            h[n] -= h[i] * f[n - i];
        h[n] /= f[0];
    }
    return h;
}

function main() {
    const h = [-8, -9, -3, -1, -6, 7];
    const f = [-3, -6, -1, 8, -6, 3, -1, -9, -9, 3, -2, 5, 2, -2, -7, -1];
    const g = [24, 75, 71, -34, 3, 22, -45, 23, 245, 25, 52, 25, -67, -96,
               96, 31, 55, 36, 29, -43, -7];

    let output = '';
    output += `h = ${JSON.stringify(h)}\n`;
    output += `deconv(g, f) = ${JSON.stringify(deconv(g, f))}\n`;
    output += `f = ${JSON.stringify(f)}\n`;
    output += `deconv(g, h) = ${JSON.stringify(deconv(g, h))}\n`;
    console.log(output);
}

main();
