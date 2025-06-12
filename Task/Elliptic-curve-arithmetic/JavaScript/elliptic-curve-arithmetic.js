class Pt {
  static bCoeff = 7;

  constructor(x, y) {
    this.x = x;
    this.y = y;
  }

  static zero() {
    return new Pt(Number.POSITIVE_INFINITY, Number.POSITIVE_INFINITY);
  }

  isZero() {
    // same threshold logic as Java version
    return this.x > 1e20 || this.x < -1e20;
  }

  static fromY(y) {
    // cbrt(pow(y,2) - bCoeff)
    return new Pt(Math.cbrt(Math.pow(y, 2) - Pt.bCoeff), y);
  }

  dbl() {
    if (this.isZero()) {
      return this;
    }
    const L = (3 * this.x * this.x) / (2 * this.y);
    const x2 = Math.pow(L, 2) - 2 * this.x;
    const y2 = L * (this.x - x2) - this.y;
    return new Pt(x2, y2);
  }

  neg() {
    return new Pt(this.x, -this.y);
  }

  plus(q) {
    // point doubling?
    if (this.x === q.x && this.y === q.y) {
      return this.dbl();
    }
    // handle "point at infinity"
    if (this.isZero()) {
      return q;
    }
    if (q.isZero()) {
      return this;
    }
    const L = (q.y - this.y) / (q.x - this.x);
    const xx = Math.pow(L, 2) - this.x - q.x;
    const yy = L * (this.x - xx) - this.y;
    return new Pt(xx, yy);
  }

  mult(n) {
    let r = Pt.zero();
    let p = this;
    // binary double-and-add
    for (let i = 1; i <= n; i <<= 1) {
      if (i & n) {
        r = r.plus(p);
      }
      p = p.dbl();
    }
    return r;
  }

  toString() {
    if (this.isZero()) {
      return "Zero";
    }
    // format with 3 decimal places, dot as decimal separator
    return `(${this.x.toFixed(3)},${this.y.toFixed(3)})`;
  }
}

// Equivalent of the Java `main` method
(function main() {
  const a = Pt.fromY(1);
  const b = Pt.fromY(2);
  console.log(`a = ${a}`);
  console.log(`b = ${b}`);
  const c = a.plus(b);
  console.log(`c = a + b = ${c}`);
  const d = c.neg();
  console.log(`d = -c = ${d}`);
  console.log(`c + d = ${c.plus(d)}`);
  console.log(`a + b + d = ${a.plus(b).plus(d)}`);
  console.log(`a * 12345 = ${a.mult(12345)}`);
})();
