int gray_encode(int n) {
    return n ^ (n >> 1);
}

int gray_decode(int n) {
    int p = n;
    while (n >>= 1) p ^= n;
    return p;
}
