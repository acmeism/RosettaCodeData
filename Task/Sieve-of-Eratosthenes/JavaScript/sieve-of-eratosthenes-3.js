var SoEIncClass = (function () {
    function SoEIncClass() {
        this.n = 0;
    }
    SoEIncClass.prototype.next = function () {
        this.n += 2;
        if (this.n < 7) { // initialization of sequence to avoid runaway:
            if (this.n < 3) { // only even of two:
                this.n = 1; // odds from here...
                return 2;
            }
            if (this.n < 5)
                return 3;
            this.dict = {}; // n must be 5...
            this.bps = new SoEIncClass(); // new source of base primes
            this.bps.next(); // advance past the even prime of two...
            this.p = this.bps.next(); // first odd prime (3 in this case)
            this.q = this.p * this.p; // set guard
            return 5;
        } else { // past initialization:
            var s = this.dict[this.n]; // may or may not be defined...
            if (!s) { // not defined:
                if (this.n < this.q) // haven't reached the guard:
                    return this.n; // found a prime
                else { // n === q => not prime but at guard, so:
                    var p2 = this.p << 1; // the span odds-only is twice prime
                    this.dict[this.n + p2] = p2; // add next composite of prime to dict
                    this.p = this.bps.next();
                    this.q = this.p * this.p; // get next base prime guard
                    return this.next(); // not prime so advance...
                }
            } else { // is a found composite of previous base prime => not prime
                delete this.dict[this.n]; // advance to next composite of this prime:
                var nxt = this.n + s;
                while (this.dict[nxt]) nxt += s; // find unique empty slot in dict
                this.dict[nxt] = s; // to put the next composite for this base prime
                return this.next(); // not prime so advance...
            }
        }
    };
    return SoEIncClass;
})();
