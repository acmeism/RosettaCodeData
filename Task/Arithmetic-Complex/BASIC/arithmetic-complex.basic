TYPE complex
        real AS DOUBLE
        imag AS DOUBLE
END TYPE
DECLARE SUB add (a AS complex, b AS complex, c AS complex)
DECLARE SUB mult (a AS complex, b AS complex, c AS complex)
DECLARE SUB inv (a AS complex, b AS complex)
DECLARE SUB neg (a AS complex, b AS complex)
CLS
DIM x AS complex
DIM y AS complex
DIM z AS complex
x.real = 1
x.imag = 1
y.real = 2
y.imag = 2
CALL add(x, y, z)
PRINT z.real; "+"; z.imag; "i"
CALL mult(x, y, z)
PRINT z.real; "+"; z.imag; "i"
CALL inv(x, z)
PRINT z.real; "+"; z.imag; "i"
CALL neg(x, z)
PRINT z.real; "+"; z.imag; "i"


SUB add (a AS complex, b AS complex, c AS complex)
        c.real = a.real + b.real
        c.imag = a.imag + b.imag
END SUB

SUB inv (a AS complex, b AS complex)
        denom = a.real ^ 2 + a.imag ^ 2
        b.real = a.real / denom
        b.imag = -a.imag / denom
END SUB

SUB mult (a AS complex, b AS complex, c AS complex)
        c.real = a.real * b.real - a.imag * b.imag
        c.imag = a.real * b.imag + a.imag * b.real
END SUB

SUB neg (a AS complex, b AS complex)
        b.real = -a.real
        b.imag = -a.imag
END SUB
