let base = [[[-200, 0], [200, 0]]];
const doc = [...Array(12)].reduce((doc_a, _, lvl) => {
    const rg = step => `0${((80 + (lvl - 2) * step) % 256).toString(16)}`.slice(-2);
    return doc_a + base.splice(0).reduce((ga, [a, b]) => {
        const v = [b[0] - a[0], b[1] - a[1]];
        const [c, d, w] = [a, b, v].map(p => [p[0] + v[1], p[1] - v[0]]);
        const e = [c[0] + w[0] / 2, c[1] + w[1] / 2];
        base.push([c, e], [e, d]);
        return ga + '\n' + `<polygon points="${[a, c, e, d, c, d, b]}"/>`;
    }, `<g fill="#${rg(20)}${rg(30)}18">`) + '\n</g>\n';
}, '<svg xmlns="http://www.w3.org/2000/svg" width="1200" stroke="white">\n') + '</svg>';

const [x, y] = base.reduce(([xa, ya], [[x, y],]) => [Math.min(xa, x), Math.min(ya, y)], [0, 0]);
const svg = doc.replace('<svg ', `<svg viewBox="${[x, y, -x - x, -y]}" `);

if (globalThis.global) { // if the script is run from node.js - save the svg to a file
    require('node:fs').writeFileSync('Pythagor_tree.svg', svg);
} else { // if is run from the browser console or from the <script> tag of an html document
         // - display svg in the browser window
    document.documentElement.innerHTML = svg, '';
}
