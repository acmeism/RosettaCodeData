open System

let add (a:double, b:double) (x:double, y:double) = (a + x, b + y)
let sub (a:double, b:double) (x:double, y:double) = (a - x, b - y)
let magSqr (a:double, b:double) = a * a + b * b
let mag a:double = Math.Sqrt(magSqr a)
let mul (a:double, b:double) c = (a * c, b * c)
let div2 (a:double, b:double) c = (a / c, b / c)
let perp (a:double, b:double) = (-b, a)
let norm a = div2 a (mag a)

let circlePoints p q (radius:double) =
    let diameter = radius * 2.0
    let pq = sub p q
    let magPQ = mag pq
    let midpoint = div2 (add p q) 2.0
    let halfPQ = magPQ / 2.0
    let magMidC = Math.Sqrt(Math.Abs(radius * radius - halfPQ * halfPQ))
    let midC = mul (norm (perp pq)) magMidC
    let center1 = add midpoint midC
    let center2 = sub midpoint midC
    if radius = 0.0 then None
    else if p = q then None
    else if diameter < magPQ then None
    else Some (center1, center2)

[<EntryPoint>]
let main _ =
    printfn "%A" (circlePoints (0.1234, 0.9876) (0.8765, 0.2345) 2.0)
    printfn "%A" (circlePoints (0.0, 2.0) (0.0, 0.0) 1.0)
    printfn "%A" (circlePoints (0.1234, 0.9876) (0.1234, 0.9876) 2.0)
    printfn "%A" (circlePoints (0.1234, 0.9876) (0.8765, 0.2345) 0.5)
    printfn "%A" (circlePoints (0.1234, 0.9876) (0.1234, 0.1234) 0.0)

    0 // return an integer exit code
