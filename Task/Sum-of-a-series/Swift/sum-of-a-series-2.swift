Swift also allows extension to datatypes.  Here's similar code using an extension to Int.

extension Int {
    func SumSeries() -> Double {
        var ret: Double = 0

        for i in 1...self {
           ret += (1 / pow(Double(i), 2))
        }

        return ret
    }
}

var x: Int = 1000
var y: Double

y = x.sumSeries()   /* y = 1.64393456668156 */

Swift also allows you to do this:

y = 1000.sumSeries()
