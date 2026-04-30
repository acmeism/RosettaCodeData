class Vector {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.length = Math.hypot(this.x, this.y);
    this.angle = Math.atan2(this.y, this.x);
  }

  add(v) {
    const sum = new Vector(this.x + v.x, this.y + v.y);
    return sum;
  }

  sub(v) {
    const diff = new Vector(this.x - v.x, this.y - v.y);
    return diff;
  }

  mul(c) {
    const scaled = new Vector(c * this.x, c * this.y);
    return scaled;
  }

  div(c) {
    const scaled = new Vector(this.x / c, this.y / c);
    return scaled;
  }

  dot(v) {
    return this.x * v.x + this.y * v.y;
  }

  print() {
    console.log(`2D vector: (${this.x}, ${this.y})`);
  }

  polar() {
    console.log(`2D vector (polar): (${this.length}, ${this.angle})`);
  }
}
