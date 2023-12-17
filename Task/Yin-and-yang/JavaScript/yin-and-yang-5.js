function yinYang(r, x, y, th = 1) {
    const PI = Math.PI;
    const path = new Path2D();
    const cR = (dY, radius) => { path.arc(x, y + dY, radius, 0, PI * 2); path.closePath() };
    cR(0, r + th);
    cR(r / 2, r / 6);
    cR(-r / 2, r / 6);
    path.arc(x, y, r, PI / 2, -PI / 2);
    path.arc(x, y - r / 2, r / 2, -PI / 2, PI / 2);
    path.arc(x, y + r / 2, r / 2, -PI / 2, PI / 2, true);
    return path;
}

document.documentElement.innerHTML = '<canvas width="170" height="120"/>';
const canvasCtx = document.querySelector('canvas').getContext('2d');

canvasCtx.fill(yinYang(50.0, 60, 60), 'evenodd');
canvasCtx.fill(yinYang(20.0, 140, 30), 'evenodd');
