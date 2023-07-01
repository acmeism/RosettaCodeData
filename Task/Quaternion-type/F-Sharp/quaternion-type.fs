open System

[<Struct; StructuralEquality; NoComparison>]
type Quaternion(r : float, i : float, j : float, k : float) =
    member this.A = r
    member this.B = i
    member this.C = j
    member this.D = k

    new (f : float) = Quaternion(f, 0., 0., 0.)

    static member (~-) (q : Quaternion) = Quaternion(-q.A, -q.B, -q.C, -q.D)

    static member (+) (q1 : Quaternion, q2 : Quaternion) =
        Quaternion(q1.A + q2.A, q1.B + q2.B, q1.C + q2.C, q1.D + q2.D)
    static member (+) (q : Quaternion, r : float) = q + Quaternion(r)
    static member (+) (r : float, q: Quaternion) = Quaternion(r) + q

    static member (*) (q1 : Quaternion, q2 : Quaternion) =
        Quaternion(
            q1.A * q2.A - q1.B * q2.B - q1.C * q2.C - q1.D * q2.D,
            q1.A * q2.B + q1.B * q2.A + q1.C * q2.D - q1.D * q2.C,
            q1.A * q2.C - q1.B * q2.D + q1.C * q2.A + q1.D * q2.B,
            q1.A * q2.D + q1.B * q2.C - q1.C * q2.B + q1.D * q2.A)
    static member (*) (q : Quaternion, r : float) = q * Quaternion(r)
    static member (*) (r : float, q: Quaternion) = Quaternion(r) * q

    member this.Norm = Math.Sqrt(r * r + i * i + j * j + k * k)

    member this.Conjugate = Quaternion(r, -i, -j, -k)

    override this.ToString() = sprintf "Q(%f, %f, %f, %f)" r i j k

[<EntryPoint>]
let main argv =
    let q = Quaternion(1., 2., 3., 4.)
    let q1 = Quaternion(2., 3., 4., 5.)
    let q2 = Quaternion(3., 4., 5., 6.)
    let r = 7.

    printfn "q = %A" q
    printfn "q1 = %A" q1
    printfn "q2 = %A" q2
    printfn "r = %A" r

    printfn "q.Norm = %A" q.Norm
    printfn "q1.Norm = %A" q1.Norm
    printfn "q2.Norm = %A" q2.Norm

    printfn "-q = %A" -q
    printfn "q.Conjugate = %A" q.Conjugate

    printfn "q + r = %A" (q + (Quaternion r))
    printfn "q1 + q2 = %A" (q1 + q2)
    printfn "q2 + q1 = %A" (q2 + q1)

    printfn "q * r = %A" (q * r)
    printfn "q1 * q2 = %A" (q1 * q2)
    printfn "q2 * q1 = %A" (q2 * q1)

    printfn "q1*q2 %s q2*q1" (if (q1 * q2) = (q2 * q1) then "=" else "<>")
    printfn "q %s Q(1.,2.,3.,4.)" (if q = Quaternion(1., 2., 3., 4.) then "=" else "<>")
    0
