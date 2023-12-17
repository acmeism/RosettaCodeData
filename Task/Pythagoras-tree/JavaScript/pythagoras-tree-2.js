let base = [[{ x: -200, y: 0 }, { x: 200, y: 0 }]];
const doc = [...Array(12)].reduce((doc_a, _, lvl) => {
    const rg = step => `0${(80 + (lvl - 2) * step).toString(16)}`.slice(-2);
    return doc_a + base.splice(0).reduce((ga, [a, b]) => {
        const w = (kx, ky) => (kx * (b.x - a.x) + ky * (b.y - a.y)) / 2;
        const [c, e, d] = [2, 3, 2].map((j, i) => ({ x: a.x + w(i, j), y: a.y + w(-j, i) }));
        base.push([c, e], [e, d]);
        return ga + `<polygon points="${[a, c, e, d, c, d, b].map(p => [p.x, p.y])}"/>\n`;
    }, `<g fill="#${rg(20)}${rg(30)}18">\n`) + '</g>\n';
}, '<svg xmlns="http://www.w3.org/2000/svg" width="1200" stroke="white">\n') + '</svg>';

const { x, y } = base.flat().reduce((a, p) => ({ x: Math.min(a.x, p.x), y: Math.min(a.y, p.y) }));
const svg = doc.replace('<svg ', `<svg viewBox="${[x, y, -x - x, -y]}" `);
document.documentElement.innerHTML = svg, ''; // display svg in the browser window
