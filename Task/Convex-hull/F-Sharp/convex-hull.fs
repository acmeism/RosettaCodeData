open System

type Point =
    struct
        val X : int
        val Y : int
        new (x : int, y : int ) = {X = x; Y = y}
    end

let (poly : Point list) = [ Point(16,  3); Point(12, 17); Point( 0,  6); Point(-4, -6); Point(16,  6);
                            Point(16, -7); Point(16, -3); Point(17, -4); Point( 5, 19); Point(19, -8);
                            Point( 3, 16); Point(12, 13); Point( 3, -4); Point(17,  5); Point(-3, 15);
                            Point(-3, -9); Point( 0, 11); Point(-9, -3); Point(-4, -2); Point(12, 10)]


let affiche (lst : Point list) =
    let mutable (str : string) = List.fold (fun  acc (p : Point) -> acc + sprintf "(%d, %d) " p.X p.Y) "Convex Hull: [" lst
    printfn "%s" (str.[0.. str.Length - 2] + "]")

let ccw (p1 : Point) (p2 : Point) (p3 : Point) =
    (p2.X - p1.X) * (p3.Y - p1.Y) > (p2.Y - p1.Y) * (p3.X - p1.X)

let convexHull (poly : Point list) =
    let mutable (outHull : Point list) = List.Empty
    let mutable (k : int) = 0

    for p in poly do
        while k >= 2 && not (ccw outHull.[k-2] outHull.[k-1] p) do
            k <- k - 1
        if k >= outHull.Length
        then outHull <- outHull @ [p]
        else outHull <- outHull.[0..k - 1] @ [p]
        k <- k + 1

    let (t : int) = k + 1
    for p in List.rev poly do
        while k >= t && not (ccw outHull.[k-2] outHull.[k-1] p) do
            k <- k - 1
        if k >= outHull.Length
        then outHull <- outHull @ [p]
        else outHull <- outHull.[0..k - 1] @ [p]
        k <- k + 1

    outHull.[0 .. k - 2]

affiche (convexHull (List.sortBy (fun (x : Point) -> x.X, x.Y) poly))
