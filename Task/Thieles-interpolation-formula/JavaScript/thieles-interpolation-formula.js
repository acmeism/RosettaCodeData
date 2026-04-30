const N = 32;
const N2 = (N * (N - 1) / 2);
const STEP = 0.05;
let xval = new Array(N);
let t_sin = new Array(N);
let t_cos = new Array(N);
let t_tan = new Array(N);
let r_sin = new Array(N2);
let r_cos = new Array(N2);
let r_tan = new Array(N2);

function rho(x, y, r, i, n) {
    if (n < 0) return 0;
    if (n === 0) return y[i];
    const idx = (N - 1 - n) * (N - n) / 2 + i;
    if (isNaN(r[idx])) {
        r[idx] = (x[i] - x[i + n]) / (rho(x, y, r, i, n - 1) - rho(x, y, r, i + 1, n - 1))
               + rho(x, y, r, i + 1, n - 2);
    }
    return r[idx];
}

function thiele(x, y, r, xin, n) {
    if (n > N - 1) return 1;
    return rho(x, y, r, 0, n) - rho(x, y, r, 0, n - 2)
           + (xin - x[n]) / thiele(x, y, r, xin, n + 1);
}

function main() {
    for (let i = 0; i < N; i++) {
        xval[i] = i * STEP;
        t_sin[i] = Math.sin(xval[i]);
        t_cos[i] = Math.cos(xval[i]);
        t_tan[i] = t_sin[i] / t_cos[i];
    }
    for (let i = 0; i < N2; i++) {
        r_sin[i] = r_cos[i] = r_tan[i] = NaN;
    }
    console.log((6 * thiele(t_sin, xval, r_sin, 0.5, 0)).toFixed(14));
    console.log((3 * thiele(t_cos, xval, r_cos, 0.5, 0)).toFixed(14));
    console.log((4 * thiele(t_tan, xval, r_tan, 1.0, 0)).toFixed(14));
}

main();
