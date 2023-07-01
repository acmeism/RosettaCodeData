function dotp(x,y) {
    function dotp_sum(a,b) { return a + b; }
    function dotp_times(a,i) { return x[i] * y[i]; }
    if (x.length != y.length)
        throw "can't find dot product: arrays have different lengths";
    return x.map(dotp_times).reduce(dotp_sum,0);
}

dotp([1,3,-5],[4,-2,-1]); // ==> 3
dotp([1,3,-5],[4,-2,-1,0]); // ==> exception
