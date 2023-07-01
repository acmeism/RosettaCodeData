int gcd(int u, int v) {
return (v != 0)?gcd(v, u%v):u;
}
