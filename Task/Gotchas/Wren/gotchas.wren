class Rectangle {
    construct new(width, height) {
        // Create two fields.
        _width = width
        _height = height
    }

    area {
       // Here we mis-spell _width.
       return _widht * _height
    }

    isSquare {
        // We inadvertently use '=' rather than '=='.
        // This sets _width to _height and will always return true
        // because any number (even 0) is considered 'truthy' in Wren.
        if (_width = _height) return true
        return false
    }

    diagonal {
        // We use 'sqrt' instead of the Math.sqrt method.
        // The compiler thinks this is an instance method of Rectangle
        // which will be defined later.
        return sqrt(_width * _width + _height * _height)
    }
}

var rect = Rectangle.new(80, 100)
System.print(rect.isSquare) // returns true which it isn't!
System.print(rect.area)     // runtime error: Null does not implement *(_)
System.print(rect.diagonal) // runtime error (if previous line commented out)
                            // Rectangle does not implement 'sqrt(_)'
