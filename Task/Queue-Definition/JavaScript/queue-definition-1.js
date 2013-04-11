var fifo = [];
fifo.push(42); // Enqueue.
fifo.push(43);
var x = fifo.shift(); // Dequeue.
alert(x); // 42
