function checkBalance(i) {
    while (i.length % 2 == 0) {
        j = i.replace('{}','');
        if (j == i)
            break;
                i = j;
    }
    return (i?false:true);
}

var g = 10;
while (g--) {
    var N = 10 - Math.floor(g/2), n=N, o='';
    while (n || N) {
        if (N == 0 || n == 0) {
            o+=Array(++N).join('}') + Array(++n).join('{');
            break;
        }
        if (Math.round(Math.random()) == 1) {
            o+='}';
            N--;
        }
        else {
            o+='{';
            n--;
        }
    }
    alert(o+": "+checkBalance(o));
}
