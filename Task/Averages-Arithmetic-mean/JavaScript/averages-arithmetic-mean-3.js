function mean(array) {
    return !array.length ? 0
        : array.reduce(function(pre, cur, i) {
            return (pre * i + cur) / (i + 1);
            });
    }

alert( mean( [1,2,3,4,5] ) );   // 3
alert( mean( [] ) );            // 0
