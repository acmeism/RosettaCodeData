import core.stdc.stdio: printf;

int a(int k, const lazy int x1, const lazy int x2, const lazy int x3,
      const lazy int x4, const lazy int x5) pure {
    int b() {
        k--;
        return a(k, b(), x1, x2, x3, x4);
    }
    return k <= 0 ? x4 + x5 : b();
}

void main() {
    printf("%d\n", a(10, 1, -1, -1, 1, 0));
}
