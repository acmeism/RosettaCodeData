struct Point {
    x f64
	y f64
}

fn (p Point) str() string {
    return "(${p.x:.1f}, ${p.y:.1f})"
}

struct Triangle {
mut:
    p1 Point
	p2 Point
	p3 Point
}

fn (t Triangle) str() string {
    return "Triangle $t.p1, $t.p2, $t.p3"
}

fn (t Triangle) det_2d() f64 {
    return t.p1.x * (t.p2.y - t.p3.y) +
           t.p2.x * (t.p3.y - t.p1.y) +
           t.p3.x * (t.p1.y - t.p2.y)
}

fn (mut t Triangle) check_tri_winding(allow_reversed bool) {
    det_tri := t.det_2d()
    if det_tri < 0.0 {
        if allow_reversed {
            a := t.p3
            t.p3 = t.p2
            t.p2 = a
        } else {
            panic("Triangle has wrong winding direction.")
        }
    }
}

fn boundary_collide_chk(t Triangle, eps f64, does bool) bool {
	if does {
    	return t.det_2d() < eps
	}
	return t.det_2d() <= eps
}

fn tri_tri_2d(mut t1 Triangle, mut t2 Triangle, eps f64, allow_reversed bool, on_boundary bool) bool {
    // Triangles must be expressed anti-clockwise.
    t1.check_tri_winding(allow_reversed)
    t2.check_tri_winding(allow_reversed)

    lp1 := [t1.p1, t1.p2, t1.p3]
    lp2 := [t2.p1, t2.p2, t2.p3]

    // for each edge E of t1
    for i in 0..3 {
        j := (i + 1) % 3
        // Check all Points of t2 lay on the external side of edge E.
        // If they do, the Triangles do not overlap.
        tri1 := Triangle{lp1[i], lp1[j], lp2[0]}
        tri2 := Triangle{lp1[i], lp1[j], lp2[1]}
        tri3 := Triangle{lp1[i], lp1[j], lp2[2]}
        if boundary_collide_chk(tri1, eps,on_boundary) && boundary_collide_chk(tri2, eps,on_boundary) && boundary_collide_chk(tri3, eps,on_boundary) {
            return false
        }
    }

    // for each edge E of t2
    for i in 0..3 {
        j := (i + 1) % 3
        // Check all Points of t1 lay on the external side of edge E.
        // If they do, the Triangles do not overlap.
        tri1 := Triangle{lp2[i], lp2[j], lp1[0]}
        tri2 := Triangle{lp2[i], lp2[j], lp1[1]}
        tri3 := Triangle{lp2[i], lp2[j], lp1[2]}
        if boundary_collide_chk(tri1, eps,on_boundary) && boundary_collide_chk(tri2, eps,on_boundary) && boundary_collide_chk(tri3, eps,on_boundary) {
            return false
        }
    }

    // The Triangles overlap.
    return true
}

fn iff(cond bool, s1 string, s2 string) string {
    if cond {
        return s1
    }
    return s2
}

fn main() {
    mut t1 := Triangle{Point{0.0, 0.0}, Point{5.0, 0.0}, Point{0.0, 5.0}}
    mut t2 := Triangle{Point{0.0, 0.0}, Point{5.0, 0.0}, Point{0.0, 6.0}}
    println("\n$t1 and\n$t2")
    mut overlapping := tri_tri_2d(mut t1, mut t2, 0.0, false, true)
    println(iff(overlapping, "overlap", "do not overlap"))

    // Need to allow reversed for this pair to avoid panic.
    t1 = Triangle{Point{0.0, 0.0}, Point{0.0, 5.0}, Point{5.0, 0.0}}
    t2 = t1
    println("\n$t1 and\n$t2")
    overlapping = tri_tri_2d(mut t1, mut t2, 0.0, true, true)
    println(iff(overlapping, "overlap (reversed)", "do not overlap"))

    t1 = Triangle{Point{0.0, 0.0}, Point{5.0, 0.0}, Point{0.0, 5.0}}
    t2 = Triangle{Point{-10.0, 0.0}, Point{-5.0, 0.0}, Point{-1.0, 6.0}}
    println("\n$t1 and\n$t2")
    overlapping = tri_tri_2d(mut t1, mut t2, 0.0, false, true)
    println(iff(overlapping, "overlap", "do not overlap"))

    t1.p3 = Point{2.5, 5.0}
    t2 = Triangle{Point{0.0, 4.0}, Point{2.5, -1.0}, Point{5.0, 4.0}}
    println("\n$t1 and\n$t2")
    overlapping = tri_tri_2d(mut t1, mut t2, 0.0, false, true)
    println(iff(overlapping, "overlap", "do not overlap"))

    t1 = Triangle{Point{0.0, 0.0}, Point{1.0, 1.0}, Point{0.0, 2.0}}
    t2 = Triangle{Point{2.0, 1.0}, Point{3.0, 0.0}, Point{3.0, 2.0}}
    println("\n$t1 and\n$t2")
    overlapping = tri_tri_2d(mut t1, mut t2, 0.0, false, true)
    println(iff(overlapping, "overlap", "do not overlap"))

    t2 = Triangle{Point{2.0, 1.0}, Point{3.0, -2.0}, Point{3.0, 4.0}}
    println("\n$t1 and\n$t2")
    overlapping = tri_tri_2d(mut t1, mut t2, 0.0, false, true)
    println(iff(overlapping, "overlap", "do not overlap"))

    t1 = Triangle{Point{0.0, 0.0}, Point{1.0, 0.0}, Point{0.0, 1.0}}
    t2 = Triangle{Point{1.0, 0.0}, Point{2.0, 0.0}, Point{1.0, 1.1}}
    println("\n$t1 and\n$t2")
    println("which have only a single corner in contact, if boundary Points collide")
    overlapping = tri_tri_2d(mut t1, mut t2, 0.0, false, true)
    println(iff(overlapping, "overlap", "do not overlap"))

    println("\n$t1 and\n$t2")
    println("which have only a single corner in contact, if boundary Points do not collide")
    overlapping = tri_tri_2d(mut t1, mut t2, 0.0, false, false)
    println(iff(overlapping, "overlap", "do not overlap"))
}
