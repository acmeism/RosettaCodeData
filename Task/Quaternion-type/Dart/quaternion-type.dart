import 'dart:math' as math;

class Quaternion {
  final double a, b, c, d;

  Quaternion(this.a, this.b, this.c, this.d);

  Quaternion operator +(Object other) {
    if (other is Quaternion) {
      return Quaternion(a + other.a, b + other.b, c + other.c, d + other.d);
    } else if (other is double) {
      return Quaternion(a + other, b, c, d);
    }
    throw ArgumentError('Invalid type for addition: ${other.runtimeType}');
  }

  Quaternion operator *(Object other) {
    if (other is Quaternion) {
      return Quaternion(
        a * other.a - b * other.b - c * other.c - d * other.d,
        a * other.b + b * other.a + c * other.d - d * other.c,
        a * other.c - b * other.d + c * other.a + d * other.b,
        a * other.d + b * other.c - c * other.b + d * other.a,
      );
    } else if (other is double) {
      return Quaternion(a * other, b * other, c * other, d * other);
    }
    throw ArgumentError('Invalid type for multiplication: ${other.runtimeType}');
  }

  Quaternion operator -() => Quaternion(-a, -b, -c, -d);

  Quaternion conj() => Quaternion(a, -b, -c, -d);

  double norm() => math.sqrt(a * a + b * b + c * c + d * d);

  @override
  String toString() => '($a, $b, $c, $d)';
}

void main() {
  var q  = Quaternion(1.0, 2.0, 3.0, 4.0);
  var q1 = Quaternion(2.0, 3.0, 4.0, 5.0);
  var q2 = Quaternion(3.0, 4.0, 5.0, 6.0);
  var r  = 7.0;
  print("q  = $q");
  print("q1 = $q1");
  print("q2 = $q2");
  print("r  = $r\n");
  print("norm(q) = ${q.norm().toStringAsFixed(6)}");
  print("-q      = ${-q}");
  print("conj(q) = ${q.conj()}\n");
  print("r  + q  = ${q + r}");
  print("q  + r  = ${q + r}");
  print("q1 + q2 = ${q1 + q2}\n");
  print("r  * q  = ${q * r}");
  print("q  * r  = ${q * r}");
  var q3 = q1 * q2;
  var q4 = q2 * q1;
  print("q1 * q2 = $q3");
  print("q2 * q1 = $q4\n");
  print("q1 * q2 != q2 * q1 = ${q3 != q4}");
}
