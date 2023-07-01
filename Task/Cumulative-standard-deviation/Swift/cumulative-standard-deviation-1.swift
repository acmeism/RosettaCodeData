import Darwin
class stdDev{

    var n:Double = 0.0
    var sum:Double = 0.0
    var sum2:Double = 0.0

    init(){

        let testData:[Double] = [2,4,4,4,5,5,7,9];
        for x in testData{

            var a:Double = calcSd(x)
            println("value \(Int(x)) SD = \(a)");
        }

    }

    func calcSd(x:Double)->Double{

        n += 1
        sum += x
        sum2 += x*x
        return sqrt( sum2 / n - sum*sum / n / n)
    }

}
var aa = stdDev()
