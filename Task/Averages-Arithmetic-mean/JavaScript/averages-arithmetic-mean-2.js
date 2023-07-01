function mean(array) {
    var sum = 0;
    array.forEach(function(value){
        sum += value;
        });
    return array.length ? sum / array.length : 0;
    }

alert( mean( [1,2,3,4,5] ) );   // 3
