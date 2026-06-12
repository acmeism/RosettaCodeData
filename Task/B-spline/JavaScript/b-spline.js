// ===== Points supplied by the task. =====
const points = [
    [171, 171],
    [185, 111],
    [202, 109],
    [328, 160],
    [208, 254],
    [241, 330],
    [164, 252],
    [69, 278],
    [139, 208],
    [72, 148],
    [168, 172]
];

// ===== Helper functions =====

const lerp = (a, b, t) => a + (b - a) * t;
const lerpPoint = (a, b, t) => a.map((a, i) => lerp(a, b[i], t));

const computeMidpoint = (a, b) => lerpPoint(a, b, 1 / 2);
const computeOneThird = (a, b) => lerpPoint(a, b, 1 / 3);
const computeTwoThird = (a, b) => lerpPoint(a, b, 2 / 3);

// ===== Create a canvas to draw the spline. =====

const canvas = document.createElement("canvas");

// Since no image size was given, it is assumed to be 500 x 500.
canvas.width = 500;
canvas.height = 500;

const ctx = canvas.getContext("2d");
if (!ctx) throw new Error("Canvas 2D API is not supported on this device.");

const [[firstX, firstY], ...nextPoints] = points;

// ===== Draws a 2px black polyline connecting all control points. =====

ctx.beginPath();

ctx.moveTo(firstX, firstY);
for (const [x, y] of nextPoints) ctx.lineTo(x, y);

ctx.lineWidth = 2;
ctx.strokeStyle = "black";

ctx.stroke();
ctx.closePath();

// ===== Draws spline specified in the task. =====
const [first, second] = points;
const [last, secondLast] = points.slice(-2).reverse();

ctx.beginPath();

drawStartingCurve(first, second);

for (const i of Array(points.length - 2).keys()) {
    const [a, b, c] = points.slice(i, i + 3);
    drawMiddleCurve(a, b, c);
}

drawEndingCurve(last, secondLast);

ctx.lineWidth = 2;
ctx.strokeStyle = "red";

ctx.stroke();
ctx.closePath();

// ==== Creates a link to allow the canvas image to be downloaded. ====
const dataURL = canvas.toDataURL("image/png");

const link = document.createElement("a");
link.href = dataURL;
link.download = "b-spline-js.png";

link.click();

// ==== Spline drawing functions =====

function drawStartingCurve(first, second) {
    const oneThird = computeOneThird(first, second);

    const [firstX, firstY] = first;

    const [oneThirdX, oneThirdY] = oneThird;
    const [oneSixthX, oneSixthY] = computeMidpoint(first, oneThird)

    ctx.moveTo(firstX, firstY);
    ctx.quadraticCurveTo(oneThirdX, oneThirdY, oneSixthX, oneSixthY);
}

function drawMiddleCurve(a, b, c) {
    const oneThirdAB = computeOneThird(a, b);
    const twoThirdAB = computeTwoThird(a, b);

    const oneThirdBC = computeOneThird(b, c);

    const twoThirdAB_OneThirdBC_Midpoint = computeMidpoint(twoThirdAB, oneThirdBC);

    const [oneThirdAB_X, oneThirdAB_Y] = oneThirdAB;
    const [twoThirdAB_X, twoThirdAB_Y] = twoThirdAB;

    const [twoThirdAB_OneThirdBC_MidpointX, twoThirdAB_OneThirdBC_MidpointY] = twoThirdAB_OneThirdBC_Midpoint;

    ctx.bezierCurveTo(oneThirdAB_X, oneThirdAB_Y, twoThirdAB_X, twoThirdAB_Y, twoThirdAB_OneThirdBC_MidpointX, twoThirdAB_OneThirdBC_MidpointY);
}

function drawEndingCurve(last, secondLast) {
    const oneThird = computeOneThird(secondLast, last);
    const twoThird = computeTwoThird(secondLast, last);

    const [lastX, lastY] = last;

    const [oneThirdX, oneThirdY] = oneThird;
    const [fiveSixthsX, fiveSixthsY] = computeMidpoint(twoThird, last);

    ctx.quadraticCurveTo(oneThirdX, oneThirdY, fiveSixthsX, fiveSixthsY);
    ctx.lineTo(lastX, lastY);
}
