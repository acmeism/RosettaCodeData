class Uncertain {
  constructor(num, err) {
    this.num = num;
    this.err = err;
  }

  add(x) {
    try {
      const res = new Uncertain(this.num + x.num, Math.hypot(this.err, x.err));
      return res;
    } catch {
      const res = new Uncertain(this.num + x, this.err);
      return res;
    }
  }

  sub(x) {
    try {
      const res = new Uncertain(this.num - x.num, Math.hypot(this.err, x.err));
      return res;
    } catch {
      const res = new Uncertain(this.num - x, this.err);
      return res;
    }
  }

  mul(x) {
    try {
      const f = this.num * x.num;
      const sq = Math.hypot(this.err / this.num, x.err / x.num);
      const res = new Uncertain(f, f * sq);
      return res;
    } catch {
      const res = new Uncertain(this.num * x, Math.abs(this.err * x));
      return res;
    }
  }

  div(x) {
    try {
      const f = this.num / x.num;
      const sq = Math.hypot(this.err / this.num, x.err / x.num);
      const res = new Uncertain(f, f * sq);
      return res;
    } catch {
      const res = new Uncertain(this.num / x, Math.abs(this.err / x));
      return res;
    }
  }

  pow(x) {
    const f = this.num ** x;
    const res = new Uncertain(f, Math.abs(f * x * this.err / this.num));
    return res;
  }

  print() {
    console.log(`${this.num} +/- ${this.err}`);
  }
}

const x1 = new Uncertain(100, 1.1);
const y1 = new Uncertain(50, 1.2);
const x2 = new Uncertain(200, 2.2);
const y2 = new Uncertain(100, 2.3);

const d = x1.sub(x2).pow(2).add(y1.sub(y2).pow(2)).pow(0.5);
d.print();
