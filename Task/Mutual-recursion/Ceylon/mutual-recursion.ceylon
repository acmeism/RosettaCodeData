Integer f(Integer n)
    =>  if (n > 0)
        then n - m(f(n-1))
        else 1;

Integer m(Integer n)
    =>  if (n > 0)
        then n - f(m(n-1))
        else 0;

shared void run() {
    printAll((0:20).map(f));
    printAll((0:20).map(m));
}
