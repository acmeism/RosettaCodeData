open System

[<Measure>] type deg
[<Measure>] type rad
[<Measure>] type km

let haversine (θ: float<rad>) = 0.5 * (1.0 - Math.Cos(θ/1.0<rad>))

let radPerDeg =  (Math.PI / 180.0) * 1.0<rad/deg>

type pos(latitude: float<deg>, longitude: float<deg>) =
    member this.φ = latitude * radPerDeg
    member this.ψ = longitude * radPerDeg

let rEarth = 6372.8<km>

let hsDist (p1: pos) (p2: pos) =
    2.0 * rEarth *
        Math.Asin(Math.Sqrt(haversine(p2.φ - p1.φ)+
                    Math.Cos(p1.φ/1.0<rad>)*Math.Cos(p2.φ/1.0<rad>)*haversine(p2.ψ - p1.ψ)))

[<EntryPoint>]
let main argv =
    printfn "%A" (hsDist (pos(36.12<deg>, -86.67<deg>)) (pos(33.94<deg>, -118.40<deg>)))
    0
