function hamming() {
    var queues = {2: [], 3: [], 5: []};
    var base;
    var next_ham = 1;
    while (true) {
        yield next_ham;

        for (base in queues) {queues[base].push(next_ham * base)}

        next_ham = [ queue[0] for each (queue in queues) ].reduce(function(min, val) {
            return Math.min(min,val)
        });

        for (base in queues) {if (queues[base][0] == next_ham) queues[base].shift()}
    }
}

var ham = hamming();
var first20=[], i=1;

for (; i <= 20; i++)
    first20.push(ham.next());
print(first20.join(', '));
print('...');
for (; i <= 1690; i++)
    ham.next();
print(i + " => " + ham.next());
