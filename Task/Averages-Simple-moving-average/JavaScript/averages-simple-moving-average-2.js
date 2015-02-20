// single-sided
Array.prototype.simpleSMA=function(N) {
return this.map(function(x,i,v) {
    if(i<N-1) return NaN;
    return v.filter(function(x2,i2) { return i2<=i && i2>i-N; }).reduce(function(a,b){ return a+b; })/N;
}); };

g=[1,2,3,4,5,8,5,4];
console.log(g.simpleSMA(3))
console.log(g.simpleSMA(5))
