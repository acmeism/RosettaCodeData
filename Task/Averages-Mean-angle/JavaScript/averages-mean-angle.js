function sum(a) {
    s = 0;
    for (var i in a) s += a[i];
    return s;
}

function degToRad(a) {
    return Math.PI/180*a;
}

function meanAngleDeg(a) {
    return 180/Math.PI*Math.atan2(sum(a.map(degToRad).map(Math.sin))/a.length,sum(a.map(degToRad).map(Math.cos))/a.length);
}

var a = [350, 10], b = [90, 180, 270, 360],  c =[10, 20, 30];
console.log(meanAngleDeg(a));
console.log(meanAngleDeg(b));
console.log(meanAngleDeg(c));
