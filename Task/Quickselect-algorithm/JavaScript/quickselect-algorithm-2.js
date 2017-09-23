var array = [9, 8, 7, 6, 5, 0, 1, 2, 3, 4],
    ks = Array.apply(null, {length: 10}).map(Number.call, Number);
ks.map(k => { KthElement.find(array, k) });
