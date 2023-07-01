function isPrime(n){
    var x = Math.floor(Math.sqrt(n)), i = 2

    while ((i <= x) && (n % i != 0)) i++

    return (x < i)
}

function smooth(n, s, k){
    var p = []
    for (let i = 2; i <= n; i++){
        if (isPrime(i)){
            p.push([BigInt(i), [1n], 0])
        }
    }

    var res = []
    for (let i = 0; i < s + k; i++){
        var m = p[0][1][p[0][2]]

        for (let j = 1; j < p.length; j++){
            if (p[j][1][p[j][2]] < m) m = p[j][1][p[j][2]]
        }

        for (let j = 0; j < p.length; j++){
            p[j][1].push(p[j][0]*m)
            if (p[j][1][p[j][2]] == m) p[j][2]++
        }

        res.push(m)
    }

    return res.slice(s-1, s-1+k);
}

// main

var sOut = ""

for (let x of [[2, 29, 1, 25], [3, 29, 3000, 3], [503, 521, 30000, 20]]){
    for (let n = x[0]; n <= x[1]; n++){
        if (isPrime(n)){
            sOut += x[2] + " to " + (x[2] - 1 + x[3]) + " " + n + "-smooth numbers: " + smooth(n, x[2], x[3]) + "\n"
        }
    }
}

console.log(sOut)
