import Foundation

let numberFormat = " %7.3f"
let k = 0.07
let initialTemp = 100.0
let finalTemp = 20.0
let startTime = 0
let endTime = 100

func ivpEuler(function: (Double, Double) -> Double, initialValue: Double, step: Int) {
    print(String(format: " Step %2d: ", step), terminator: "")
    var y = initialValue
    for t in stride(from: startTime, through: endTime, by: step) {
        if t % 10 == 0 {
            print(String(format: numberFormat, y), terminator: "")
        }
        y += Double(step) * function(Double(t), y)
    }
    print()
}

func analytic() {
    print("    Time: ", terminator: "")
    for t in stride(from: startTime, through: endTime, by: 10) {
        print(String(format: " %7d", t), terminator: "")
    }
    print("\nAnalytic: ", terminator: "")
    for t in stride(from: startTime, through: endTime, by: 10) {
        let temp = finalTemp + (initialTemp - finalTemp) * exp(-k * Double(t))
        print(String(format: numberFormat, temp), terminator: "")
    }
    print()
}

func cooling(t: Double, temp: Double) -> Double {
    return -k * (temp - finalTemp)
}

analytic()
ivpEuler(function: cooling, initialValue: initialTemp, step: 2)
ivpEuler(function: cooling, initialValue: initialTemp, step: 5)
ivpEuler(function: cooling, initialValue: initialTemp, step: 10)
