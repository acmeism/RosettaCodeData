open System

type Point = double * double
type Triangle = Point * Point * Point

let Det2D (t:Triangle) =
    let (p1, p2, p3) = t
    let (p1x, p1y) = p1
    let (p2x, p2y) = p2
    let (p3x, p3y) = p3

    p1x * (p2y - p3y) +
    p2x * (p3y - p1y) +
    p3x * (p1y - p2y)

let CheckTriWinding allowReversed t =
    let detTri = Det2D t
    if detTri < 0.0 then
        if allowReversed then
            let (p1, p2, p3) = t
            (p1, p3, p2)
        else
            raise (Exception "Triangle has wrong winding direction")
    else
        t

let boundaryCollideChk eps t =
    (Det2D t) < eps

let boundaryDoesntCollideChk eps t =
    (Det2D t) <= eps

let TriTri2D eps allowReversed onBoundary t1 t2 =
    // Triangles must be expressed anti-clockwise
    let t3 = CheckTriWinding allowReversed t1
    let t4 = CheckTriWinding allowReversed t2

    // 'onBoundary' determines whether points on boundary are considered as colliding or not
    let chkEdge = if onBoundary then boundaryCollideChk else boundaryDoesntCollideChk
    let (t1p1, t1p2, t1p3) = t3
    let (t2p1, t2p2, t2p3) = t4

    // Check all points of t2 lay on the external side of edge E.
    // If they do, the triangles do not overlap.
    if (chkEdge eps (t1p1, t1p2, t2p1)) && (chkEdge eps (t1p1, t1p2, t2p2)) && (chkEdge eps (t1p1, t1p2, t2p3)) then
        false
    else if (chkEdge eps (t1p2, t1p3, t2p1)) && (chkEdge eps (t1p2, t1p3, t2p2)) && (chkEdge eps (t1p2, t1p3, t2p3)) then
        false
    else if (chkEdge eps (t1p3, t1p1, t2p1)) && (chkEdge eps (t1p3, t1p1, t2p2)) && (chkEdge eps (t1p3, t1p1, t2p3)) then
        false

    // Check all points of t1 lay on the external side of edge E.
    // If they do, the triangles do not overlap.
    else if (chkEdge eps (t2p1, t2p2, t1p1)) && (chkEdge eps (t2p1, t2p2, t1p2)) && (chkEdge eps (t2p1, t2p2, t1p3)) then
        false
    else if (chkEdge eps (t2p2, t2p3, t1p1)) && (chkEdge eps (t2p2, t2p3, t1p2)) && (chkEdge eps (t2p2, t2p3, t1p3)) then
        false
    else if (chkEdge eps (t2p3, t2p1, t1p1)) && (chkEdge eps (t2p3, t2p1, t1p2)) && (chkEdge eps (t2p3, t2p1, t1p3)) then
        false

    else
        // The triangles overlap
        true

let Print t1 t2 =
    Console.WriteLine("{0} and\n{1}\n{2}\n", t1, t2, if TriTri2D 0.0 false true t1 t2 then "overlap" else "do not overlap")

[<EntryPoint>]
let main _ =
    let t1 = ((0.0, 0.0), (5.0, 0.0), (0.0, 5.0))
    let t2 = ((0.0, 0.0), (5.0, 0.0), (0.0, 6.0))
    Print t1 t2

    let t3 = ((0.0, 0.0), (0.0, 5.0), (5.0, 0.0))
    Console.WriteLine("{0} and\n{1}\n{2}\n", t3, t3, if TriTri2D 0.0 true true t3 t3 then "overlap (reversed)" else "do not overlap")

    let t4 = ((0.0, 0.0), (5.0, 0.0), (0.0, 5.0))
    let t5 = ((-10.0, 0.0), (-5.0, 0.0), (-1.0, 6.0))
    Print t4 t5

    let t6 = ((0.0, 0.0), (5.0, 0.0), (2.5, 5.0))
    let t7 = ((0.0, 4.0), (2.5, -1.0), (5.0, 4.0))
    Print t6 t7

    let t8 = ((0.0, 0.0), (1.0, 1.0), (0.0, 2.0))
    let t9 = ((2.0, 1.0), (3.0, 0.0), (3.0, 2.0))
    Print t8 t9

    let t10 = ((2.0, 1.0), (3.0, -2.0), (3.0, 4.0))
    Print t8 t10

    let t11 = ((0.0, 0.0), (1.0, 0.0), (0.0, 1.0))
    let t12 = ((1.0, 0.0), (2.0, 0.0), (1.0, 1.1))
    printfn "The following triangles which have only a single corner in contact, if boundary points collide"
    Print t11 t12

    Console.WriteLine("{0} and\n{1}\nwhich have only a single corner in contact, if boundary points do not collide\n{2}", t11, t12, if TriTri2D 0.0 false false t11 t12 then "overlap" else "do not overlap")

    0 // return an integer exit code
