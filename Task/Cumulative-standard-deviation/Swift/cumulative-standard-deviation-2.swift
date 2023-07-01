func standardDeviation(arr : [Double]) -> Double
{
    let length = Double(arr.count)
    let avg = arr.reduce(0, { $0 + $1 }) / length
    let sumOfSquaredAvgDiff = arr.map { pow($0 - avg, 2.0)}.reduce(0, {$0 + $1})
    return sqrt(sumOfSquaredAvgDiff / length)
}

let responseTimes = [ 18.0, 21.0, 41.0, 42.0, 48.0, 50.0, 55.0, 90.0 ]

standardDeviation(responseTimes) // 20.8742514835862
standardDeviation([2,4,4,4,5,5,7,9]) // 2.0
