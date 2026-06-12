use std::f64;

const MAXN: usize = 2500;
const EPS: f64 = 1e-8;

#[derive(Clone, Copy, Debug)]
struct Vect {
    x: f64,
    y: f64,
    z: f64,
    id: usize,
}

impl Vect {
    fn new(x: f64, y: f64, z: f64, id: usize) -> Self {
        Vect { x, y, z, id }
    }

    fn sub(&self, other: &Vect) -> Vect {
        Vect::new(self.x - other.x, self.y - other.y, self.z - other.z, 0)
    }

    fn cross(&self, other: &Vect) -> Vect {
        Vect::new(
            self.y * other.z - self.z * other.y,
            self.z * other.x - self.x * other.z,
            self.x * other.y - self.y * other.x,
            0,
        )
    }

    fn dot(&self, other: &Vect) -> f64 {
        self.x * other.x + self.y * other.y + self.z * other.z
    }

    fn m(&self) -> f64 {
        f64::sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
    }

    fn eq(&self, other: &Vect) -> bool {
        eq(self.x, other.x) && eq(self.y, other.y) && eq(self.z, other.z)
    }
}

struct Line {
    u: Vect,
    v: Vect,
}

impl Line {
    fn new(u: Vect, v: Vect) -> Self {
        Line { u, v }
    }
}

#[derive(Clone)]
struct Plane {
    vec: [Vect; 3],
}

impl Plane {
    fn new(u: Vect, v: Vect, w: Vect) -> Self {
        Plane { vec: [u, v, w] }
    }

    fn normal(&self) -> Vect {
        self.vec[1].sub(&self.vec[0]).cross(&self.vec[2].sub(&self.vec[0]))
    }

    fn u(&self) -> Vect {
        self.vec[0]
    }
}

fn gtr(a: f64, b: f64) -> bool {
    a - b > EPS
}

fn eq(a: f64, b: f64) -> bool {
    -EPS < a - b && a - b < EPS
}

fn abs(x: f64) -> f64 {
    if gtr(0.0, x) { -x } else { x }
}

// Signed distance
fn dist_point_plane(v: &Vect, p: &Plane) -> f64 {
    let normal = p.normal();
    v.sub(&p.u()).dot(&normal) / normal.m()
}

// Unsigned distance
fn dist_point_line(v: &Vect, f: &Line) -> f64 {
    if v.sub(&f.u).m() > 0.0 {
        f.v.sub(&f.u).cross(&v.sub(&f.u)).m() / f.v.sub(&f.u).m()
    } else {
        0.0
    }
}

fn dist_point_point(u: &Vect, v: &Vect) -> f64 {
    u.sub(v).m()
}

fn isabove(v: &Vect, p: &Plane) -> bool {
    gtr(v.sub(&p.u()).dot(&p.normal()), 0.0)
}

// Convex Hull Structures
#[derive(Clone)]
struct Facet {
    n: [usize; 3],   // neighbors, correspond to point (u->v, v->w, w->u)
    id: usize,
    vistime: usize,  // access timestamp
    isdel: bool,
    p: Plane,
}

impl Facet {
    fn new(id: usize, p: Plane) -> Self {
        Facet {
            n: [0, 0, 0],
            id,
            vistime: 0,
            isdel: false,
            p,
        }
    }

    fn set_neighbors(&mut self, n1: usize, n2: usize, n3: usize) {
        self.n = [n1, n2, n3];
    }
}

// Edge of the horizon
#[derive(Clone)]
struct Edge {
    netid: usize,
    facetid: usize,
}

impl Edge {
    fn new() -> Self {
        Edge { netid: 0, facetid: 0 }
    }
}

struct ConvexHulls3d {
    index: usize,      // Index face
    surfacearea: f64,
}

impl ConvexHulls3d {
    fn new(index: usize) -> Self {
        ConvexHulls3d {
            index,
            surfacearea: 0.0,
        }
    }

    fn dfs_area(&mut self, nf: usize, fac: &mut Vec<Facet>, time: &mut usize) {
        // Already visited in current timestamp
        if fac[nf].vistime == *time {
            return;
        }

        fac[nf].vistime = *time;

        self.surfacearea += fac[nf].p.normal().m() / 2.0;

        // Make a copy of neighbors to avoid borrow issues
        let neighbors = fac[nf].n;
        for i in 0..3 {
            self.dfs_area(neighbors[i], fac, time);
        }
    }

    fn get_surface_area(&mut self, fac: &mut Vec<Facet>, time: &mut usize) -> f64 {
        if gtr(self.surfacearea, 0.0) {
            return self.surfacearea;
        }
        *time += 1;
        self.dfs_area(self.index, fac, time);
        self.surfacearea
    }

    fn get_horizon(
        &self,
        f: usize,
        p: Vect,
        vistime: &mut [usize],
        e1: &mut [Edge],
        e2: &mut [Edge],
        resfdel: &mut Vec<usize>,
        fac: &mut Vec<Facet>,
        time: usize,
    ) -> isize {
        if !isabove(&p, &fac[f].p) {
            return 0;
        }

        if fac[f].vistime == time {
            return -1;
        }

        fac[f].vistime = time;
        // Mark the deleted face
        fac[f].isdel = true;
        resfdel.push(fac[f].id);

        let mut ret: isize = -2;

        // Make a copy of neighbors to avoid borrow issues
        let neighbors = fac[f].n;
        for i in 0..3 {
            let res = self.get_horizon(
                neighbors[i],
                p,
                vistime,
                e1,
                e2,
                resfdel,
                fac,
                time,
            );

            if res == 0 {
                let pt = [
                    fac[f].p.vec[i].id,
                    fac[f].p.vec[(i + 1) % 3].id
                ];

                for j in 0..2 {
                    if vistime[pt[j]] != time {
                        vistime[pt[j]] = time;
                        e1[pt[j]].netid = pt[(j + 1) % 2];
                        e1[pt[j]].facetid = neighbors[i];
                    } else {
                        e2[pt[j]].netid = pt[(j + 1) % 2];
                        e2[pt[j]].facetid = neighbors[i];
                    }
                }
                ret = pt[0] as isize;
            } else if res != -1 && res != -2 {
                // The face is enclosed in the middle
                ret = res;
            }
        }

        ret
    }
}

// Construct initial simplex
fn get_start(point: &[Vect], totp: usize) -> (ConvexHulls3d, Vec<Facet>, Vec<Vec<Vect>>) {
    let mut fac = Vec::new();
    let mut pts = Vec::new();

    // Add a dummy facet at index 0
    fac.push(Facet::new(0, Plane::new(
        Vect::new(0.0, 0.0, 0.0, 0),
        Vect::new(0.0, 0.0, 0.0, 0),
        Vect::new(0.0, 0.0, 0.0, 0)
    )));

    let mut pt = [point[1]; 6];
    let mut s = [point[1]; 4];

    // Find the maximum point of the coordinate axis
    for i in 2..=totp {
        if gtr(point[i].x, pt[0].x) {
            pt[0] = point[i];
        }
        if gtr(pt[1].x, point[i].x) {
            pt[1] = point[i];
        }
        if gtr(point[i].y, pt[2].y) {
            pt[2] = point[i];
        }
        if gtr(pt[3].y, point[i].y) {
            pt[3] = point[i];
        }
        if gtr(point[i].z, pt[4].z) {
            pt[4] = point[i];
        }
        if gtr(pt[5].z, point[i].z) {
            pt[5] = point[i];
        }
    }

    // Take the two points with the largest distance
    for i in 0..6 {
        for j in (i+1)..6 {
            if gtr(dist_point_point(&pt[i], &pt[j]), dist_point_point(&s[0], &s[1])) {
                s[0] = pt[i];
                s[1] = pt[j];
            }
        }
    }

    // Take the point farthest from the line connecting the two points
    for i in 0..6 {
        if gtr(
            dist_point_line(&pt[i], &Line::new(s[0], s[1])),
            dist_point_line(&s[2], &Line::new(s[0], s[1]))
        ) {
            s[2] = pt[i];
        }
    }

    // Take the point farthest from the face
    for i in 1..=totp {
        if gtr(
            abs(dist_point_plane(&point[i], &Plane::new(s[0], s[1], s[2]))),
            abs(dist_point_plane(&s[3], &Plane::new(s[0], s[1], s[2])))
        ) {
            s[3] = point[i];
        }
    }

    // Ensure that the constructed face faces outwards
    if gtr(0.0, dist_point_plane(&s[3], &Plane::new(s[0], s[1], s[2]))) {
        // Use the array swap method instead of std::mem::swap
        s.swap(1, 2);
    }

    // Construct simplex
    let mut f = [0; 4];
    for i in 0..4 {
        fac.push(Facet::new(
            fac.len(),
            Plane::new(
                Vect::new(0.0, 0.0, 0.0, 0),
                Vect::new(0.0, 0.0, 0.0, 0),
                Vect::new(0.0, 0.0, 0.0, 0)
            )
        ));
        f[i] = fac.len() - 1;
    }

    fac[f[0]].p = Plane::new(s[0], s[2], s[1]);  // Bottom face
    fac[f[1]].p = Plane::new(s[0], s[1], s[3]);
    fac[f[2]].p = Plane::new(s[1], s[2], s[3]);
    fac[f[3]].p = Plane::new(s[2], s[0], s[3]);

    fac[f[0]].set_neighbors(f[3], f[2], f[1]);
    fac[f[1]].set_neighbors(f[0], f[2], f[3]);
    fac[f[2]].set_neighbors(f[0], f[3], f[1]);
    fac[f[3]].set_neighbors(f[0], f[1], f[2]);

    // Assign point set space
    for _ in 0..5 {
        pts.push(Vec::new());
    }

    // Assign points to four faces
    for i in 1..=totp {
        if point[i].eq(&s[0]) || point[i].eq(&s[1]) || point[i].eq(&s[2]) || point[i].eq(&s[3]) {
            continue;
        }
        for j in 0..4 {
            if isabove(&point[i], &fac[f[j]].p) {
                pts[f[j]].push(point[i]);
                break;
            }
        }
    }

    // Return the initial simplex, using a face as index
    (ConvexHulls3d::new(f[0]), fac, pts)
}

fn quick_hull_3d(point: &[Vect], totp: usize) -> (ConvexHulls3d, Vec<Facet>) {
    let (mut hull, mut fac, mut pts) = get_start(point, totp);

    // Add the face of initial simplex to queue
    let mut que = Vec::new();
    que.push(hull.index);
    for i in 0..3 {
        que.push(fac[hull.index].n[i]);
    }

    // snew saves index face of the final convex hull
    let mut snew = 0;
    let mut time = 0;

    // Border line graph information
    let mut e1 = vec![Edge::new(); MAXN];
    let mut e2 = vec![Edge::new(); MAXN];

    // Timestamp of each point access
    let mut vistime = vec![0; MAXN];

    while !que.is_empty() {
        let nf = que.remove(0);

        // Skip if the current face has been deleted
        if fac[nf].isdel {
            continue;
        }

        // Skip if no vertices are allocated to the current face
        if pts[nf].is_empty() {
            snew = nf;
            continue;
        }

        // Find the farthest point from the face
        let mut p = pts[nf][0];
        for i in 1..pts[nf].len() {
            if gtr(
                dist_point_plane(&pts[nf][i], &fac[nf].p),
                dist_point_plane(&p, &fac[nf].p)
            ) {
                p = pts[nf][i];
            }
        }

        // Find the horizon
        time += 1;
        let mut resfdel = Vec::new();

        // The current face must be deleted, so start dfs from current face
        let s = hull.get_horizon(
            nf,
            p,
            &mut vistime,
            &mut e1,
            &mut e2,
            &mut resfdel,
            &mut fac,
            time,
        );

        // Iterate over horizon(go around a circle), construct new face
        let mut resfnew = Vec::new();
        time += 1;
        let mut from = 0;  // The previous visited point
        let mut lastf = 0;  // The last created face
        let mut fstf = 0;  // The first created face
        let mut s = s as usize;

        while vistime[s] != time {
            // Record whether the current point has been visited with timestamp
            vistime[s] = time;
            let  net ;  // Next point
            let  f ;  // The unseen face connected to the current edge on horizon
            let fnew;  // New face

            // Make sure the traversal direction is correct
            if e1[s].netid == from {
                net = e2[s].netid;
                f = e2[s].facetid;
            } else {
                net = e1[s].netid;
                f = e1[s].facetid;
            }

            // Find the counterclockwise information of these two points on the adjacent face
            let mut pt1 = -1;
            let mut pt2 = -1;
            for i in 0..3 {
                if point[s].eq(&fac[f].p.vec[i]) {
                    pt1 = i as isize;
                }
                if point[net].eq(&fac[f].p.vec[i]) {
                    pt2 = i as isize;
                }
            }

            // Make sure pt1->pt2 is arranged counterclockwise by adjacent face points
            if (pt1 + 1) % 3 != pt2 {
                let temp = pt1;
                pt1 = pt2;
                pt2 = temp;
            }

            // The face constructed in this way faces outward
            fac.push(Facet::new(
                fac.len(),
                Plane::new(
                    fac[f].p.vec[pt2 as usize],
                    fac[f].p.vec[pt1 as usize],
                    p
                ),
            ));

            fnew = fac.len() - 1;
            pts.push(Vec::new());
            resfnew.push(fnew);

            // Maintain adjacency information
            fac[fnew].n[0] = f;
            fac[f].n[pt1 as usize] = fnew;

            if lastf != 0 {
                // Can't determine whether to traverse clockwise or counterclockwise in advance
                // Maintain adjacency information between new faces
                if fac[fnew].p.vec[1].eq(&fac[lastf].p.vec[0]) {
                    fac[fnew].n[1] = lastf;
                    fac[lastf].n[2] = fnew;
                } else {
                    fac[fnew].n[2] = lastf;
                    fac[lastf].n[1] = fnew;
                }
            } else {
                fstf = fnew;  // No new face yet
            }

            lastf = fnew;
            from = s;
            s = net;
        }

        // Give the new face head and tail maintenance critical information
        if fac[fstf].p.vec[1].eq(&fac[lastf].p.vec[0]) {
            fac[fstf].n[1] = lastf;
            fac[lastf].n[2] = fstf;
        } else {
            fac[fstf].n[2] = lastf;
            fac[lastf].n[1] = fstf;
        }

        // Get all the points to be assigned
        let mut respt = Vec::new();
        for i in 0..resfdel.len() {
            for j in 0..pts[resfdel[i]].len() {
                respt.push(pts[resfdel[i]][j]);
            }
            pts[resfdel[i]].clear();
        }

        // Assign points
        for i in 0..respt.len() {
            if respt[i].eq(&p) {
                continue;  // Skip the points used to create the new face
            }
            for j in 0..resfnew.len() {
                if isabove(&respt[i], &fac[resfnew[j]].p) {
                    pts[resfnew[j]].push(respt[i]);
                    break;  // Make sure the points are not reassigned
                }
            }
        }

        // Add the new face to queue
        for i in 0..resfnew.len() {
            que.push(resfnew[i]);
        }
    }

    hull.index = snew;
    (hull, fac)
}

fn main() {
    let n = 4; // number of points
    let mut point = vec![Vect::new(0.0, 0.0, 0.0, 0)]; // 0th element is a placeholder

    let my_input = vec![
        [0.0, 0.0, 0.0],
        [1.0, 0.0, 0.0],
        [0.0, 1.0, 0.0],
        [0.0, 0.0, 1.0]
    ];

    for i in 1..=n {
        let (x, y, z) = (my_input[i-1][0], my_input[i-1][1], my_input[i-1][2]);
        point.push(Vect::new(x, y, z, i));
    }

    let (mut hull, mut fac) = quick_hull_3d(&point, n);
    let mut time = 0;

    println!("{:.3}", hull.get_surface_area(&mut fac, &mut time));
}
