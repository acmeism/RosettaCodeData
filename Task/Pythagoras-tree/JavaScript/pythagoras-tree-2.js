var base = [[[-200, 0], [200, 0]],];
document.documentElement.innerHTML = [...Array(12)].reduce((svg_a, _, lvl) => {
    const rg = step => (80 + (lvl - 2) * step) & 255;
    return svg_a + base.splice(0).reduce((g_a, [a, b]) => {
        const w = (k0, k1) => (k0 * (b[0] - a[0]) + k1 * (b[1] - a[1])) / 2;
        const [c, e, d] = [2, 3, 2].map((j, i) => [a[0] + w(i, j), a[1] + w(-j, i)]);
        base.push([c, e], [e, d]);
        return g_a + `<polygon points="${[a, c, e, d, c, d, b]}"/>`;
    }, `<g fill="rgb(${rg(20)},${rg(30)},24)">`) + '</g>';
}, '<svg viewBox="-1200 -1600 2400 1600" stroke="white">') + '</svg>', "";
