// generator with the do while loop
function* getValue(stop) {
    var i = 0;
    do {
        yield ++i;
    } while (i % stop != 0);
}

// function to print the value and invoke next
function printVal(g, v) {
    if (!v.done) {
        console.log(v.value);
        setImmediate(printVal, g, g.next());
    }
}

(() => {
    var gen = getValue(6);
    printVal(gen, gen.next());
})();
