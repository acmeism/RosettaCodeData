public struct Complex {

    public let real : Double
    public let imaginary : Double

    public init(real inReal:Double, imaginary inImaginary:Double) {
        real = inReal
        imaginary = inImaginary
    }

    public static var i : Complex = Complex(real:0, imaginary: 1)
    public static var zero : Complex = Complex(real: 0, imaginary: 0)

    public var negate : Complex {
        return Complex(real: -real, imaginary: -imaginary)
    }

    public var invert : Complex {
        let d = (real*real + imaginary*imaginary)
        return Complex(real: real/d, imaginary: -imaginary/d)
    }

    public var conjugate : Complex {
        return Complex(real: real, imaginary: -imaginary)
    }

}
public func + (left: Complex, right: Complex) -> Complex {

    return Complex(real: left.real+right.real, imaginary: left.imaginary+right.imaginary)
}
public func * (left: Complex, right: Complex) -> Complex {

    return Complex(real: left.real*right.real - left.imaginary*right.imaginary,
        imaginary: left.real*right.imaginary+left.imaginary*right.real)
}
public prefix func - (right:Complex) -> Complex {
    return right.negate
}

// Checking equality is almost necessary for a struct of this type  to be useful
extension Complex : Equatable {}
public func == (left:Complex, right:Complex) -> Bool {
    return left.real == right.real && left.imaginary == right.imaginary
}
