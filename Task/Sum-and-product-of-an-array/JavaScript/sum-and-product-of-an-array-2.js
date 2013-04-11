var array = [1, 2, 3, 4, 5],
    sum = array.reduce(function (a, b) {
        return a + b;
    }, 0),
    prod = array.reduce(function (a, b) {
        return a * b;
    }, 1);
alert(sum + ' ' + prod);
