import "./complex" for Complex

var dft = Fn.new { |x|
    var N = x.count
    var y = List.filled(N, null)
    for (k in 0...N) {
        y[k] = Complex.zero
        for (n in 0...N) {
            var t = Complex.imagMinusOne * Complex.two * Complex.pi * k * n / N
            y[k] = y[k] + x[n] * t.exp
        }
    }
    return y
}

var idft = Fn.new { |y|
    var N = y.count
    var x = List.filled(N, null)
    for (n in 0...N) {
        x[n] = Complex.zero
        for (k in 0...N) {
            var t = Complex.imagOne * Complex.two * Complex.pi * k * n / N
            x[n] = x[n] +  y[k] * t.exp
        }
        x[n] = x[n] / N
        // clean x[n] to remove very small imaginary values
        if (x[n].imag.abs < 1e-14) x[n] = Complex.new(x[n].real, 0)
    }
    return x
}

var x = [2, 3, 5, 7, 11]
System.print("Original sequence: %(x)")
for (i in 0...x.count) x[i] = Complex.new(x[i])
var y = dft.call(x)
Complex.showAsReal = true // don't display the imaginary part if it's 0
System.print("\nAfter applying the Discrete Fourier Transform:")
System.print(y)
System.print("\nAfter applying the Inverse Discrete Fourier Transform to the above transform:")
System.print(idft.call(y))
