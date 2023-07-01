var onmessage = function(event) {
    postMessage({"n" : event.data.n,
                 "factors" : factor(event.data.n),
                 "id" : event.data.id});
};

function factor(n) {
    var factors = [];
    for(p = 2; p <= n; p++) {
        if((n % p) == 0) {
            factors[factors.length] = p;
            n /= p;
        }
    }
    return factors;
}
