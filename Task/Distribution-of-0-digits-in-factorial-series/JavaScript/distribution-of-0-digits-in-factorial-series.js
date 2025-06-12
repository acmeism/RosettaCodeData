function facpropzeros(N, verbose = true) {
    const proportions = [];
    for(let i = 0; i < N; i++) {
        proportions.push(0.0);
    }

    let fac = 1n;
    let psum = 0.0;

    for(let i = 0; i < N; i++) {
        fac *= BigInt(i) + 1n;
        const d = fac.toString();
        psum += d.split('').map(x => x === '0').reduce((partialSum, a) => partialSum + a, 0) / d.length;
        proportions[i] = psum / (i + 1);
    }

    if (verbose) {
        console.log(`The mean proportion of 0 in factorials from 1 to ${N} is ${psum / N}.`);
    }

    return proportions;
}


for(const n of [100, 1000, 10000]) {
    facpropzeros(n);
}

const props = facpropzeros(47500, false);

let n;

for (let i = props.length-1; i >= 0; i--) {
    if (props[i] > 0.16) {
        n = i;
        break
    }
}

console.log(`The mean proportion dips permanently below 0.16 at ${n + 2}.`);
