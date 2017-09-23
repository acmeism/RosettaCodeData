function isNarc(x) {
    var str = x.toString(),
        i,
        sum = 0,
        l = str.length;
    if (x < 0) {
        return false;
    } else {
        for (i = 0; i < l; i++) {
            sum += Math.pow(str.charAt(i), l);
        }
    }
    return sum == x;
}
function main(){
    var n = [];
    for (var x = 0, count = 0; count < 25; x++){
        if (isNarc(x)){
            n.push(x);
            count++;
        }
    }
    return n.join(' ');
}
