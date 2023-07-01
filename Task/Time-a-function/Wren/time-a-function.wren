import "./check" for Benchmark

Benchmark.run("a function", 100, true) {
    for (i in 0..1e7) {}
}
