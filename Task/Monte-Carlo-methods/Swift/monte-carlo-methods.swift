import Foundation

func mcpi(sampleSize size:Int) -> Double {
    var x = 0 as Double
    var y = 0 as Double
    var m = 0 as Double

    for i in 0..<size {
        x = Double(arc4random()) / Double(UINT32_MAX)
        y = Double(arc4random()) / Double(UINT32_MAX)

        if ((x * x) + (y * y) < 1) {
            m += 1
        }
    }

    return (4.0 * m) / Double(size)
}

println(mcpi(sampleSize: 100))
println(mcpi(sampleSize: 1000))
println(mcpi(sampleSize: 10000))
println(mcpi(sampleSize: 100000))
println(mcpi(sampleSize: 1000000))
println(mcpi(sampleSize: 10000000))
println(mcpi(sampleSize: 100000000))
