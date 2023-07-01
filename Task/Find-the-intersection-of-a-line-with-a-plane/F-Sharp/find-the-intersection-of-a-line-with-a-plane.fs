open System

type Vector(x : double, y : double, z : double) =
    member this.x = x
    member this.y = y
    member this.z = z
    static member (-) (lhs : Vector, rhs : Vector) =
        Vector(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    static member (*) (lhs : Vector, rhs : double) =
        Vector(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs)
    override this.ToString() =
        String.Format("({0:F}, {1:F}, {2:F})", x, y, z)

let Dot (lhs:Vector) (rhs:Vector) =
    lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z

let IntersectPoint rayVector rayPoint planeNormal planePoint =
    let diff = rayPoint - planePoint
    let prod1 = Dot diff planeNormal
    let prod2 = Dot rayVector planeNormal
    let prod3 = prod1 / prod2
    rayPoint - rayVector * prod3

[<EntryPoint>]
let main _ =
    let rv = Vector(0.0, -1.0, -1.0)
    let rp = Vector(0.0, 0.0, 10.0)
    let pn = Vector(0.0, 0.0, 1.0)
    let pp = Vector(0.0, 0.0, 5.0)
    let ip = IntersectPoint rv rp pn pp
    Console.WriteLine("The ray intersects the plane at {0}", ip)

    0 // return an integer exit code
