const EPS = 0.001;
const EPS_SQUARE = EPS * EPS;

function side(x1, y1, x2, y2, x, y) {
	return (y2 - y1) * (x - x1) + (-x2 + x1) * (y - y1);
}

function naivePointInTriangle(x1, y1, x2, y2, x3, y3, x, y) {
	const checkSide1 = side(x1, y1, x2, y2, x, y) >= 0;
	const checkSide2 = side(x2, y2, x3, y3, x, y) >= 0;
	const checkSide3 = side(x3, y3, x1, y1, x, y) >= 0;
	return checkSide1 && checkSide2 && checkSide3;
}

function pointInTriangleBoundingBox(x1, y1, x2, y2, x3, y3, x, y) {
	const xMin = Math.min(x1, Math.min(x2, x3)) - EPS;
	const xMax = Math.max(x1, Math.max(x2, x3)) + EPS;
	const yMin = Math.min(y1, Math.min(y2, y3)) - EPS;
	const yMax = Math.max(y1, Math.max(y2, y3)) + EPS;
	return !(x < xMin || xMax < x || y < yMin || yMax < y);
}

function distanceSquarePointToSegment(x1, y1, x2, y2, x, y) {
	const p1_p2_squareLength = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1);
	const dotProduct =
		((x - x1) * (x2 - x1) + (y - y1) * (y2 - y1)) / p1_p2_squareLength;
	if (dotProduct < 0) {
		return (x - x1) * (x - x1) + (y - y1) * (y - y1);
	} else if (dotProduct <= 1) {
		const p_p1_squareLength = (x1 - x) * (x1 - x) + (y1 - y) * (y1 - y);
		return p_p1_squareLength - dotProduct * dotProduct * p1_p2_squareLength;
	} else {
		return (x - x2) * (x - x2) + (y - y2) * (y - y2);
	}
}

function accuratePointInTriangle(x1, y1, x2, y2, x3, y3, x, y) {
	if (!pointInTriangleBoundingBox(x1, y1, x2, y2, x3, y3, x, y)) {
		return false;
	}
	if (naivePointInTriangle(x1, y1, x2, y2, x3, y3, x, y)) {
		return true;
	}
	if (distanceSquarePointToSegment(x1, y1, x2, y2, x, y) <= EPS_SQUARE) {
		return true;
	}
	if (distanceSquarePointToSegment(x2, y2, x3, y3, x, y) <= EPS_SQUARE) {
		return true;
	}
	if (distanceSquarePointToSegment(x3, y3, x1, y1, x, y) <= EPS_SQUARE) {
		return true;
	}
	return false;
}

function printPoint(x, y) {
	return "(" + x + ", " + y + ")";
}

function printTriangle(x1, y1, x2, y2, x3, y3) {
	return (
		"Triangle is [" +
		printPoint(x1, y1) +
		", " +
		printPoint(x2, y2) +
		", " +
		printPoint(x3, y3) +
		"]"
	);
}

function test(x1, y1, x2, y2, x3, y3, x, y) {
	console.log(
		printTriangle(x1, y1, x2, y2, x3, y3) +
		"Point " +
		printPoint(x, y) +
		" is within triangle? " +
		(accuratePointInTriangle(x1, y1, x2, y2, x3, y3, x, y) ? "true" : "false")
	);
}

test(1.5, 2.4, 5.1, -3.1, -3.8, 1.2, 0, 0);
test(1.5, 2.4, 5.1, -3.1, -3.8, 1.2, 0, 1);
test(1.5, 2.4, 5.1, -3.1, -3.8, 1.2, 3, 1);
console.log();

test(
	0.1,
	0.1111111111111111,
	12.5,
	33.333333333333336,
	25,
	11.11111111111111,
	5.414285714285714,
	14.349206349206348
);
console.log();

test(
	0.1,
	0.1111111111111111,
	12.5,
	33.333333333333336,
	-12.5,
	16.666666666666668,
	5.414285714285714,
	14.349206349206348
);
console.log();
