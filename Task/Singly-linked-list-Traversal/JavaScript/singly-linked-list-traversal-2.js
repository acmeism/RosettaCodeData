var map = function (fn, list) {
        return list.map(fn);
    },

    foldr = function (fn, acc, list) {
        var listr = list.slice();
        listr.reverse();

        return listr.reduce(fn, acc);
    },

    traverse = function (list, fn) {
        return list.forEach(fn);
    };

var range = function (m, n) {
    return Array.apply(null, Array(n - m + 1)).map(
        function (x, i) {
            return m + i;
        }
    );
};

//      --> [false, false, false, false, false, true, true, true, true, true]
map(function (x) {
    return x > 5;
}, range(1, 10));

//      --> ["Apples", "Oranges", "Mangos", "Pears"]
map(function (x) {
    return x + 's';
}, ["Apple", "Orange", "Mango", "Pear"])

//      --> 55
foldr(function (acc, x) {
    return acc + x;
}, 0, range(1, 10))


traverse(["Apple", "Orange", "Mango", "Pear"], function (x) {
    console.log(x);
})
/* Apple */
/* Orange */
/* Mango */
/* Pear */
