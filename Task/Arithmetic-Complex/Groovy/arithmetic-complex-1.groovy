class Complex {
    final Number real, imag

    static final Complex i = [0,1] as Complex

    Complex(Number r, Number i = 0) { (real, imag) = [r, i] }

    Complex(Map that) { (real, imag) = [that.real ?: 0, that.imag ?: 0] }

    Complex plus (Complex c) { [real + c.real, imag + c.imag] as Complex }
    Complex plus (Number n) { [real + n, imag] as Complex }

    Complex minus (Complex c) { [real - c.real, imag - c.imag] as Complex }
    Complex minus (Number n) { [real - n, imag] as Complex }

    Complex multiply (Complex c) { [real*c.real - imag*c.imag , imag*c.real + real*c.imag] as Complex }
    Complex multiply (Number n) { [real*n , imag*n] as Complex }

    Complex div (Complex c) { this * c.recip() }
    Complex div (Number n) { this * (1/n) }

    Complex negative () { [-real, -imag] as Complex }

    /** the complex conjugate of this complex number. Overloads the bitwise complement (~) operator. */
    Complex bitwiseNegate () { [real, -imag] as Complex }

    /** the magnitude of this complex number. */
    // could also use Math.sqrt( (this * (~this)).real )
    Number getAbs() { Math.sqrt( real*real + imag*imag ) }
    /** the magnitude of this complex number. */
    Number abs() { this.abs }

    /** the reciprocal of this complex number. */
    Complex getRecip() { (~this) / (ρ**2) }
    /** the reciprocal of this complex number. */
    Complex recip() { this.recip }

    /** derived polar angle θ (theta) for polar form. Normalized to 0 ≤ θ < 2π. */
    Number getTheta() {
        def θ = Math.atan2(imag,real)
        θ = θ < 0 ? θ + 2 * Math.PI : θ
    }
    /** derived polar angle θ (theta) for polar form. Normalized to 0 ≤ θ < 2π. */
    Number getΘ() { this.theta } // this is greek uppercase theta

    /** derived polar magnitude ρ (rho) for polar form. */
    Number getRho() { this.abs }
    /** derived polar magnitude ρ (rho) for polar form. */
    Number getΡ() { this.abs } // this is greek uppercase rho, not roman P

    /** Runs Euler's polar-to-Cartesian complex conversion,
     * converting [ρ, θ] inputs into a [real, imag]-based complex number */
    static Complex fromPolar(Number ρ, Number θ) {
        [ρ * Math.cos(θ), ρ * Math.sin(θ)] as Complex
    }

    /** Creates new complex with same magnitude ρ, but different angle θ */
    Complex withTheta(Number θ) { fromPolar(this.rho, θ) }
    /** Creates new complex with same magnitude ρ, but different angle θ */
    Complex withΘ(Number θ) { fromPolar(this.rho, θ) }

    /** Creates new complex with same angle θ, but different magnitude ρ */
    Complex withRho(Number ρ) { fromPolar(ρ, this.θ) }
    /** Creates new complex with same angle θ, but different magnitude ρ */
    Complex withΡ(Number ρ) { fromPolar(ρ, this.θ) } // this is greek uppercase rho, not roman P

    static Complex exp(Complex c) { fromPolar(Math.exp(c.real), c.imag) }

    static Complex log(Complex c) { [Math.log(c.rho), c.theta] as Complex }

    Complex power(Complex c) {
        def zero = [0] as Complex
        (this == zero && c != zero)  \
                ?  zero  \
                :  c == 1  \
                        ?  this  \
                        :  exp( log(this) * c )
    }

    Complex power(Number n) { this ** ([n, 0] as Complex) }

    boolean equals(that) {
        that != null && (that instanceof Complex \
                                ? [this.real, this.imag] == [that.real, that.imag] \
                                : that instanceof Number && [this.real, this.imag] == [that, 0])
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
