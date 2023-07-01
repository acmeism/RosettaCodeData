#define EPS 1.0e-20

type polyterm
    degree as uinteger
    coeff as double
end type

sub poly_print( P() as double )
    dim as string outstr = "", sri
    for i as integer = ubound(P) to 0 step -1
        if outstr<>"" then
            if P(i)>0 then outstr = outstr + " + "
            if P(i)<0 then outstr = outstr + " - "
        end if
        if P(i)=0 then continue for
        if abs(P(i))<>1 or i=0 then
            if outstr="" then
                outstr = outstr + str((P(i)))
            else
                outstr = outstr + str(abs(P(i)))
            end if
        end if
        if i>0 then outstr=outstr+"x"
        sri= str(i)
        if i>1 then outstr=outstr + "^" + sri
    next i
    print outstr
end sub

function lc_deg( B() as double ) as polyterm
    'gets the coefficent and degree of the leading term in a polynomial
    dim as polyterm ret
    for i as uinteger = ubound(B) to 0 step -1
        if B(i)<>0 then
            ret.degree = i
            ret.coeff = B(i)
            return ret
        end if
    next i
    return ret
end function

sub poly_multiply( byval k as polyterm, P() as double )
    'in-place multiplication of polynomial by a polynomial term
    dim i as integer
    for i = ubound(P) to k.degree step -1
        P(i) = k.coeff*P(i-k.degree)
    next i
    for i = k.degree-1 to 0 step -1
        P(i)=0
    next i
end sub

sub poly_subtract( P() as double, Q() as double )
    'in place subtraction of one polynomial from another
    dim as uinteger deg = ubound(P)
    for i as uinteger = 0 to deg
        P(i) -= Q(i)
        if abs(P(i))<EPS then P(i)=0   'stupid floating point subtraction, grumble grumble
    next i
end sub

sub poly_add( P() as double, byval t as polyterm )
    'in-place addition of a polynomial term to a polynomial
    P(t.degree) += t.coeff
end sub

sub poly_copy( source() as double, target() as double )
    for i as uinteger = 0 to ubound(source)
        target(i) = source(i)
    next i
end sub

sub polydiv( A() as double, B() as double, Q() as double, R() as double )
    dim as polyterm s
    dim as double sB(0 to ubound(B))
    poly_copy A(), R()
    dim as uinteger d = ubound(B), degr = lc_deg(R()).degree
    dim as double c = lc_deg(B()).coeff
    while degr >= d
        s.coeff = lc_deg(R()).coeff/c
        s.degree = degr - d
        poly_add Q(), s
        poly_copy B(), sB()
        redim preserve sB(0 to s.degree+ubound(sB)) as double
        poly_multiply s, sB()
        poly_subtract R(), sB()
        degr = lc_deg(R()).degree
        redim sB(0 to ubound(B))
    wend
end sub

dim as double N(0 to 4) = {-42, 0, -12, 1}    'x^3 - 12x^2 - 42
dim as double D(0 to 2) = {-3, 1}             '        x   -  3
dim as double Q(0 to ubound(N)), R(0 to ubound(N))

polydiv( N(), D(), Q(), R() )

poly_print Q()   'quotient
poly_print R()   'remainder
