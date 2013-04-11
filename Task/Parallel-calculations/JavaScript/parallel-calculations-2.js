var numbers = [12757923, 12878611, 12757923, 15808973, 15780709, 197622519];
var workers = [];
var worker_count = 0;

var results = [];

for(var i = 0; i < numbers.length; i++) {
    worker_count++;
    workers[i] = new Worker("parallel_worker.js");
    workers[i].onmessage = accumulate;
    workers[i].postMessage({n: numbers[i], id: i});
}

function accumulate(event) {
    n = event.data.n;
    factors = event.data.factors;
    id = event.data.id;
    console.log(n + " : " + factors);
    results[id] = {n:n, factors:factors};
    // Cleanup - kill the worker and countdown until all work is done
    workers[id].terminate();
    worker_count--;
    if(worker_count == 0)
	reduce();
}

function reduce() {
    answer = 0;
    for(i = 1; i < results.length; i++) {
	min = results[i].factors[0];
	largest_min = results[answer].factors[0];
	if(min > largest_min)
	    answer = i;
    }
    n = results[answer].n;
    factors = results[answer].factors;
    console.log("The number with the relatively largest factors is: " + n + " : " + factors);
}
