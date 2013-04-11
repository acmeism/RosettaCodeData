function A(k, x1, x2, x3, x4, x5) {
    function B() A(--k, B, x1, x2, x3, x4);
    return k <= 0 ? x4() + x5() : B();
}

function K(n) function() n;

alert(A(10, K(1), K(-1), K(-1), K(1), K(0)));
