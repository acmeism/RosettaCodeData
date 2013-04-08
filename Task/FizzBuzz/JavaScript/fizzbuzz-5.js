var divs = [15, 3, 5];
var says = ['FizzBuzz', 'Fizz', 'Buzz'];

function fizzBuzz(first, last) {
    for (var n = first; n <= last; n++) {
        print(getFizzBuzz(n));
    }
}

function getFizzBuzz(n) {
    var sayWhat = n;
    for (var d = 0; d < divs.length; d++) {
        if (isMultOf(n, divs[d])) {
            sayWhat = says[d];
            break;
        }
    }
    return sayWhat;
}

function isMultOf(n, d) {
    return n % d == 0;
}

fizzBuzz(1, 100);
