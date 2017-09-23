function primes(t) {
    var ps = {2:true, 3:true}
    next: for (var n=5, i=2; n<=t; n+=i, i=6-i) {
        var s = Math.sqrt( n )
        for ( var p in ps ) {
            if ( p > s ) break
            if ( n % p ) continue
            continue next
        }
        ps[n] = true
    }
    return ps
}

function factorize(f, t) {
    var cs = {}, ps = primes(t)
    for (var n=f; n<=t; n++) if (!ps[n]) cs[n] = factors(n)
    return cs
    function factors(n) {
        for ( var p in ps ) if ( n % p == 0 ) break
        var ts = {}
        ts[p] = 1
        if ( ps[n /= p] ) {
            if ( !ts[n]++ ) ts[n]=1
        }
        else {
            var fs = cs[n]
            if ( !fs ) fs = cs[n] = factors(n)
            for ( var e in fs ) ts[e] = fs[e] + (e==p)
        }
        return ts
    }
}

function pContrib(p, e) {
    for (var pc=1, n=1, i=1; i<=e; i+=1) pc+=n*=p;
    return pc
}

for (var dpa=[1,0,0], t=20000, cs=factorize(2,t), n=2; n<=t; n+=1) {
    var ds=1, fs=cs[n]
    if (fs) {
        for (var p in fs) ds *= pContrib(p, fs[p])
        ds -= n
    }
    dpa[ds<n ? 0 : ds==n ? 1 : 2]+=1
}
document.write('Deficient:',dpa[0], ', Perfect:',dpa[1], ', Abundant:',dpa[2], '<br>' )
