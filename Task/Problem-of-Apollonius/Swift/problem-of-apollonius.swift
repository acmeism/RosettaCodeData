import Foundation

struct Circle {
    let center:[Double]!
    let radius:Double!

    init(center:[Double], radius:Double) {
        self.center = center
        self.radius = radius
    }

    func toString() -> String {
        return "Circle[x=\(center[0]),y=\(center[1]),r=\(radius)]"
    }
}

func solveApollonius(c1:Circle, c2:Circle, c3:Circle,
    s1:Double, s2:Double, s3:Double) -> Circle {

        let x1 = c1.center[0]
        let y1 = c1.center[1]
        let r1 = c1.radius
        let x2 = c2.center[0]
        let y2 = c2.center[1]
        let r2 = c2.radius
        let x3 = c3.center[0]
        let y3 = c3.center[1]
        let r3 = c3.radius

        let v11 = 2*x2 - 2*x1
        let v12 = 2*y2 - 2*y1
        let v13 = x1*x1 - x2*x2 + y1*y1 - y2*y2 - r1*r1 + r2*r2
        let v14 = 2*s2*r2 - 2*s1*r1

        let v21 = 2*x3 - 2*x2
        let v22 = 2*y3 - 2*y2
        let v23 = x2*x2 - x3*x3 + y2*y2 - y3*y3 - r2*r2 + r3*r3
        let v24 = 2*s3*r3 - 2*s2*r2

        let w12 = v12/v11
        let w13 = v13/v11
        let w14 = v14/v11

        let w22 = v22/v21-w12
        let w23 = v23/v21-w13
        let w24 = v24/v21-w14

        let P = -w23/w22
        let Q = w24/w22
        let M = -w12*P-w13
        let N = w14 - w12*Q

        let a = N*N + Q*Q - 1
        let b = 2*M*N - 2*N*x1 + 2*P*Q - 2*Q*y1 + 2*s1*r1
        let c = x1*x1 + M*M - 2*M*x1 + P*P + y1*y1 - 2*P*y1 - r1*r1

        let D = b*b-4*a*c

        let rs = (-b - sqrt(D)) / (2*a)
        let xs = M + N * rs
        let ys = P + Q * rs

        return  Circle(center: [xs,ys], radius: rs)

}

let c1 = Circle(center: [0,0], radius: 1)
let c2 = Circle(center: [4,0], radius: 1)
let c3 = Circle(center: [2,4], radius: 2)

println(solveApollonius(c1,c2,c3,1,1,1).toString())
println(solveApollonius(c1,c2,c3,-1,-1,-1).toString())
