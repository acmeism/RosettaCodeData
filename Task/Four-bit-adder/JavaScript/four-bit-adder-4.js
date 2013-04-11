// run this in your browsers console
var outer = inner = 16, a, b;

while(outer--) {
    a = (8|outer).toString(2);
    while(inner--) {
        b = (8|inner).toString(2);
        console.log(a + ' + ' + b + ' = ' + fourBitAdder(a, b));
    }
    inner = outer;
}
