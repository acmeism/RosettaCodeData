class Point {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }
}

class QuadSpline {
  constructor(c0, c1, c2) {
    this.c0 = c0;
    this.c1 = c1;
    this.c2 = c2;
  }
}

class QuadCurve {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }
}

// Subdivision by de Casteljau's algorithm.
function subdivideQuadSpline(q, t, u, v) {
  const s = 1.0 - t;
  const c0 = q.c0;
  const c1 = q.c1;
  const c2 = q.c2;
  u.c0 = c0;
  v.c2 = c2;
  u.c1 = s * c0 + t * c1;
  v.c1 = s * c1 + t * c2;
  u.c2 = s * u.c1 + t * v.c1;
  v.c0 = u.c2;
}

function subdivideQuadCurve(q, t, u, v) {
  subdivideQuadSpline(q.x, t, u.x, v.x);
  subdivideQuadSpline(q.y, t, u.y, v.y);
}

// It is assumed that xa0 <= xa1, ya0 <= ya1, xb0 <= xb1, and yb0 <= yb1.
function rectsOverlap(xa0, ya0, xa1, ya1, xb0, yb0, xb1, yb1) {
  return (xb0 <= xa1 && xa0 <= xb1 && yb0 <= ya1 && ya0 <= yb1);
}

function max3(x, y, z) { return Math.max(Math.max(x, y), z); }
function min3(x, y, z) { return Math.min(Math.min(x, y), z); }

// This accepts the point as an intersection if the boxes are small enough.
function testIntersect(p, q, tol) {
  const pxmin = min3(p.x.c0, p.x.c1, p.x.c2);
  const pymin = min3(p.y.c0, p.y.c1, p.y.c2);
  const pxmax = max3(p.x.c0, p.x.c1, p.x.c2);
  const pymax = max3(p.y.c0, p.y.c1, p.y.c2);

  const qxmin = min3(q.x.c0, q.x.c1, q.x.c2);
  const qymin = min3(q.y.c0, q.y.c1, q.y.c2);
  const qxmax = max3(q.x.c0, q.x.c1, q.x.c2);
  const qymax = max3(q.y.c0, q.y.c1, q.y.c2);

  let exclude = true;
  let accept = false;
  let intersect = new Point(0, 0);

  if (rectsOverlap(pxmin, pymin, pxmax, pymax, qxmin, qymin, qxmax, qymax)) {
    exclude = false;
    const xmin = Math.max(pxmin, qxmin);
    const xmax = Math.min(pxmax, qxmax);

    if (xmax < xmin) {
      throw new Error(`Assertion failure: ${xmax} < ${xmin}`);
    }

    if (xmax - xmin <= tol) {
      const ymin = Math.max(pymin, qymin);
      const ymax = Math.min(pymax, qymax);

      if (ymax < ymin) {
        throw new Error(`Assertion failure: ${ymax} < ${ymin}`);
      }

      if (ymax - ymin <= tol) {
        accept = true;
        intersect.x = 0.5 * xmin + 0.5 * xmax;
        intersect.y = 0.5 * ymin + 0.5 * ymax;
      }
    }
  }

  return { exclude, accept, intersect };
}

function seemsToBeDuplicate(intersects, xy, spacing) {
  let seemsToBeDup = false;
  let i = 0;

  while (!seemsToBeDup && i !== intersects.length) {
    const pt = intersects[i];
    seemsToBeDup = Math.abs(pt.x - xy.x) < spacing && Math.abs(pt.y - xy.y) < spacing;
    i++;
  }

  return seemsToBeDup;
}

function findIntersects(p, q, tol, spacing) {
  const intersects = [];
  const workload = [{ p, q }];

  // Quit looking after having emptied the workload.
  while (workload.length > 0) {
    const work = workload.pop();
    const { exclude, accept, intersect } = testIntersect(work.p, work.q, tol);

    if (accept) {
      // To avoid detecting the same intersection twice, require some
      // space between intersections.
      if (!seemsToBeDuplicate(intersects, intersect, spacing)) {
        intersects.push(intersect);
      }
    } else if (!exclude) {
      const p0 = new QuadCurve(new QuadSpline(0, 0, 0), new QuadSpline(0, 0, 0));
      const p1 = new QuadCurve(new QuadSpline(0, 0, 0), new QuadSpline(0, 0, 0));
      const q0 = new QuadCurve(new QuadSpline(0, 0, 0), new QuadSpline(0, 0, 0));
      const q1 = new QuadCurve(new QuadSpline(0, 0, 0), new QuadSpline(0, 0, 0));

      subdivideQuadCurve(work.p, 0.5, p0, p1);
      subdivideQuadCurve(work.q, 0.5, q0, q1);

      workload.push({ p: p1, q: q1 });
      workload.push({ p: p1, q: q0 });
      workload.push({ p: p0, q: q1 });
      workload.push({ p: p0, q: q0 });
    }
  }

  return intersects;
}

function main() {
  const p = new QuadCurve(
    new QuadSpline(-1.0, 0.0, 1.0),
    new QuadSpline(0.0, 10.0, 0.0)
  );

  const q = new QuadCurve(
    new QuadSpline(2.0, -8.0, 2.0),
    new QuadSpline(1.0, 2.0, 3.0)
  );

  const tol = 0.0000001;
  const spacing = tol * 10;

  const intersects = findIntersects(p, q, tol, spacing);

  for (const intersect of intersects) {
    console.log(`(${intersect.x}, ${intersect.y})`);
  }
}

main();
