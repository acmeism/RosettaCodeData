function raze(a) { // like .join('') except producing an array instead of a string
    var r= [];
    for (var j= 0; j<a.length; j++)
        for (var k= 0; k<a[j].length; k++)  r.push(a[j][k]);
    return r;
}
function shuffle(y) {
    var len= y.length;
    for (var j= 0; j < len; j++) {
        var i= Math.floor(Math.random()*len);
        var t= y[i];
        y[i]= y[j];
        y[j]= t;
    }
    return y;
}
function bestShuf(txt) {
    var chs= txt.split('');
    var gr= {};
    var mx= 0;
    for (var j= 0; j<chs.length; j++) {
        var ch= chs[j];
        if (null == gr[ch])  gr[ch]= [];
        gr[ch].push(j);
        if (mx < gr[ch].length)  mx++;
    }
    var inds= [];
    for (var ch in gr)  inds.push(shuffle(gr[ch]));
    var ndx= raze(inds);
    var cycles= [];
    for (var k= 0; k < mx; k++)  cycles[k]= [];
    for (var j= 0; j<chs.length; j++)  cycles[j%mx].push(ndx[j]);
    var ref= raze(cycles);
    for (var k= 0; k < mx; k++)  cycles[k].push(cycles[k].shift());
    var prm= raze(cycles);
    var shf= [];
    for (var j= 0; j<chs.length; j++)  shf[ref[j]]= chs[prm[j]];
    return shf.join('');
}

function disp(ex) {
    var r= bestShuf(ex);
    var n= 0;
    for (var j= 0; j<ex.length; j++)
        n+= ex.substr(j, 1) == r.substr(j,1) ?1 :0;
    return ex+', '+r+', ('+n+')';
}
