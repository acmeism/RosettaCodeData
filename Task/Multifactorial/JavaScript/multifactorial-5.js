function test (n, deg) {
    for (var i = 1; i <= deg; i ++) {
        var results = '';
        for (var j = 1; j <= n; j ++) {
            results += multifact(j, i) + ' ';
        }
        console.log('Degree ' + i + ': ' + results);
    }
}
