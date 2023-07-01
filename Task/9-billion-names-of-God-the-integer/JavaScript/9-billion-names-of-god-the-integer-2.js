function genTriangle(n){ // O(n^3) time and O(n^2) space
    var a = new Array(n)

    for (let i = 0; i < n; i++){
        a[i] = new Array(i+1)
        for (let j = 0; j < i; j++){
            a[i][j] = 0
            let s = i-j-1, k = Math.min(s, j)
            while (k >= 0) a[i][j] += a[s][k--]
        }
        a[i][i] = 1
    }

    return a.map(x => x.join(" ")).join("\n")
}

function G(n){ // At least O(n^2) time and O(n) space
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

console.log(genTriangle(25))
console.log("")

for (const x of [23, 123, 1234, 12345]){
    console.log("G(" + x + ") = " + G(x))
}
