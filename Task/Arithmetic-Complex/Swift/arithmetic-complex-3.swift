public func - (left:Complex, right:Complex) -> Complex {
    return left + -right
}

public func / (divident:Complex, divisor:Complex) -> Complex {
    let rc = divisor.conjugate
    let num = divident * rc
    let den = divisor * rc
    return Complex(real: num.real/den.real, imaginary: num.imaginary/den.real)
}
