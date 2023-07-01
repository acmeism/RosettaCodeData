'use strict';

function sum(array) {
    return array.reduce(function (a, b) {
        return a + b;
    });
}

function square(x) {
    return x * x;
}

function mean(array) {
    return sum(array) / array.length;
}

function averageSquareDiff(a, predictions) {
    return mean(predictions.map(function (x) {
        return square(x - a);
    }));
}

function diversityTheorem(truth, predictions) {
    var average = mean(predictions);
    return {
        'average-error': averageSquareDiff(truth, predictions),
        'crowd-error': square(truth - average),
        'diversity': averageSquareDiff(average, predictions)
    };
}

console.log(diversityTheorem(49, [48,47,51]))
console.log(diversityTheorem(49, [48,47,51,42]))
