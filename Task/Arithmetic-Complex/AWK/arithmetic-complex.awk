# simulate a struct using associative arrays
function complex(arr, re, im) {
    arr["re"] = re
    arr["im"] = im
}

function re(cmplx) {
    return cmplx["re"]
}

function im(cmplx) {
    return cmplx["im"]
}

function printComplex(cmplx) {
    print re(cmplx), im(cmplx)
}

function abs2(cmplx) {
    return re(cmplx) * re(cmplx) + im(cmplx) * im(cmplx)
}

function abs(cmplx) {
    return sqrt(abs2(cmplx))
}

function add(res, cmplx1, cmplx2) {
    complex(res, re(cmplx1) + re(cmplx2), im(cmplx1) + im(cmplx2))
}

function mult(res, cmplx1, cmplx2) {
    complex(res, re(cmplx1) * re(cmplx2) - im(cmplx1) * im(cmplx2), re(cmplx1) * im(cmplx2) + im(cmplx1) * re(cmplx2))
}

function scale(res, cmplx, scalar) {
    complex(res, re(cmplx) * scalar, im(cmplx) * scalar)
}

function negate(res, cmplx) {
    scale(res, cmplx, -1)
}

function conjugate(res, cmplx) {
    complex(res, re(cmplx), -im(cmplx))
}

function invert(res, cmplx) {
    conjugate(res, cmplx)
    scale(res, res, 1 / abs(cmplx))
}

BEGIN {
    complex(i, 0, 1)
    mult(i, i, i)
    printComplex(i)
}
