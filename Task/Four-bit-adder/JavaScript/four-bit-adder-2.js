// basic building blocks allowed by the rules are ~, &, and |, we'll fake these
// in a way that makes what they do (at least when you use them) more obvious
// than the other available options do.

function not(a) {
    if (arePseudoBin(a))
        return a == 1 ? 0 : 1;
}

function and(a, b) {
    if (arePseudoBin(a, b))
        return a + b < 2 ? 0 : 1;
}

function nand(a, b) {
    if (arePseudoBin(a, b))
        return not(and(a, b));
}

function or(a, b) {
    if (arePseudoBin(a, b))
        return nand(nand(a,a), nand(b,b));
}

function xor(a, b) {
    if (arePseudoBin(a, b))
        return nand(nand(nand(a,b), a), nand(nand(a,b), b));
}

function halfAdder(a, b) {
    if (arePseudoBin(a, b))
        return { carry: and(a, b), sum: xor(a, b) };
}

function fullAdder(a, b, c) {
    if (arePseudoBin(a, b, c)) {
        var h0 = halfAdder(a, b),
            h1 = halfAdder(h0.sum, c);
        return {carry: or(h0.carry, h1.carry), sum: h1.sum };
    }
}

function fourBitAdder(a, b) {
    if (typeof a.length == 'undefined' || typeof b.length == 'undefined')
        throw new Error('bad values');
    // not sure if the rules allow this, but we need to pad the values
    // if they're too short and trim them if they're too long
    var inA = Array(4),
        inB = Array(4),
        out = Array(4),
        i = 4,
        pass;

    while (i--) {
        inA[i] = a[i] != 1 ? 0 : 1;
        inB[i] = b[i] != 1 ? 0 : 1;
    }

    // now we can start adding... I'd prefer to do this in a loop,
    // but that wouldn't be "connecting the other 'constructive blocks',
    // in turn made of 'simpler' and 'smaller' ones"

    pass = halfAdder(inA[3], inB[3]);
    out[3] = pass.sum;
    pass = fullAdder(inA[2], inB[2], pass.carry);
    out[2] = pass.sum;
    pass = fullAdder(inA[1], inB[1], pass.carry);
    out[1] = pass.sum;
    pass = fullAdder(inA[0], inB[0], pass.carry);
    out[0] = pass.sum;
    return out.join('');
}
