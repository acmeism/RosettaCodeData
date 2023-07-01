function knuthShuffle(arr) {
    var rand, temp, i;

    for (i = arr.length - 1; i > 0; i -= 1) {
        rand = Math.floor((i + 1) * Math.random());//get random between zero and i (inclusive)
        temp = arr[rand];
        arr[rand] = arr[i]; //swap i (last element) with random element.
        arr[i] = temp;
    }
    return arr;
}

var res = {
    '1,2,3': 0, '1,3,2': 0,
    '2,1,3': 0, '2,3,1': 0,
    '3,1,2': 0, '3,2,1': 0
};

for (var i = 0; i < 100000; i++) {
    res[knuthShuffle([1,2,3]).join(',')] += 1;
}

for (var key in res) {
    print(key + "\t" + res[key]);
}
