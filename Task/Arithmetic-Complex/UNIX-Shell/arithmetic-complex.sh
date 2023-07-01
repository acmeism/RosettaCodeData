typeset -T Complex_t=(
    float real=0
    float imag=0

    function to_s {
        print -- "${_.real} + ${_.imag} i"
    }

    function dup {
        nameref other=$1
        _=( real=${other.real} imag=${other.imag} )
    }

    function add {
        typeset varname
        for varname; do
            nameref other=$varname
            (( _.real += other.real ))
            (( _.imag += other.imag ))
        done
    }

    function negate {
        (( _.real *= -1 ))
        (( _.imag *= -1 ))
    }

    function conjugate {
        (( _.imag *= -1 ))
    }

    function multiply {
        typeset varname
        for varname; do
            nameref other=$varname
            float a=${_.real} b=${_.imag} c=${other.real} d=${other.imag}
            (( _.real = a*c - b*d ))
            (( _.imag = b*c + a*d ))
        done
    }

    function inverse {
        if (( _.real == 0 && _.imag == 0 )); then
            print -u2 "division by zero"
            return 1
        fi
        float denom=$(( _.real*_.real + _.imag*_.imag ))
        (( _.real = _.real / denom ))
        (( _.imag = -1 * _.imag / denom ))
    }
)

Complex_t a=(real=1 imag=1)
a.to_s        # 1 + 1 i

Complex_t b=(real=3.14159 imag=1.2)
b.to_s        # 3.14159 + 1.2 i

Complex_t c
c.add a b
c.to_s        # 4.14159 + 2.2 i

c.negate
c.to_s        # -4.14159 + -2.2 i

c.conjugate
c.to_s        # -4.14159 + 2.2 i

c.dup a
c.multiply b
c.to_s        # 1.94159 + 4.34159 i

Complex_t d=(real=2 imag=1)
d.inverse
d.to_s        # 0.4 + -0.2 i
