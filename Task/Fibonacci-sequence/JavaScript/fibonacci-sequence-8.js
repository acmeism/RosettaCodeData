function* fibonacciGenerator() {
    var prev = 0;
    var curr = 1;
    while (true) {
        yield curr;
        curr = curr + prev;
        prev = curr - prev;
    }
}
var fib = fibonacciGenerator();
