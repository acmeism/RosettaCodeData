function worker() {
    const buf = new Int32Array(new WebAssembly.Memory({ initial: 1, maximum: 1, shared: true }).buffer)
    function sleep(ms) {
        Atomics.wait(buf, 0, 0, ms)
    }

    for (let i = 10; i > 0; --i) {
        console.log(i)
        sleep(1000)
    }
    console.log('Blast off!')
}

new Worker(URL.createObjectURL(new Blob([`(${worker})()`])))
