// Structure
struct Point {
    var x:Int
    var y:Int
}

// Tuple
typealias PointTuple = (Int, Int)

// Class
class PointClass {
    var x:Int!
    var y:Int!

    init(x:Int, y:Int) {
        self.x = x
        self.y = y
    }
}
