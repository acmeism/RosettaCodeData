// Algorithm from https://en.wikipedia.org/wiki/Dutch_national_flag_problem
func partition3<T: Comparable>(_ a: inout [T], mid: T) {
    var i = 0
    var j = 0
    var k = a.count - 1
    while j <= k {
        if a[j] < mid {
            a.swapAt(i, j);
            i += 1;
            j += 1;
        } else if a[j] > mid {
            a.swapAt(j, k);
            k -= 1;
        } else {
            j += 1;
        }
    }
}

func isSorted<T: Comparable>(_ a: [T]) -> Bool {
    var i = 0
    let n = a.count
    while i + 1 < n {
        if a[i] > a[i + 1] {
            return false
        }
        i += 1
    }
    return true
}

enum Ball : CustomStringConvertible, Comparable {
  case red
  case white
  case blue

  var description : String {
    switch self {
    case .red: return "red"
    case .white: return "white"
    case .blue: return "blue"
    }
  }
}

var balls: [Ball] = [ Ball.red, Ball.white, Ball.blue,
                      Ball.red, Ball.white, Ball.blue,
                      Ball.red, Ball.white, Ball.blue]
balls.shuffle()
print("\(balls)")
print("Sorted: \(isSorted(balls))")

partition3(&balls, mid: Ball.white)
print("\(balls)")
print("Sorted: \(isSorted(balls))")
