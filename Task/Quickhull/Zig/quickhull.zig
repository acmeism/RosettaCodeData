const std = @import("std");
const print = std.debug.print;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const math = std.math;

const MAXN: usize = 2500;
const EPS: f64 = 1e-8;

const Vect = struct {
    x: f64,
    y: f64,
    z: f64,
    id: usize,

    fn init(x: f64, y: f64, z: f64, id: usize) Vect {
        return Vect{ .x = x, .y = y, .z = z, .id = id };
    }

    fn sub(self: Vect, other: Vect) Vect {
        return Vect.init(self.x - other.x, self.y - other.y, self.z - other.z, 0);
    }

    fn cross(self: Vect, other: Vect) Vect {
        return Vect.init(
            self.y * other.z - self.z * other.y,
            self.z * other.x - self.x * other.z,
            self.x * other.y - self.y * other.x,
            0,
        );
    }

    fn dot(self: Vect, other: Vect) f64 {
        return self.x * other.x + self.y * other.y + self.z * other.z;
    }

    fn magnitude(self: Vect) f64 {
        return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z);
    }

    fn eq(self: Vect, other: Vect) bool {
        return floatEq(self.x, other.x) and floatEq(self.y, other.y) and floatEq(self.z, other.z);
    }
};

const Line = struct {
    u: Vect,
    v: Vect,

    fn init(u: Vect, v: Vect) Line {
        return Line{ .u = u, .v = v };
    }
};

const Plane = struct {
    vec: [3]Vect,

    fn init(my_u: Vect, my_v: Vect, my_w: Vect) Plane {
        return Plane{ .vec = [3]Vect{ my_u, my_v, my_w } };
    }

    fn normal(self: Plane) Vect {
        return self.vec[1].sub(self.vec[0]).cross(self.vec[2].sub(self.vec[0]));
    }

    fn u(self: Plane) Vect {
        return self.vec[0];
    }
};

fn gtr(a: f64, b: f64) bool {
    return a - b > EPS;
}

fn floatEq(a: f64, b: f64) bool {
    return -EPS < a - b and a - b < EPS;
}

fn absFloat(x: f64) f64 {
    return if (gtr(0.0, x)) -x else x;
}

// Signed distance
fn distPointPlane(v: Vect, p: Plane) f64 {
    const norm = p.normal();
    return v.sub(p.u()).dot(norm) / norm.magnitude();
}

// Unsigned distance
fn distPointLine(v: Vect, f: Line) f64 {
    if (v.sub(f.u).magnitude() > 0.0) {
        return f.v.sub(f.u).cross(v.sub(f.u)).magnitude() / f.v.sub(f.u).magnitude();
    } else {
        return 0.0;
    }
}

fn distPointPoint(u: Vect, v: Vect) f64 {
    return u.sub(v).magnitude();
}

fn isAbove(v: Vect, p: Plane) bool {
    return gtr(v.sub(p.u()).dot(p.normal()), 0.0);
}

const Facet = struct {
    n: [3]usize, // neighbors, correspond to point (u->v, v->w, w->u)
    id: usize,
    vistime: usize, // access timestamp
    isdel: bool,
    p: Plane,

    fn init(id: usize, p: Plane) Facet {
        return Facet{
            .n = [3]usize{ 0, 0, 0 },
            .id = id,
            .vistime = 0,
            .isdel = false,
            .p = p,
        };
    }

    fn setNeighbors(self: *Facet, n1: usize, n2: usize, n3: usize) void {
        self.n = [3]usize{ n1, n2, n3 };
    }
};

const Edge = struct {
    netid: usize,
    facetid: usize,

    fn init() Edge {
        return Edge{ .netid = 0, .facetid = 0 };
    }
};

const ConvexHulls3d = struct {
    index: usize, // Index face
    surfacearea: f64,

    fn init(index: usize) ConvexHulls3d {
        return ConvexHulls3d{
            .index = index,
            .surfacearea = 0.0,
        };
    }

    fn dfsArea(self: *ConvexHulls3d, nf: usize, fac: []Facet, time: *usize) void {
        // Already visited in current timestamp
        if (fac[nf].vistime == time.*) {
            return;
        }

        fac[nf].vistime = time.*;
        self.surfacearea += fac[nf].p.normal().magnitude() / 2.0;

        // Make a copy of neighbors to avoid borrow issues
        const neighbors = fac[nf].n;
        for (neighbors) |neighbor| {
            self.dfsArea(neighbor, fac, time);
        }
    }

    fn getSurfaceArea(self: *ConvexHulls3d, fac: []Facet, time: *usize) f64 {
        if (gtr(self.surfacearea, 0.0)) {
            return self.surfacearea;
        }
        time.* += 1;
        self.dfsArea(self.index, fac, time);
        return self.surfacearea;
    }

    fn getHorizon(
        self: ConvexHulls3d,
        f: usize,
        p: Vect,
        vistime: []usize,
        e1: []Edge,
        e2: []Edge,
        resfdel: *ArrayList(usize),
        fac: []Facet,
        time: usize,
    ) !i32 {
        if (!isAbove(p, fac[f].p)) {
            return 0;
        }

        if (fac[f].vistime == time) {
            return -1;
        }

        fac[f].vistime = time;
        // Mark the deleted face
        fac[f].isdel = true;
        try resfdel.append(fac[f].id);

        var ret: i32 = -2;

        // Make a copy of neighbors to avoid borrow issues
        const neighbors = fac[f].n;
        for (neighbors, 0..) |neighbor, i| {
            const res = try self.getHorizon(
                neighbor,
                p,
                vistime,
                e1,
                e2,
                resfdel,
                fac,
                time,
            );

            if (res == 0) {
                const pt = [2]usize{
                    fac[f].p.vec[i].id,
                    fac[f].p.vec[(i + 1) % 3].id,
                };

                for (pt, 0..) |point_id, j| {
                    if (vistime[point_id] != time) {
                        vistime[point_id] = time;
                        e1[point_id].netid = pt[(j + 1) % 2];
                        e1[point_id].facetid = neighbor;
                    } else {
                        e2[point_id].netid = pt[(j + 1) % 2];
                        e2[point_id].facetid = neighbor;
                    }
                }
                ret = @intCast(pt[0]);
            } else if (res != -1 and res != -2) {
                // The face is enclosed in the middle
                ret = res;
            }
        }

        return ret;
    }
};

// Construct initial simplex
fn getStart(allocator: Allocator, point: []Vect, totp: usize) !struct { ConvexHulls3d, ArrayList(Facet), ArrayList(ArrayList(Vect)) } {
    var fac = ArrayList(Facet).init(allocator);
    var pts = ArrayList(ArrayList(Vect)).init(allocator);

    // Add a dummy facet at index 0
    try fac.append(Facet.init(0, Plane.init(
        Vect.init(0.0, 0.0, 0.0, 0),
        Vect.init(0.0, 0.0, 0.0, 0),
        Vect.init(0.0, 0.0, 0.0, 0),
    )));

    var pt = [_]Vect{point[1]} ** 6;
    var s = [_]Vect{point[1]} ** 4;


    // Find the maximum point of the coordinate axis
    for (2..totp + 1) |i| {
        if (gtr(point[i].x, pt[0].x)) {
            pt[0] = point[i];
        }
        if (gtr(pt[1].x, point[i].x)) {
            pt[1] = point[i];
        }
        if (gtr(point[i].y, pt[2].y)) {
            pt[2] = point[i];
        }
        if (gtr(pt[3].y, point[i].y)) {
            pt[3] = point[i];
        }
        if (gtr(point[i].z, pt[4].z)) {
            pt[4] = point[i];
        }
        if (gtr(pt[5].z, point[i].z)) {
            pt[5] = point[i];
        }
    }

    // Take the two points with the largest distance
    for (0..6) |i| {
        for (i + 1..6) |j| {
            if (gtr(distPointPoint(pt[i], pt[j]), distPointPoint(s[0], s[1]))) {
                s[0] = pt[i];
                s[1] = pt[j];
            }
        }
    }

    // Take the point farthest from the line connecting the two points
    for (0..6) |i| {
        if (gtr(
            distPointLine(pt[i], Line.init(s[0], s[1])),
            distPointLine(s[2], Line.init(s[0], s[1])),
        )) {
            s[2] = pt[i];
        }
    }

    // Take the point farthest from the face
    for (1..totp + 1) |i| {
        if (gtr(
            absFloat(distPointPlane(point[i], Plane.init(s[0], s[1], s[2]))),
            absFloat(distPointPlane(s[3], Plane.init(s[0], s[1], s[2]))),
        )) {
            s[3] = point[i];
        }
    }

    // Ensure that the constructed face faces outwards
    if (gtr(0.0, distPointPlane(s[3], Plane.init(s[0], s[1], s[2])))) {
        // Swap s[1] and s[2]
        const temp = s[1];
        s[1] = s[2];
        s[2] = temp;
    }

    // Construct simplex
    var f = [4]usize{ 0, 0, 0, 0 };
    for (0..4) |i| {
        try fac.append(Facet.init(
            fac.items.len,
            Plane.init(
                Vect.init(0.0, 0.0, 0.0, 0),
                Vect.init(0.0, 0.0, 0.0, 0),
                Vect.init(0.0, 0.0, 0.0, 0),
            ),
        ));
        f[i] = fac.items.len - 1;
    }

    fac.items[f[0]].p = Plane.init(s[0], s[2], s[1]); // Bottom face
    fac.items[f[1]].p = Plane.init(s[0], s[1], s[3]);
    fac.items[f[2]].p = Plane.init(s[1], s[2], s[3]);
    fac.items[f[3]].p = Plane.init(s[2], s[0], s[3]);

    fac.items[f[0]].setNeighbors(f[3], f[2], f[1]);
    fac.items[f[1]].setNeighbors(f[0], f[2], f[3]);
    fac.items[f[2]].setNeighbors(f[0], f[3], f[1]);
    fac.items[f[3]].setNeighbors(f[0], f[1], f[2]);

    // Assign point set space
    for (0..5) |_| {
        try pts.append(ArrayList(Vect).init(allocator));
    }

    // Assign points to four faces
    for (1..totp + 1) |i| {
        if (point[i].eq(s[0]) or point[i].eq(s[1]) or point[i].eq(s[2]) or point[i].eq(s[3])) {
            continue;
        }
        for (0..4) |j| {
            if (isAbove(point[i], fac.items[f[j]].p)) {
                try pts.items[f[j]].append(point[i]);
                break;
            }
        }
    }

    // Return the initial simplex, using a face as index
    return .{ ConvexHulls3d.init(f[0]), fac, pts };
}

fn quickHull3d(allocator: Allocator, point: []Vect, totp: usize) !struct { ConvexHulls3d, ArrayList(Facet) } {
    const result = try getStart(allocator, point, totp);
    var hull = result[0];
    var fac = result[1];
    var pts = result[2];
    defer {
        for (pts.items) |*pt_list| {
            pt_list.deinit();
        }
        pts.deinit();
    }

    // Add the face of initial simplex to queue
    var que = ArrayList(usize).init(allocator);
    defer que.deinit();

    try que.append(hull.index);
    for (fac.items[hull.index].n) |neighbor| {
        try que.append(neighbor);
    }

    // snew saves index face of the final convex hull
    var snew: usize = 0;
    var time: usize = 0;

    // Border line graph information
    var e1 = try allocator.alloc(Edge, MAXN);
    defer allocator.free(e1);
    var e2 = try allocator.alloc(Edge, MAXN);
    defer allocator.free(e2);

    for (0..MAXN) |i| {
        e1[i] = Edge.init();
        e2[i] = Edge.init();
    }

    // Timestamp of each point access
    var vistime = try allocator.alloc(usize, MAXN);
    defer allocator.free(vistime);
    @memset(vistime, 0);

    while (que.items.len > 0) {
        const nf = que.orderedRemove(0);

        // Skip if the current face has been deleted
        if (fac.items[nf].isdel) {
            continue;
        }

        // Skip if no vertices are allocated to the current face
        if (pts.items[nf].items.len == 0) {
            snew = nf;
            continue;
        }

        // Find the farthest point from the face
        var p = pts.items[nf].items[0];
        for (1..pts.items[nf].items.len) |i| {
            if (gtr(
                distPointPlane(pts.items[nf].items[i], fac.items[nf].p),
                distPointPlane(p, fac.items[nf].p),
            )) {
                p = pts.items[nf].items[i];
            }
        }

        // Find the horizon
        time += 1;
        var resfdel = ArrayList(usize).init(allocator);
        defer resfdel.deinit();

        // The current face must be deleted, so start dfs from current face
        const s_result = try hull.getHorizon(
            nf,
            p,
            vistime,
            e1,
            e2,
            &resfdel,
            fac.items,
            time,
        );

        // Iterate over horizon(go around a circle), construct new face
        var resfnew = ArrayList(usize).init(allocator);
        defer resfnew.deinit();

        time += 1;
        var from: usize = 0; // The previous visited point
        var lastf: usize = 0; // The last created face
        var fstf: usize = 0; // The first created face
        var s: usize = @intCast(s_result);

        while (vistime[s] != time) {
            // Record whether the current point has been visited with timestamp
            vistime[s] = time;
            var net: usize = 0; // Next point
            var f: usize = 0; // The unseen face connected to the current edge on horizon
            var fnew: usize = 0; // New face

            // Make sure the traversal direction is correct
            if (e1[s].netid == from) {
                net = e2[s].netid;
                f = e2[s].facetid;
            } else {
                net = e1[s].netid;
                f = e1[s].facetid;
            }

            // Find the counterclockwise information of these two points on the adjacent face
            var pt1: i32 = -1;
            var pt2: i32 = -1;
            for (0..3) |i| {
                if (point[s].eq(fac.items[f].p.vec[i])) {
                    pt1 = @intCast(i);
                }
                if (point[net].eq(fac.items[f].p.vec[i])) {
                    pt2 = @intCast(i);
                }
            }

            // Make sure pt1->pt2 is arranged counterclockwise by adjacent face points
            if ((@rem(pt1 + 1, 3)) != pt2) {
                const temp = pt1;
                pt1 = pt2;
                pt2 = temp;
            }

            // The face constructed in this way faces outward
            try fac.append(Facet.init(
                fac.items.len,
                Plane.init(
                    fac.items[f].p.vec[@intCast(pt2)],
                    fac.items[f].p.vec[@intCast(pt1)],
                    p,
                ),
            ));

            fnew = fac.items.len - 1;
            try pts.append(ArrayList(Vect).init(allocator));
            try resfnew.append(fnew);

            // Maintain adjacency information
            fac.items[fnew].n[0] = f;
            fac.items[f].n[@intCast(pt1)] = fnew;

            if (lastf != 0) {
                // Can't determine whether to traverse clockwise or counterclockwise in advance
                // Maintain adjacency information between new faces
                if (fac.items[fnew].p.vec[1].eq(fac.items[lastf].p.vec[0])) {
                    fac.items[fnew].n[1] = lastf;
                    fac.items[lastf].n[2] = fnew;
                } else {
                    fac.items[fnew].n[2] = lastf;
                    fac.items[lastf].n[1] = fnew;
                }
            } else {
                fstf = fnew; // No new face yet
            }

            lastf = fnew;
            from = s;
            s = net;
        }

        // Give the new face head and tail maintenance critical information
        if (fac.items[fstf].p.vec[1].eq(fac.items[lastf].p.vec[0])) {
            fac.items[fstf].n[1] = lastf;
            fac.items[lastf].n[2] = fstf;
        } else {
            fac.items[fstf].n[2] = lastf;
            fac.items[lastf].n[1] = fstf;
        }

        // Get all the points to be assigned
        var respt = ArrayList(Vect).init(allocator);
        defer respt.deinit();

        for (resfdel.items) |deleted_face| {
            for (pts.items[deleted_face].items) |pt| {
                try respt.append(pt);
            }
            pts.items[deleted_face].clearAndFree();
        }

        // Assign points
        for (respt.items) |pt| {
            if (pt.eq(p)) {
                continue; // Skip the points used to create the new face
            }
            for (resfnew.items) |new_face| {
                if (isAbove(pt, fac.items[new_face].p)) {
                    try pts.items[new_face].append(pt);
                    break; // Make sure the points are not reassigned
                }
            }
        }

        // Add the new face to queue
        for (resfnew.items) |new_face| {
            try que.append(new_face);
        }
    }

    hull.index = snew;
    return .{ hull, fac };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const n = 4; // number of points
    var point = try allocator.alloc(Vect, n + 1); // 0th element is a placeholder
    defer allocator.free(point);

    point[0] = Vect.init(0.0, 0.0, 0.0, 0); // placeholder

    const my_input = [_][3]f64{
        [_]f64{ 0.0, 0.0, 0.0 },
        [_]f64{ 1.0, 0.0, 0.0 },
        [_]f64{ 0.0, 1.0, 0.0 },
        [_]f64{ 0.0, 0.0, 1.0 },
    };

    for (1..n + 1) |i| {
        const x = my_input[i - 1][0];
        const y = my_input[i - 1][1];
        const z = my_input[i - 1][2];
        point[i] = Vect.init(x, y, z, i);
    }

    const result = try quickHull3d(allocator, point, n);
    var hull = result[0];
    var fac = result[1];
    defer fac.deinit();

    var time: usize = 0;

    print("{d:.3}\n", .{hull.getSurfaceArea(fac.items, &time)});
}
