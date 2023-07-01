function p(n){
    var a = new Array(n+1)
    a[0] = 1n

    for (let i = 1; i <= n; i++){
        a[i] = 0n
        for (let k = 1, s = 1; s <= i;){
            a[i] += (k & 1 ? a[i-s]:-a[i-s])
            k > 0 ? (s += k, k = -k):(k = -k+1, s = k*(3*k-1)/2)
        }
    }

    return a[n]
}

var t = Date.now()
console.log("p(6666) = " + p(6666))
console.log("Computation time in ms: ", Date.now() - t)
