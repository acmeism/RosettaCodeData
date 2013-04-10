function accumulator(sum) {
    return function(n) {
        return sum += n;
    }
}
var x = accumulator(1);
x(5);
document.write(accumulator(3).toString() + '<br>');
document.write(x(2.3));
