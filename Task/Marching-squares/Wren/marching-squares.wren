import "./seq" for Lst, FrozenList

/* A direction in the plane. */
class Direction {
    // statics
    static E  { new_( 1,  0) }
    static NE { new_( 1,  1) }
    static N  { new_( 0,  1) }
    static NW { new_(-1,  1) }
    static W  { new_(-1,  0) }
    static SW { new_(-1, -1) }
    static S  { new_( 0, -1) }
    static SE { new_( 1, -1) }

    // private constructor
    construct new_(x, y) {
        _planeX  = x
        _planeY  = y
        _screenX = x
        _screenY = -y
        _length = (x != 0 && y != 0) ? 2.sqrt/2 : 1
    }

    // property getters
    planeX  { _planeX  }  // horizontal distance moved in this direction within the plane
    planeY  { _planeY  }  // vertical distance moved in this direction within the plane
    screenX { _screenX }  // horizontal distance moved in this direction in screen coordinates
    screenY { _screenY }  // vertical distance moved in this direction in screen coordinates
    length  { _length  }  // euclidean length of this direction's vectors

    // equality override
    ==(that) {
        if (Object.same(this, that)) return true
        return _planeX == that.planeX && _planeY == that.planeY &&
               _screenX == that.screenX && _screenY == that.screenY &&
               _length == that.length
    }

    // string representation
    toString {
        if (this == Direction.E)  return "E"
        if (this == Direction.NE) return "NE"
        if (this == Direction.N)  return "N"
        if (this == Direction.NW) return "NW"
        if (this == Direction.W)  return "W"
        if (this == Direction.SW) return "SW"
        if (this == Direction.S)  return "S"
        if (this == Direction.SE) return "SE"
        return ""
    }
}

/* Combines a sequence of directions into a path that is rooted at some point in the plane.
   No restrictions are placed on Path objects which are immutable. */
class Path {
    // static
    static ADJ_LEN  { 2.sqrt/2 - 1 }

    // public constructor
    construct new(startX, startY, directions) {
        _originX = startX
        _originY = startY
        _directions = Lst.clone(directions)
        _directionList = FrozenList.new(directions)
        var endX = startX
        var endY = startY
        var diagonals = 0
        for (direction in directions) {
            endX = endX + direction.screenX
            endY = endY + direction.screenY
            if (direction.screenX != 0 && direction.screenY != 0) {
                diagonals = diagonals + 1
            }
        }
        _terminalX = endX
        _terminalY = endY
        _length = directions.count + diagonals * Path.ADJ_LEN
    }

    // private constructor
     construct new_(that, deltaX, deltaY) {
        _directions = that.directions
        _directionList = that.directionList
        _length = that.length
        _originX = that.originX + deltaX
        _originY = that.originY + deltaY
        _terminalX = that.terminalX + deltaX
        _terminalY = that.terminalY + deltaY
    }

    // property getters
    directions { _directionList }  // immutable list of directions that compose this path
    originX    { _originX       }  // x coordinate in the plane at which the path begins
    originY    { _originY       }  // y coordinate in the plane at which the path begins
    terminalX  { _terminalX     }  // x coordinate in the plane at which the path ends
    terminalY  { _terminalY     }  // y coordinate in the plane at which the path ends
    length     { _length        }  // length of the path using the standard Euclidean metric

    // returns whether the path's point of origin is the same as its point of termination
    isClosed   { _originX == _terminalX && _originY == _terminalY }

    // creates a new Path by translating this path in the plane.
    translate(deltaX, deltaY) { Path.new_(this, deltaX, deltaY) }

    // equals override
    ==(that) {
        if (Object.same(this, that)) return true
        if (!(that is Path)) return false
        if (_originX != that.originX) return false
        if (_originY != that.originY) return false
        if (_terminalX != that.terminalX) return false
        if (_terminalY != that.terminalY) return false
        if (!Lst.areEqual(_directions, that.directions)) return false
        return true
    }

    // string representation
    toString { "X: %(originX), Y: %(originY), Path: %(_directions)" }
}

/* A simple implementation of the marching squares algorithm that can identify
   perimeters in a supplied byte array. */
class MarchingSquares {
    // constructor
    construct new(width, height, data) {
        _width = width
        _height = height
        _data = data  // not copied but should not be changed
    }

    // property getters
    width  { _width  }  // width of the data matrix
    height { _height }  // height of the data matrix
    data   { _data   }  // data matrix

    /* methods */

    // finds the perimeter between a set of zero and non-zero values which
	// begins at the specified data element - always returns a closed path
    identifyPerimeter(initialX, initialY) {
        if (initialX < 0) initialX = 0
        if (initialX > _width) initialX = _width
        if (initialY < 0) initialY = 0
        if (initialY > _height) initialY = _height
        var initialValue = value_(initialX, initialY)
        if (initialValue == 0 || initialValue == 15) {
            Fiber.abort("Supplied initial coordinates (%(initialX), %(initialY) " +
                        "do not lie on a perimeter.")
        }
        var directions = []
        var x = initialX
        var y = initialY
        var previous = null
        while (true) {
            var direction
            var v = value_(x, y)
            if (v == 1 || v == 5 || v == 13) {
                direction = Direction.N
            } else if (v == 2 || v == 3 || v == 7) {
                direction = Direction.E
            } else if (v == 4 || v == 12 || v == 14) {
                direction = Direction.W
            } else if (v == 8 || v == 10 || v == 11) {
                direction = Direction.S
            } else if (v == 6) {
                direction = (previous == Direction.N) ? Direction.W : Direction.E
            } else if (v == 9) {
                direction = (previous == Direction.E) ? Direction.N : Direction.S
            } else {
                Fiber.abort("Illegal state.")
            }
            directions.add(direction)
            x = x + direction.screenX
            y = y + direction.screenY
            previous = direction
            if (x == initialX && y == initialY) break
        }
        return Path.new(initialX, -initialY, directions)
    }

    // convenience version of above method to be used where no initial point is known
    // returns null if there is no perimeter
    identifyPerimeter() {
        var size = width * height
        for (i in 0...size) {
            if (_data[i] != 0) return identifyPerimeter(i % _width, (i / _width).floor)
        }
        return null
    }

    // private utility methods
    value_(x, y) {
        var sum = 0
        if (isSet_(x, y))     sum = sum | 1
        if (isSet_(x+1, y))   sum = sum | 2
        if (isSet_(x, y+1))   sum = sum | 4
        if (isSet_(x+1, y+1)) sum = sum | 8
        return sum
    }

    isSet_(x, y) {
        return (x <= 0 || x > width || y <= 0 || y > height) ? false :
            _data[(y - 1) * width + (x - 1)] != 0
    }
}

var example = [
    0, 0, 0, 0, 0,
    0, 0, 0, 0, 0,
    0, 0, 1, 1, 0,
    0, 0, 1, 1, 0,
    0, 0, 0, 1, 0,
    0, 0, 0, 0, 0
]

var ms = MarchingSquares.new(5, 6, example)
var path = ms.identifyPerimeter()
System.print(path)
