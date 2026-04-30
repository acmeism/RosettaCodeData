class ShortestCommonSuperSequence {
    static isEmpty(s) {
        return s == null || s.length === 0;
    }
    static scs(x, y) {
        if (this.isEmpty(x)) {
            return y;
        }
        if (this.isEmpty(y)) {
            return x;
        }
        if (x[0] === y[0]) {
            return x[0] + this.scs(x.slice(1), y.slice(1));
        }
        if (this.scs(x, y.slice(1)).length <= this.scs(x.slice(1), y).length) {
            return y[0] + this.scs(x, y.slice(1));
        } else {
            return x[0] + this.scs(x.slice(1), y);
        }
    }
    static main(args) {
        console.log(this.scs("abcbdab", "bdcaba"));
    }
}
ShortestCommonSuperSequence.main();
