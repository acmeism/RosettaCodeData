var mandelIter;
fetch("./mandelIter.wasm")
    .then(res => {
        if (res.ok) return res.arrayBuffer();
        throw new Error('Unable to fetch WASM.');
    })
    .then(bytes => { return WebAssembly.compile(bytes); })
    .then(module => { return WebAssembly.instantiate(module); })
    .then(instance => { WebAssembly.instance = instance; draw(); })

function mandelbrot(canvas, xmin, xmax, ymin, ymax, iterations) {
    // ...
    var i = WebAssembly.instance.exports.mandelIter(x, y, iterations);
    // ...
}

function draw() {
    // canvas initialization if necessary
    // ...
    mandelbrot(canvas, -2, 1, -1, 1, 1000);
    // ...
}
