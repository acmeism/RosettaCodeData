var e = GA.e, cdot = GA.cdot;

for (var i = 0; i < 5; i++) {
    for (var j = 0; j < 5; j++) {
        if (i < j) {
            if (cdot(e(i), e(j))[0]) { console.log("unexpected non-nul scalar product"); }
        } else if (i === j) {
            if (!cdot(e(i), e(j))[0]) { console.log("unexpected nul scalar product"); }
        }
    }
}

function randomVector() {
    var result = [];
    for (var i = 0; i < 5; i++) { result = GA.add( result, GA.mul([Math.random()], e(i))); }
    return result;
}
function randomMultiVector() {
    var result = [];
    for (var i = 0; i < 32; i++) { result[i] = Math.random(); }
    return result;
}

var a = randomMultiVector(), b = randomMultiVector(), c = randomMultiVector();
var x = randomVector();

// (ab)c == a(bc)
console.log(GA.mul(GA.mul(a, b), c));
console.log(GA.mul(a, GA.mul(b, c)));

// a(b + c) == ab + ac
console.log(GA.mul(a, GA.add(b, c)));
console.log(GA.add(GA.mul(a,b), GA.mul(a, c)));

// (a + b)c == ac + bc
console.log(GA.mul(GA.add(a, b), c));
console.log(GA.add(GA.mul(a,c), GA.mul(b, c)));

// x² is real
console.log(GA.mul(x, x));
