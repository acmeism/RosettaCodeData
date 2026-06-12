class Point {
    constructor(x, y) {
        this.x = x;
        this.y = y;
    }

    equals(other) {
        return this.x === other.x && this.y === other.y;
    }

    notEquals(other) {
        return !this.equals(other);
    }
}

class Line {
    constructor(start, end) {
        this.start = start;
        this.end = end;
    }
}

class Polygon {
    constructor(points) {
        this.points = points;
    }
}

const InterVertexType = {
    InsideVertex: 'InsideVertex',
    OutsideVertex: 'OutsideVertex',
    InIntersection: 'InIntersection',
    OutIntersection: 'OutIntersection'
};

class InterVertex {
    constructor(type, point) {
        this.type = type;
        this.point = point;
    }

    getPoint() {
        return this.point;
    }

    static getFirstInIntersection(list) {
        let found = 0;
        let result = null;

        for (let i = 0; i < list.length; i++) {
            if (list[i].type === InterVertexType.InIntersection) {
                found = i;
                result = list[i].getPoint();
                break;
            }
        }

        if (found > 0) {
            list.splice(0, found);
        }

        return result;
    }
}

const PolyListOptionType = {
    List: 'List',
    InsidePoly: 'InsidePoly',
    None: 'None'
};

class PolyListOption {
    constructor(type, interVertexList, points) {
        this.type = type;
        this.interVertexList = interVertexList || [];
        this.points = points || [];
    }
}

function isInPolygon(point, poly) {
    const x = point.x;
    const y = point.y;
    let inside = false;
    let j = poly.points.length - 1;

    for (let i = 0; i < poly.points.length; i++) {
        const xi = poly.points[i].x;
        const yi = poly.points[i].y;
        const xj = poly.points[j].x;
        const yj = poly.points[j].y;

        const intersect = ((yi > y) !== (yj > y)) &&
                          (x < (xj - xi) * (y - yi) / (yj - yi) + xi);

        if (intersect) {
            inside = !inside;
        }

        j = i;
    }

    return inside;
}

function distanceCmp(self, first, second) {
    const dstFirst = Math.abs(self.x - first.x) + Math.abs(self.y - first.y);
    const dstSecond = Math.abs(self.x - second.x) + Math.abs(self.y - second.y);

    if (dstFirst < dstSecond) {
        return -1;
    } else if (dstFirst > dstSecond) {
        return 1;
    } else {
        return 0;
    }
}

function isInLine(point, line) {
    const dxc = point.x - line.start.x;
    const dyc = point.y - line.start.y;

    const dxl = line.end.x - line.start.x;
    const dyl = line.end.y - line.start.y;

    const cross = dxc * dyl - dyc * dxl;

    if (cross !== 0) {
        return false;
    }

    if (Math.abs(dxl) >= Math.abs(dyl)) {
        if (dxl > 0) {
            return line.start.x <= point.x && point.x <= line.end.x;
        } else {
            return line.end.x <= point.x && point.x <= line.start.x;
        }
    } else {
        if (dyl > 0) {
            return line.start.y <= point.y && point.y <= line.end.y;
        } else {
            return line.end.y <= point.y && point.y <= line.start.y;
        }
    }
}

function getIntersection(self, line) {
    const line1Start = self.start;
    const line1End = self.end;
    const line2Start = line.start;
    const line2End = line.end;

    const den = ((line2End.y - line2Start.y) * (line1End.x - line1Start.x)) -
              ((line2End.x - line2Start.x) * (line1End.y - line1Start.y));

    if (den === 0) {
        return null;
    }

    const a = line1Start.y - line2Start.y;
    const b = line1Start.x - line2Start.x;

    const num1 = ((line2End.x - line2Start.x) * a) - ((line2End.y - line2Start.y) * b);
    const num2 = ((line1End.x - line1Start.x) * a) - ((line1End.y - line1Start.y) * b);

    const aF = num1 / den;
    const bF = num2 / den;

    if (aF < 0.0 || aF > 1.0 || bF < 0.0 || bF > 1.0) {
        return null;
    }

    const result = new Point(
        line1Start.x + Math.round(aF * (line1End.x - line1Start.x)),
        line1Start.y + Math.round(aF * (line1End.y - line1Start.y))
    );

    return result;
}

function isClockwise(poly) {
    let sum = 0;
    for (let i = 0; i < poly.points.length; i++) {
        const j = (i !== poly.points.length - 1) ? i + 1 : 0;
        sum += (poly.points[j].x - poly.points[i].x) * (poly.points[j].y + poly.points[i].y);
    }
    return sum < 0;
}

function getReversed(poly) {
    const reversedPoints = [...poly.points].reverse();
    return new Polygon(reversedPoints);
}

function getFirstOutsideVertexIndex(subject, poly) {
    for (let i = 0; i < subject.points.length; i++) {
        if (!isInPolygon(subject.points[i], poly)) {
            return i;
        }
    }
    return null;
}

function getFirstInsideVertexIndex(subject, poly) {
    for (let i = 0; i < subject.points.length; i++) {
        if (isInPolygon(subject.points[i], poly)) {
            return i;
        }
    }
    return null;
}

function getIntersectionsWithLine(poly, line, cursorInside) {
    const intersections = [];

    for (let i = 0; i < poly.points.length; i++) {
        const start = poly.points[i];
        const nextI = (i === poly.points.length - 1) ? 0 : i + 1;
        const end = poly.points[nextI];

        const l = new Line(start, end);
        const intersection = getIntersection(l, line);

        if (intersection &&
            intersection.notEquals(line.start) &&
            intersection.notEquals(line.end) &&
            intersection.notEquals(start) &&
            intersection.notEquals(end)) {
            intersections.push(intersection);
        }
    }

    intersections.sort((a, b) => distanceCmp(line.start, a, b));

    const result = [];
    for (const x of intersections) {
        cursorInside.value = !cursorInside.value;
        if (cursorInside.value) {
            result.push(new InterVertex(InterVertexType.InIntersection, x));
        } else {
            result.push(new InterVertex(InterVertexType.OutIntersection, x));
        }
    }

    return result;
}

function getInterVertexList(subject, poly) {
    let subjectCopy = subject;
    if (!isClockwise(subjectCopy)) {
        subjectCopy = getReversed(subjectCopy);
    }

    const cursorInside = { value: false };
    let intersectionCount = 0;

    const startIndexOpt = getFirstOutsideVertexIndex(subjectCopy, poly);
    if (startIndexOpt !== null) {
        const startIndex = startIndexOpt;

        if (getFirstInsideVertexIndex(subjectCopy, poly) === null) {
            let allInside = true;
            for (const point of poly.points) {
                if (!isInPolygon(point, subjectCopy)) {
                    allInside = false;
                    break;
                }
            }

            if (allInside) {
                return new PolyListOption(PolyListOptionType.InsidePoly, [], poly.points);
            }
        }

        const result = [];

        for (let iOffset = 0; iOffset < subjectCopy.points.length; iOffset++) {
            const i = (startIndex + iOffset) % subjectCopy.points.length;
            const start = subjectCopy.points[i];

            // Check vertex
            if (i !== startIndex && isInPolygon(start, poly)) {
                result.push(new InterVertex(InterVertexType.InsideVertex, start));
            } else {
                result.push(new InterVertex(InterVertexType.OutsideVertex, start));
            }

            // Check intersection
            const nextI = (i === subjectCopy.points.length - 1) ? 0 : i + 1;
            const end = subjectCopy.points[nextI];
            const line = new Line(start, end);

            const intersections = getIntersectionsWithLine(poly, line, cursorInside);
            intersectionCount += intersections.length;

            result.push(...intersections);
        }

        // Check if there are any intersections
        let hasIntersections = false;
        for (const vertex of result) {
            if (vertex.type === InterVertexType.InIntersection ||
                vertex.type === InterVertexType.OutIntersection) {
                hasIntersections = true;
                break;
            }
        }

        if (!hasIntersections) {
            return new PolyListOption(PolyListOptionType.None, [], []);
        } else {
            return new PolyListOption(PolyListOptionType.List, result, []);
        }
    } else {
        return new PolyListOption(PolyListOptionType.InsidePoly, [], subject.points);
    }
}

function collectFromList(list, startPoint) {
    let initialVertexNotFound = true;
    let lastPoint = null;
    let startI = 0, endI = 0;
    const dontSkip = list[0].getPoint().equals(startPoint);

    const points = [];
    let i = 0;

    // Skip until InIntersection occurs, but include the InIntersection
    while (i < list.length && initialVertexNotFound && !dontSkip) {
        const next = (i === list.length - 1) ? 0 : i + 1;
        const nextPoint = list[next];

        if (nextPoint.type === InterVertexType.InIntersection ||
            nextPoint.type === InterVertexType.OutIntersection) {
            if (nextPoint.getPoint().equals(startPoint)) {
                startI = next;
                initialVertexNotFound = false;
                break;
            }
        }
        i++;
    }

    // Collect points
    if (!initialVertexNotFound || dontSkip) {
        i = startI;
        let continueCollecting = true;

        while (continueCollecting && i < list.length) {
            const vertex = list[i];

            if (vertex.type === InterVertexType.OutIntersection) {
                endI = i;
                lastPoint = vertex.getPoint();
                continueCollecting = false;
            } else {
                points.push(vertex.getPoint());
            }

            i++;
        }
    }

    const amount = endI - startI + 1;
    if (endI >= startI && startI + amount <= list.length) {
        list.splice(startI, amount);
    }

    if (points.length > 0 && lastPoint) {
        return [points, lastPoint];
    } else {
        return null;
    }
}

function getClipPolygon(subject, clip, initial) {
    const result = [];
    let subjectAsList = true;
    let startPoint = initial;
    let endPoint = subject[subject.length - 1].getPoint();

    while (!initial.equals(endPoint)) {
        const values = collectFromList(
            subjectAsList ? subject : clip,
            startPoint);

        if (values) {
            const [edges, end] = values;
            endPoint = end;
            startPoint = end;
            subjectAsList = !subjectAsList;

            result.push(...edges);
        } else {
            console.log("something went wrong");
            console.log("res size:", result.length);
            return null;
        }
    }

    if (result.length > 0) {
        // Filter consecutive duplicate points
        const filteredResult = [];
        for (let i = 0; i < result.length; i++) {
            if (i === 0 || !result[i].equals(result[i-1])) {
                filteredResult.push(result[i]);
            }
        }

        return filteredResult;
    } else {
        return null;
    }
}

function getClipPolygons(subject, clip) {
    const result = [];

    while (true) {
        const startPointOpt = InterVertex.getFirstInIntersection(subject);
        if (!startPointOpt) {
            break;
        }

        const poly = getClipPolygon(subject, clip, startPointOpt);
        if (poly) {
            result.push(poly);
        } else {
            break;
        }
    }

    if (result.length > 0) {
        return result;
    } else {
        return null;
    }
}

function clip(self, other) {
    const option = getInterVertexList(self, other);
    const otherOption = getInterVertexList(other, self);

    if (option.type === PolyListOptionType.List) {
        const subjectList = option.interVertexList;

        if (otherOption.type === PolyListOptionType.List) {
            const clipList = otherOption.interVertexList;
            return getClipPolygons(subjectList, clipList);
        } else if (otherOption.type === PolyListOptionType.InsidePoly) {
            return [otherOption.points];
        } else { // None
            return null;
        }
    } else if (option.type === PolyListOptionType.InsidePoly) {
        return [option.points];
    } else { // None
        return null;
    }
}

// Testing function
function runTests() {
    // Test is_in_line
    {
        const p = new Point(5, 10);
        const line = new Line(new Point(5, 5), new Point(5, 20));
        const result = isInLine(p, line);
        console.log(`isInLine test 1: ${result ? "PASS" : "FAIL"}`);

        const pF = new Point(3, 4);
        const lineF = new Line(new Point(5, 5), new Point(5, 20));
        const resultF = isInLine(pF, lineF);
        console.log(`isInLine test 2: ${!resultF ? "PASS" : "FAIL"}`);
    }

    // Test clip
    {
        const poly = new Polygon([
            new Point(180, 420),
            new Point(180, 120),
            new Point(520, 120),
            new Point(520, 420),
            new Point(420, 420),
            new Point(320, 220)
        ]);

        const interPolygon = new Polygon([
            new Point(60, 220),
            new Point(330, 120),
            new Point(410, 290),
            new Point(80, 480),
            new Point(280, 280)
        ]);

        const polygons = clip(poly, interPolygon);
        if (polygons && polygons.length > 0) {
            console.log(`clip test: PASS - Found ${polygons.length} polygons`);

            // Print first polygon points
            if (polygons[0].length > 0) {
                console.log("First polygon points:");
                for (const p of polygons[0]) {
                    console.log(`  Point: (${p.x}, ${p.y})`);
                }
            }
        } else {
            console.log("clip test: FAIL - No polygons found");
        }
    }
}

// Run the tests
runTests();
