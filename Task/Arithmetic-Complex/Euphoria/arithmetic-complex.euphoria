constant REAL = 1, IMAG = 2
type complex(sequence s)
    return length(s) = 2 and atom(s[REAL]) and atom(s[IMAG])
end type

function add(complex a, complex b)
    return a + b
end function

function mult(complex a, complex b)
    return {a[REAL] * b[REAL] - a[IMAG] * b[IMAG],
        a[REAL] * b[IMAG] + a[IMAG] * b[REAL]}
end function

function inv(complex a)
    atom denom
    denom = a[REAL] * a[REAL] + a[IMAG] * a[IMAG]
    return {a[REAL] / denom, -a[IMAG] / denom}
end function

function neg(complex a)
    return -a
end function

function scomplex(complex a)
    sequence s
    if a[REAL] != 0 then
        s = sprintf("%g",a)
    else
        s = {}
    end if

    if a[IMAG] != 0 then
        if a[IMAG] = 1 then
            s &= "+i"
        elsif a[IMAG] = -1 then
            s &= "-i"
        else
            s &= sprintf("%+gi",a[IMAG])
        end if
    end if

    if length(s) = 0 then
        return "0"
    else
        return s
    end if
end function

complex a, b
a = { 1.0,     1.0 }
b = { 3.14159, 1.2 }
printf(1,"a = %s\n",{scomplex(a)})
printf(1,"b = %s\n",{scomplex(b)})
printf(1,"a+b = %s\n",{scomplex(add(a,b))})
printf(1,"a*b = %s\n",{scomplex(mult(a,b))})
printf(1,"1/a = %s\n",{scomplex(inv(a))})
printf(1,"-a = %s\n",{scomplex(neg(a))})
