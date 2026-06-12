// Constants
const MAXN = 2500;
const EPS = 1e-8;

function gtr(a, b) {
  return a - b > EPS;
}

function eq(a, b) {
  return Math.abs(a - b) < EPS;
}

function Abs(x) {
  return x < 0 ? -x : x;
}

// 3D Vector
class Vect {
  constructor(x = 0.0, y = 0.0, z = 0.0, id = 0) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.id = id;
  }

  subtract(o) {
    return new Vect(this.x - o.x, this.y - o.y, this.z - o.z);
  }

  // cross product
  cross(o) {
    return new Vect(
      this.y * o.z - this.z * o.y,
      this.z * o.x - this.x * o.z,
      this.x * o.y - this.y * o.x
    );
  }

  // dot product
  dot(o) {
    return this.x * o.x + this.y * o.y + this.z * o.z;
  }

  magnitude() {
    return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
  }

  equals(o) {
    return eq(this.x, o.x) && eq(this.y, o.y) && eq(this.z, o.z);
  }

  toString() {
    return `Vect(${this.x}, ${this.y}, ${this.z}, ${this.id})`;
  }
}

// Line from u to v
class Line {
  constructor(u = null, v = null) {
    this.u = u;
    this.v = v;
  }
}

// Plane through three points u,v,w
class Plane {
  constructor(u = null, v = null, w = null) {
    this.vec = (u && v && w) ? [u, v, w] : [null, null, null];
  }

  // normal vector = (v - u) × (w - u)
  normal() {
    const [u, v, w] = this.vec;
    return v.subtract(u).cross(w.subtract(u));
  }

  // one point on plane
  u() {
    return this.vec[0];
  }
}

// Signed distance point-plane
function distPointPlane(pt, pl) {
  const n = pl.normal();
  return pt.subtract(pl.u()).dot(n) / n.magnitude();
}

// Unsigned distance point-line
function distPointLine(pt, ln) {
  const u_to_pt = pt.subtract(ln.u);
  const dir = ln.v.subtract(ln.u);
  if (u_to_pt.magnitude() === 0) return 0;
  return u_to_pt.cross(dir).magnitude() / dir.magnitude();
}

// Distance point-point
function distPointPoint(a, b) {
  return a.subtract(b).magnitude();
}

// is pt strictly above plane?
function isAbove(pt, pl) {
  const n = pl.normal();
  return gtr(pt.subtract(pl.u()).dot(n), 0);
}

// Facet (triangle face of hull)
class Facet {
  constructor(id = 0, p = null) {
    this.n = [0, 0, 0];    // neighbors
    this.id = id;
    this.vistime = 0;
    this.isdel = false;
    this.p = p || new Plane();
  }
  setNeighbors(n1, n2, n3) {
    this.n = [n1, n2, n3];
  }
  toString() {
    return `Facet(id=${this.id}, isdel=${this.isdel}, vistime=${this.vistime})`;
  }
}

// Edge info for horizon detection
class Edge {
  constructor() {
    this.netid = 0;
    this.facetid = 0;
  }
}

// Global variables
let FAC = [];
let pts = [];     // points assigned to each face
let TIME = 0;

// Convex hull wrapper
class ConvexHulls3d {
  constructor(index) {
    this.index = index;
    this.surfaceArea = 0.0;
  }

  dfsArea(fidx) {
    if (FAC[fidx].vistime === TIME) return;
    FAC[fidx].vistime = TIME;
    const n = FAC[fidx].p.normal();
    this.surfaceArea += n.magnitude() / 2;
    for (let i = 0; i < 3; i++) {
      this.dfsArea(FAC[fidx].n[i]);
    }
  }

  getSurfaceArea() {
    if (gtr(this.surfaceArea, 0)) {
      return this.surfaceArea;
    }
    TIME++;
    this.dfsArea(this.index);
    return this.surfaceArea;
  }

  getHorizon(f, p, vistime, e1, e2, resfdel) {
    if (!isAbove(p, FAC[f].p)) return 0;
    if (FAC[f].vistime === TIME) return -1;
    FAC[f].vistime = TIME;
    FAC[f].isdel = true;
    resfdel.push(FAC[f].id);
    let ret = -2;
    for (let i = 0; i < 3; i++) {
      const res = this.getHorizon(FAC[f].n[i], p, vistime, e1, e2, resfdel);
      if (res === 0) {
        const ptIds = [
          FAC[f].p.vec[i].id,
          FAC[f].p.vec[(i + 1) % 3].id
        ];
        for (let j = 0; j < 2; j++) {
          const pid = ptIds[j];
          if (vistime[pid] !== TIME) {
            vistime[pid] = TIME;
            e1[pid].netid = ptIds[(j + 1) % 2];
            e1[pid].facetid = FAC[f].n[i];
          } else {
            e2[pid].netid = ptIds[(j + 1) % 2];
            e2[pid].facetid = FAC[f].n[i];
          }
        }
        ret = ptIds[0];
      } else if (res !== -1 && res !== -2) {
        ret = res;
      }
    }
    return ret;
  }
}

// Initialize convex hull system
function preConvexHulls() {
  pts = [[]];
  FAC = [ new Facet() ];
}

// Build initial tetrahedron (simplex)
function getStart(point, totp) {
  // pick extreme points along axes
  let pt = Array(6).fill(point[1]);
  let s = Array(4).fill(point[1]);

  for (let i = 2; i <= totp; i++) {
    if (gtr(point[i].x, pt[0].x)) pt[0] = point[i];
    if (gtr(pt[1].x, point[i].x)) pt[1] = point[i];
    if (gtr(point[i].y, pt[2].y)) pt[2] = point[i];
    if (gtr(pt[3].y, point[i].y)) pt[3] = point[i];
    if (gtr(point[i].z, pt[4].z)) pt[4] = point[i];
    if (gtr(pt[5].z, point[i].z)) pt[5] = point[i];
  }

  // farthest pair among these 6
  for (let i = 0; i < 6; i++) {
    for (let j = i + 1; j < 6; j++) {
      if (gtr(distPointPoint(pt[i], pt[j]), distPointPoint(s[0], s[1]))) {
        s[0] = pt[i];
        s[1] = pt[j];
      }
    }
  }

  // farthest point from line s[0]-s[1]
  for (let i = 0; i < 6; i++) {
    if (gtr(
      distPointLine(pt[i], new Line(s[0], s[1])),
      distPointLine(s[2], new Line(s[0], s[1]))
    )) {
      s[2] = pt[i];
    }
  }

  // farthest point from plane through s[0],s[1],s[2]
  for (let i = 1; i <= totp; i++) {
    if (gtr(
      Abs(distPointPlane(point[i], new Plane(s[0], s[1], s[2]))),
      Abs(distPointPlane(s[3], new Plane(s[0], s[1], s[2])))
    )) {
      s[3] = point[i];
    }
  }

  // ensure correct orientation
  if (gtr(0, distPointPlane(s[3], new Plane(s[0], s[1], s[2])))) {
    [s[1], s[2]] = [s[2], s[1]];
  }

  // create 4 faces
  let f = new Array(4);
  for (let i = 0; i < 4; i++) {
    FAC.push(new Facet(FAC.length));
    f[i] = FAC.length - 1;
  }

  FAC[f[0]].p = new Plane(s[0], s[2], s[1]);
  FAC[f[1]].p = new Plane(s[0], s[1], s[3]);
  FAC[f[2]].p = new Plane(s[1], s[2], s[3]);
  FAC[f[3]].p = new Plane(s[2], s[0], s[3]);

  FAC[f[0]].setNeighbors(f[3], f[2], f[1]);
  FAC[f[1]].setNeighbors(f[0], f[2], f[3]);
  FAC[f[2]].setNeighbors(f[0], f[3], f[1]);
  FAC[f[3]].setNeighbors(f[0], f[1], f[2]);

  // allocate point lists
  for (let i = 0; i < 4; i++) pts.push([]);

  // assign remaining points to faces
  for (let i = 1; i <= totp; i++) {
    const pi = point[i];
    if (pi.equals(s[0]) || pi.equals(s[1]) || pi.equals(s[2]) || pi.equals(s[3])) continue;
    for (let j = 0; j < 4; j++) {
      if (isAbove(pi, FAC[f[j]].p)) {
        pts[f[j]].push(pi);
        break;
      }
    }
  }

  return new ConvexHulls3d(f[0]);
}

// QuickHull main routine
function quickHull3d(point, totp) {
  let hull = getStart(point, totp);
  let queue = [hull.index,
               ...FAC[hull.index].n];
  let snew = 0;

  // horizon data
  const e = [ Array(MAXN).fill().map(() => new Edge()),
              Array(MAXN).fill().map(() => new Edge()) ];
  const vistime = Array(MAXN).fill(0);

  while (queue.length > 0) {
    const nf = queue.shift();
    if (FAC[nf].isdel) continue;
    if (pts[nf].length === 0) {
      snew = nf;
      continue;
    }

    // farthest point from face
    let p = pts[nf][0];
    for (let pt of pts[nf]) {
      if (gtr(distPointPlane(pt, FAC[nf].p), distPointPlane(p, FAC[nf].p))) {
        p = pt;
      }
    }

    // find horizon
    TIME++;
    let resfdel = [];
    const startEdge = hull.getHorizon(nf, p, vistime, e[0], e[1], resfdel);

    // build new faces around horizon
    let resfnew = [];
    TIME++;
    let from = 0, lastf = 0, fstf = 0, s = startEdge;

    while (vistime[s] !== TIME) {
      vistime[s] = TIME;
      let net, adjF;
      if (e[0][s].netid === from) {
        net = e[1][s].netid; adjF = e[1][s].facetid;
      } else {
        net = e[0][s].netid; adjF = e[0][s].facetid;
      }

      // find indices of s and net in adj face
      let pt1 = -1, pt2 = -1;
      for (let i = 0; i < 3; i++) {
        if (point[s] === FAC[adjF].p.vec[i]) pt1 = i;
        if (point[net] === FAC[adjF].p.vec[i]) pt2 = i;
      }
      if ((pt1 + 1) % 3 !== pt2) [pt1, pt2] = [pt2, pt1];

      // new face [pt2, pt1, p]
      FAC.push(new Facet(FAC.length, new Plane(
        FAC[adjF].p.vec[pt2],
        FAC[adjF].p.vec[pt1],
        p
      )));
      const fnew = FAC.length - 1;
      pts.push([]);
      resfnew.push(fnew);

      // link adjacency
      FAC[fnew].n[0] = adjF;
      FAC[adjF].n[pt1] = fnew;
      if (lastf) {
        if (FAC[fnew].p.vec[1] === FAC[lastf].p.vec[0]) {
          FAC[fnew].n[1] = lastf;
          FAC[lastf].n[2] = fnew;
        } else {
          FAC[fnew].n[2] = lastf;
          FAC[lastf].n[1] = fnew;
        }
      } else {
        fstf = fnew;
      }

      lastf = fnew;
      from = s;
      s = net;
    }

    // close the loop
    if (FAC[fstf].p.vec[1] === FAC[lastf].p.vec[0]) {
      FAC[fstf].n[1] = lastf;
      FAC[lastf].n[2] = fstf;
    } else {
      FAC[fstf].n[2] = lastf;
      FAC[lastf].n[1] = fstf;
    }

    // collect and reassign points
    let respt = [];
    for (let fid of resfdel) {
      respt.push(...pts[fid]);
      pts[fid] = [];
    }
    for (let qpt of respt) {
      if (qpt === p) continue;
      for (let nfnew of resfnew) {
        if (isAbove(qpt, FAC[nfnew].p)) {
          pts[nfnew].push(qpt);
          break;
        }
      }
    }

    // enqueue new faces
    queue.push(...resfnew);
  }

  hull.index = snew;
  return hull;
}

// Example usage
(function main() {
  preConvexHulls();
  const n = 4;
  const input = [
    [0.0, 0.0, 0.0],
    [1.0, 0.0, 0.0],
    [0.0, 1.0, 0.0],
    [0.0, 0.0, 1.0]
  ];
  const point = Array(n + 1);
  for (let i = 1; i <= n; i++) {
    const [x, y, z] = input[i - 1];
    point[i] = new Vect(x, y, z, i);
  }
  const hull = quickHull3d(point, n);
  console.log(hull.getSurfaceArea().toFixed(3));
})();
