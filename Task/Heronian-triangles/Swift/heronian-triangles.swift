import Foundation

typealias PrimitiveHeronianTriangle = (s1:Int, s2:Int, s3:Int, p:Int, a:Int)

func heronianArea(side1 s1:Int, side2 s2:Int, side3 s3:Int) -> Int? {
    let d1 = Double(s1)
    let d2 = Double(s2)
    let d3 = Double(s3)

    let s = (d1 + d2 + d3) / 2.0
    let a = sqrt(s * (s - d1) * (s - d2) * (s - d3))

    if a % 1 != 0 || a <= 0 {
        return nil
    } else {
        return Int(a)
    }
}

func gcd(a:Int, b:Int) -> Int {
    if b != 0 {
        return gcd(b, a % b)
    } else {
        return abs(a)
    }
}

var triangles = [PrimitiveHeronianTriangle]()

for s1 in 1...200 {
    for s2 in 1...s1 {
        for s3 in 1...s2 {
            if gcd(s1, gcd(s2, s3)) == 1, let a = heronianArea(side1: s1, side2: s2, side3: s3) {
                triangles.append((s3, s2, s1, s1 + s2 + s3, a))
            }
        }
    }
}

sort(&triangles) {t1, t2 in
    if t1.a < t2.a || t1.a == t2.a && t1.p < t2.p {
        return true
    } else {
        return false
    }
}

println("Number of primitive Heronian triangles with sides up to 200: \(triangles.count)\n")
println("First ten sorted by area, then perimeter, then maximum side:\n")
println("Sides\t\t\tPerimeter\tArea")

for t in triangles[0...9] {
    println("\(t.s1)\t\(t.s2)\t\(t.s3)\t\t\(t.p)\t\t\(t.a)")
}
