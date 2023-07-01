      $SET SOURCEFORMAT "FREE"
class-id Prog.
method-id. Main static.
procedure division.
    declare a as type Complex = new Complex(1, 1)
    declare b as type Complex = new Complex(3.14159, 1.25)

    display "a = " a
    display "b = " b
    display space

    declare result as type Complex = a + b
    display "a + b = " result
    move (a - b) to result
    display "a - b = " result
    move (a * b) to result
    display "a * b = " result
    move (a / b) to result
    display "a / b = " result
    move (- b) to result
    display "-b = " result
    display space

    display "Inverse of b: " type Complex::Inverse(b)
    display "Conjugate of b: " type Complex::Conjugate(b)
end method.
end class.

class-id Complex.

01  Real                               float-long property.
01  Imag                               float-long property.

method-id new.
    set Real, Imag to 0
end method.

method-id new.
procedure division using value real-val as float-long, imag-val as float-long.
    set Real to real-val
    set Imag to imag-val
end method.

method-id Norm static.
procedure division using value a as type Complex returning ret as float-long.
    compute ret = a::Real ** 2 + a::Imag ** 2
end method.

method-id Inverse static.
procedure division using value a as type Complex returning ret as type Complex.
    declare norm as float-long = type Complex::Norm(a)
    set ret to new Complex(a::Real / norm, (0 - a::Imag) / norm)
end method.

method-id Conjugate static.
procedure division using value a as type Complex returning c as type Complex.
    set c to new Complex(a::Real, 0 - a::Imag)
end method.

method-id ToString override.
procedure division returning str as string.
    set str to type String::Format("{0}{1:+#0;-#}i", Real, Imag)
end method.

operator-id + .
procedure division using value a as type Complex, b as type Complex
        returning c as type Complex.
    set c to new Complex(a::Real + b::Real, a::Imag + b::Imag)
end operator.

operator-id - .
procedure division using value a as type Complex, b as type Complex
        returning c as type Complex.
    set c to new Complex(a::Real - b::Real, a::Imag - b::Imag)
end operator.

operator-id * .
procedure division using value a as type Complex, b as type Complex
        returning c as type Complex.
    set c to new Complex(a::Real * b::Real - a::Imag * b::Imag,
        a::Real * b::Imag + a::Imag * b::Real)
end operator.

operator-id / .
procedure division using value a as type Complex, b as type Complex
        returning c as type Complex.
    set c to new Complex()
    declare b-norm as float-long = type Complex::Norm(b)
    compute c::Real = (a::Real * b::Real + a::Imag * b::Imag) / b-norm
    compute c::Imag = (a::Imag * b::Real - a::Real * b::Imag) / b-norm
end operator.

operator-id - .
procedure division using value a as type Complex returning ret as type Complex.
    set ret to new Complex(- a::Real, 0 - a::Imag)
end operator.

end class.
