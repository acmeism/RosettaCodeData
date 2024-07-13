class Complex {
  double _r, _i;

  Complex(this._r, this._i);
  get r => _r;
  get i => _i;
  toString() => "($r,$i)";

  operator +(Complex other) => Complex(r + other.r, i + other.i);
  operator *(Complex other) =>
      Complex(r * other.r - i * other.i, r * other.i + other.r * i);
  abs() => r * r + i * i;
}

void main() {
  const startX = -1.5;
  const startY = -1.0;
  const stepX = 0.03;
  const stepY = 0.1;

  for (int y = 0; y < 20; y++) {
    String line = "";
    for (int x = 0; x < 70; x++) {
      var c = Complex(startX + stepX * x, startY + stepY * y);
      var z = Complex(0.0, 0.0);
      for (int i = 0; i < 100; i++) {
        z = z * z + c;
        if (z.abs() > 2) {
          break;
        }
      }
      line += z.abs() > 2 ? " " : "*";
    }
    print(line);
  }
}
