function isHarshad(n) {
    var s = 0;
    var n_str = new String(n);
    for (var i = 0; i < n_str.length; ++i) {
        s += parseInt(n_str.charAt(i));
    }
    return n % s === 0;
}

var count = 0;
var harshads = [];

for (var n = 1; count < 20; ++n) {
    if (isHarshad(n)) {
        count++;
        harshads.push(n);
    }
}

console.log(harshads.join(" "));

var h = 1000;
while (!isHarshad(++h));
console.log(h);
