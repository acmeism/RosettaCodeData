type AnyWriteableObject={write:((textToOutput:string)=>any)};

function calcPi(pipe:AnyWriteableObject) {
    let q = 1n, r=0n, t=1n, k=1n, n=3n, l=3n;
    while (true) {
        if (q * 4n + r - t < n* t) {
            pipe.write(n.toString());
            let nr = (r - n * t) * 10n;
            n  = (q * 3n + r) * 10n / t - n * 10n ;
            q  = q * 10n;
            r  = nr;
        } else {
            let nr = (q * 2n + r) * l;
            let nn = (q * k * 7n + 2n + r * l) / (t * l);
            q = q * k;
            t = t * l;
            l = l + 2n;
            k = k + 1n;
            n  = nn;
            r  = nr;
        }
    }
}

calcPi(process.stdout);
