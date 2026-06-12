/modular multiplication & exponentiation w/o overflow
/ the modulus, z, must be positive

modmul: {
    $[~z>0; `err@"bad modulus"; ()];
    $[y=0; :0; ()];
    a: z!x;
    b: z!y;
    bits: 2\b;
    z! +/ bits * |(-1+#bits) {a: y+y; $[a < x; a; a-x]}[z]\ a}

modexp: {
    $[~z>0; `err@"bad modulus"; ()];
    $[y=0; :0; ()];
    a: z!x;
    b: z!y;
    bits: 2\b;
    modmul[;;z]/ (|(-1+#bits) {modmul[y;y;x]}[z]\ a)[&bits]}

/ Miller-Rabin Primality Test

p64: `pri 64
bases: {$[x<4759123141; 2 7 61; 2 325 9375 28178 450775 9780504 1795265022]}
prime: {$[x<64; :~^p64?x; &/p64!'x; $[x<4489; 1; &/sfp[x]' bases x]; 0]}
sfp: {[n;a];
    (d;s): {0=2!*x} ({(-2!x), y+1}.)/ (n-1), 0
    t: modexp[a; d; n]
    $[t=1; 1; |/(n-1) = (s-1) {modmul[y;y;x]}[n]\ t]}
