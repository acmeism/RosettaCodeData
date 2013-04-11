class Complex {
    final Number real, imag

    static final Complex I = [0,1] as Complex

    Complex(Number real) { this(real, 0) }

    Complex(real, imag) { this.real = real; this.imag = imag }

    Complex plus (Complex c) { [real + c.real, imag + c.imag] as Complex }

    Complex plus (Number n) { [real + n, imag] as Complex }

    Complex minus (Complex c) { [real - c.real, imag - c.imag] as Complex }

    Complex minus (Number n) { [real - n, imag] as Complex }

    Complex multiply (Complex c) { [real*c.real - imag*c.imag , imag*c.real + real*c.imag] as Complex }

    Complex multiply (Number n) { [real*n , imag*n] as Complex }

    Complex div (Complex c) { this * c.recip() }

    Complex div (Number n) { this * (1/n) }

    Complex negative () { [-real, -imag] as Complex }

    /** the complex conjugate of this complex number.
      * Overloads the bitwise complement (~) operator. */
    Complex bitwiseNegate () { [real, -imag] as Complex }

    /** the magnitude of this complex number. */
   // could also use Math.sqrt( (this * (~this)).real )
    Number abs () { Math.sqrt( real*real + imag*imag ) }

    /** the complex reciprocal of this complex number. */
    Complex recip() { (~this) / ((this * (~this)).real) }

    /** derived angle &#x03B8; (theta) for polar form.
      * Normalized to 0 &#x2264; &#x03B8; < 2&#x03C0;. */
    Number getTheta() {
        def theta = Math.atan2(imag,real)
        theta = theta < 0 ? theta + 2 * Math.PI : theta
    }

    /** derived magnitude &#x03C1; (rho) for polar form. */
    Number getRho() { this.abs() }

    /** Runs Euler's polar-to-Cartesian complex conversion,
      * converting [&#x03C1;, &#x03B8;] inputs into a [real, imag]-based complex number */
    static Complex fromPolar(Number rho, Number theta) {
        [rho * Math.cos(theta), rho * Math.sin(theta)] as Complex
    }

    /** Creates new complex with same magnitude &#x03C1;, but different angle &#x03B8; */
    Complex withTheta(Number theta) { fromPolar(this.rho, theta) }

    /** Creates new complex with same angle &#x03B8;, but different magnitude &#x03C1; */
    Complex withRho(Number rho) { fromPolar(rho, this.theta) }

    static Complex exp(Complex c) { fromPolar(Math.exp(c.real), c.imag) }

    static Complex log(Complex c) { [Math.log(c.rho), c.theta] as Complex }

    Complex power(Complex c) {
        this == 0 && c != 0  \
                ?  [0] as Complex  \
                :  c == 1  \
                        ?  this  \
                        :  exp( log(this) * c )
    }

    Complex power(Number n) { this ** ([n, 0] as Complex) }

    boolean equals(other) {
        other != null && (other instanceof Complex \
                                ? [real, imag] == [other.real, other.imag] \
                                : other instanceof Number && [real, imag] == [other, 0])
    }

    int hashCode() { [real, imag].hashCode() }

    String toString() {
        def realPart = "${real}"
        def imagPart = imag.abs() == 1 ? "i" : "${imag.abs()}i"
        real == 0 && imag == 0 \
                ? "0" \
                : real == 0 \
                        ? (imag > 0 ? '' : "-")  + imagPart \
                        : imag == 0 \
                                ? realPart \
                                : realPart + (imag > 0 ? " + " : " - ")  + imagPart
    }
}
