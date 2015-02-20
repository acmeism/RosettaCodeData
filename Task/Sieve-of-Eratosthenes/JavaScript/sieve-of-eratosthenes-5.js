var SoEPgClass = (function () {
    function SoEPgClass() {
        this.bi = -1; // constructor resets the enumeration to start...
    }
    SoEPgClass.prototype.next = function () {
        if (this.bi < 1) {
            if (this.bi < 0) {
                this.bi++;
                this.lowi = 0; // other initialization done here...
                this.bpa = [];
                return 2;
            } else { // bi must be zero:
                var nxt = 3 + (this.lowi << 1) + 262144;
                this.buf = new Array();
                for (var i = 0; i < 4096; i++) // faster initialization:
                    this.buf.push(0);
                if (this.lowi <= 0) { // special culling for first page as no base primes yet:
                    for (var i = 0, p = 3, sqr = 9; sqr < nxt; i++, p += 2, sqr = p * p)
                        if ((this.buf[i >> 5] & (1 << (i & 31))) === 0)
                            for (var j = (sqr - 3) >> 1; j < 131072; j += p)
                                this.buf[j >> 5] |= 1 << (j & 31);
                } else { // after the first page:
                    if (!this.bpa.length) { // if this is the first page after the zero one:
                        this.bps = new SoEPgClass(); // initialize separate base primes stream:
                        this.bps.next(); // advance past the only even prime of two
                        this.bpa.push(this.bps.next()); // get the next prime (3 in this case)
                    }
                    // get enough base primes for the page range...
                    for (var p = this.bpa[this.bpa.length - 1], sqr = p * p; sqr < nxt;
                            p = this.bps.next(), this.bpa.push(p), sqr = p * p) ;
                    for (var i = 0; i < this.bpa.length; i++) {
                        var p = this.bpa[i];
                        var s = (p * p - 3) >> 1;
                        if (s >= this.lowi) // adjust start index based on page lower limit...
                            s -= this.lowi;
                        else {
                            var r = (this.lowi - s) % p;
                            s = (r != 0) ? p - r : 0;
                        }
                        for (var j = s; j < 131072; j += p)
                            this.buf[j >> 5] |= 1 << (j & 31);
                    }
                }
            }
        }
        while (this.bi < 131072 && this.buf[this.bi >> 5] & (1 << (this.bi & 31)))
            this.bi++; // find next marker still with prime status
        if (this.bi < 131072) // within buffer: output computed prime
            return 3 + ((this.lowi + this.bi++) << 1);
        else { // beyond buffer range: advance buffer
            this.bi = 0;
            this.lowi += 131072;
            return this.next(); // and recursively loop
        }
    };
    return SoEPgClass;
})();
