use std::error::Error;
use std::fmt;

type TriPoint = (f64, f64);

#[derive(Debug)]
struct TriangleWindingError;

impl fmt::Display for TriangleWindingError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "triangle has wrong winding direction")
    }
}

impl Error for TriangleWindingError {}

#[inline]
fn det_2d(p1: &TriPoint, p2: &TriPoint, p3: &TriPoint) -> f64 {
    p1.0 * (p2.1 - p3.1) + p2.0 * (p3.1 - p1.1) + p3.0 * (p1.1 - p2.1)
}

fn check_tri_winding(
    triangle: &mut [TriPoint; 3],
    allow_reversed: bool,
) -> Result<(), TriangleWindingError> {
    let det_tri = det_2d(&triangle[0], &triangle[1], &triangle[2]);
    if det_tri < 0.0 {
        if allow_reversed {
            triangle.swap(1, 2);
        } else {
            return Err(TriangleWindingError);
        }
    }
    Ok(())
}

fn boundary_collide_chk(p1: &TriPoint, p2: &TriPoint, p3: &TriPoint, eps: f64) -> bool {
    det_2d(p1, p2, p3) < eps
}

fn boundary_doesnt_collide_chk(p1: &TriPoint, p2: &TriPoint, p3: &TriPoint, eps: f64) -> bool {
    det_2d(p1, p2, p3) <= eps
}

fn tri_tri_2d(
    t1: &mut [TriPoint; 3],
    t2: &mut [TriPoint; 3],
    eps: f64,
    allow_reversed: bool,
    on_boundary: bool,
) -> Result<bool, TriangleWindingError> {
    // Triangles must be expressed anti-clockwise
    check_tri_winding(t1, allow_reversed)?;
    check_tri_winding(t2, allow_reversed)?;

    let chk_edge: fn(&TriPoint, &TriPoint, &TriPoint, f64) -> bool = if on_boundary {
        // Points on the boundary are considered as colliding
        boundary_collide_chk
    } else {
        // Points on the boundary are not considered as colliding
        boundary_doesnt_collide_chk
    };

    // For edge E of triangle 1,
    for i in 0..3 {
        let j = (i + 1) % 3;

        // Check all points of triangle 2 lay on the external side of the edge E. If
        // they do, the triangles do not collide.
        if chk_edge(&t1[i], &t1[j], &t2[0], eps)
            && chk_edge(&t1[i], &t1[j], &t2[1], eps)
            && chk_edge(&t1[i], &t1[j], &t2[2], eps)
        {
            return Ok(false);
        }
    }

    // For edge E of triangle 2,
    for i in 0..3 {
        let j = (i + 1) % 3;

        // Check all points of triangle 1 lay on the external side of the edge E. If
        // they do, the triangles do not collide.
        if chk_edge(&t2[i], &t2[j], &t1[0], eps)
            && chk_edge(&t2[i], &t2[j], &t1[1], eps)
            && chk_edge(&t2[i], &t2[j], &t1[2], eps)
        {
            return Ok(false);
        }
    }

    // The triangles collide
    Ok(true)
}

// Helper function for cleaner testing
fn tri_tri_2d_simple(
    t1: [TriPoint; 3],
    t2: [TriPoint; 3],
    eps: f64,
    allow_reversed: bool,
    on_boundary: bool,
) -> bool {
    let mut t1_mut = t1;
    let mut t2_mut = t2;
    tri_tri_2d(&mut t1_mut, &mut t2_mut, eps, allow_reversed, on_boundary).unwrap_or(false)
}

fn main() {
    {
        let t1 = [(0.0, 0.0), (5.0, 0.0), (0.0, 5.0)];
        let t2 = [(0.0, 0.0), (5.0, 0.0), (0.0, 6.0)];
        println!("{},{}", tri_tri_2d_simple(t1, t2, 0.0, false, true), true);
    }

    {
        let t1 = [(0.0, 0.0), (0.0, 5.0), (5.0, 0.0)];
        let t2 = [(0.0, 0.0), (0.0, 5.0), (5.0, 0.0)];
        println!("{},{}", tri_tri_2d_simple(t1, t2, 0.0, true, true), true);
    }

    {
        let t1 = [(0.0, 0.0), (5.0, 0.0), (0.0, 5.0)];
        let t2 = [(-10.0, 0.0), (-5.0, 0.0), (-1.0, 6.0)];
        println!("{},{}", tri_tri_2d_simple(t1, t2, 0.0, false, true), false);
    }

    {
        let t1 = [(0.0, 0.0), (5.0, 0.0), (2.5, 5.0)];
        let t2 = [(0.0, 4.0), (2.5, -1.0), (5.0, 4.0)];
        println!("{},{}", tri_tri_2d_simple(t1, t2, 0.0, false, true), true);
    }

    {
        let t1 = [(0.0, 0.0), (1.0, 1.0), (0.0, 2.0)];
        let t2 = [(2.0, 1.0), (3.0, 0.0), (3.0, 2.0)];
        println!("{},{}", tri_tri_2d_simple(t1, t2, 0.0, false, true), false);
    }

    {
        let t1 = [(0.0, 0.0), (1.0, 1.0), (0.0, 2.0)];
        let t2 = [(2.0, 1.0), (3.0, -2.0), (3.0, 4.0)];
        println!("{},{}", tri_tri_2d_simple(t1, t2, 0.0, false, true), false);
    }

    // Barely touching
    {
        let t1 = [(0.0, 0.0), (1.0, 0.0), (0.0, 1.0)];
        let t2 = [(1.0, 0.0), (2.0, 0.0), (1.0, 1.0)];
        println!("{},{}", tri_tri_2d_simple(t1, t2, 0.0, false, true), true);
    }

    // Barely touching
    {
        let t1 = [(0.0, 0.0), (1.0, 0.0), (0.0, 1.0)];
        let t2 = [(1.0, 0.0), (2.0, 0.0), (1.0, 1.0)];
        println!("{},{}", tri_tri_2d_simple(t1, t2, 0.0, false, false), false);
    }
}
