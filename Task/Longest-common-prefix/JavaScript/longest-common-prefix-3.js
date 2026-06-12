// Zip arbitrary number of lists (a functional implementation, this time)
// Accepts arrays or strings, and returns [[a]]
function zip() {
    var args = [].slice.call(arguments),
        lngMin = args.reduce(function (a, x) {
            var n = x.length;
            return n < a ? n : a;
        }, Infinity);

    if (lngMin) {
        return args.reduce(function (a, v) {
            return (
                typeof v === 'string' ? v.split('') : v
            ).slice(0, lngMin).map(a ? function (x, i) {
                return a[i].concat(x);
            } : function (x) {
                return [x];
            });
        }, null)
    } else return [];
}
