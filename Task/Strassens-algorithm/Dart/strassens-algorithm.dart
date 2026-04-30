// -----------------------------------------------------------------------------
//  matrix.dart
//  Dart translation of the C++ Matrix/Strassen example
// -----------------------------------------------------------------------------
import 'dart:math' as math;

/// Simple matrix class that supports normal multiplication, Strassen
/// multiplication and pretty printing with a given precision.
class Matrix {
  final List<List<double>> data;
  final int rows;
  final int cols;

  // ---------------------------------------------------------------------------
  //  Construction & basic getters
  // ---------------------------------------------------------------------------
  Matrix(this.data)
      : rows = data.length,
        cols = data.isNotEmpty ? data[0].length : 0 {
    // Ensure rectangular shape
    for (final row in data) {
      if (row.length != cols) {
        throw ArgumentError('All rows must have the same number of columns.');
      }
    }
  }

  // ---------------------------------------------------------------------------
  //  Validation helpers (private)
  // ---------------------------------------------------------------------------
  void _validateDimensions(Matrix other) {
    if (rows != other.rows || cols != other.cols) {
      throw StateError('Matrices must have the same dimensions.');
    }
  }

  void _validateMultiplication(Matrix other) {
    if (cols != other.rows) {
      throw StateError('Cannot multiply these matrices (inner dimensions differ).');
    }
  }

  void _validateSquarePowerOfTwo() {
    if (rows != cols) {
      throw StateError('Matrix must be square.');
    }
    if (rows == 0 || (rows & (rows - 1)) != 0) {
      throw StateError('Size of matrix must be a power of two.');
    }
  }

  // ---------------------------------------------------------------------------
  //  Basic arithmetic operators
  // ---------------------------------------------------------------------------
  Matrix operator +(Matrix other) {
    _validateDimensions(other);
    final result = List<List<double>>.generate(
        rows,
        (i) => List<double>.generate(
            cols, (j) => data[i][j] + other.data[i][j],
            growable: false),
        growable: false);
    return Matrix(result);
  }

  Matrix operator -(Matrix other) {
    _validateDimensions(other);
    final result = List<List<double>>.generate(
        rows,
        (i) => List<double>.generate(
            cols, (j) => data[i][j] - other.data[i][j],
            growable: false),
        growable: false);
    return Matrix(result);
  }

  Matrix operator *(Matrix other) {
    _validateMultiplication(other);
    final result = List<List<double>>.generate(
        rows,
        (i) => List<double>.filled(other.cols, 0.0, growable: false),
        growable: false);

    for (var i = 0; i < rows; ++i) {
      for (var j = 0; j < other.cols; ++j) {
        double sum = 0.0;
        for (var k = 0; k < cols; ++k) {
          sum += data[i][k] * other.data[k][j];
        }
        result[i][j] = sum;
      }
    }
    return Matrix(result);
  }

  // ---------------------------------------------------------------------------
  //  Pretty printing
  // ---------------------------------------------------------------------------
  @override
  String toString() {
    final sb = StringBuffer();
    for (final row in data) {
      sb.writeln('[${row.join(', ')}]');
    }
    return sb.toString();
  }

  /// Returns a string where each element is rounded to **[prec]** decimal
  /// places (like the C++ `toStringWithPrecision`).  The handling of “‑0”
  /// → “0” mirrors the original implementation.
  String toStringWithPrecision(int prec) {
    final pow = math.pow(10.0, prec);
    final sb = StringBuffer();

    for (final row in data) {
      sb.write('[');
      for (var i = 0; i < row.length; ++i) {
        // Round to the requested precision
        var r = (row[i] * pow).round() / pow;
        // Remove the negative zero representation
        if (r == -0.0) r = 0.0;
        final formatted = r.toStringAsFixed(prec);
        sb.write(formatted);
        if (i < row.length - 1) sb.write(', ');
      }
      sb.writeln(']');
    }

    return sb.toString();
  }

  // ---------------------------------------------------------------------------
  //  Strassen‑specific helpers (private)
  // ---------------------------------------------------------------------------
  /// Returns the 4‑parameter table that tells where each quarter starts
  /// and how many rows/columns it occupies.
  static List<List<int>> _params(int r, int c) => [
        //   r0, r1,  c0, c1,   dr, dc   (dr/dc are offsets used while copying)
        [0, r, 0, c, 0, 0],
        [0, r, c, 2 * c, 0, c],
        [r, 2 * r, 0, c, r, 0],
        [r, 2 * r, c, 2 * c, r, c],
      ];

  /// Splits a square matrix (size = 2·r × 2·c) into its four quarters.
  List<Matrix> _toQuarters() {
    final r = rows ~/ 2;
    final c = cols ~/ 2;
    final p = _params(r, c);
    final List<Matrix> quarters = List<Matrix>.filled(4, Matrix([]));

    for (var k = 0; k < 4; ++k) {
      final qData = List<List<double>>.generate(
          r, (_) => List<double>.filled(c, 0.0, growable: false),
          growable: false);
      for (var i = p[k][0]; i < p[k][1]; ++i) {
        for (var j = p[k][2]; j < p[k][3]; ++j) {
          qData[i - p[k][4]][j - p[k][5]] = data[i][j];
        }
      }
      quarters[k] = Matrix(qData);
    }
    return quarters;
  }

  /// Reassembles a full matrix from four quarters.
  static Matrix _fromQuarters(List<Matrix> q) {
    final r = q[0].rows;
    final c = q[0].cols;
    final p = _params(r, c);
    final rows = r * 2;
    final cols = c * 2;

    final mData = List<List<double>>.generate(
        rows, (_) => List<double>.filled(cols, 0.0, growable: false),
        growable: false);

    for (var k = 0; k < 4; ++k) {
      for (var i = p[k][0]; i < p[k][1]; ++i) {
        for (var j = p[k][2]; j < p[k][3]; ++j) {
          mData[i][j] = q[k].data[i - p[k][4]][j - p[k][5]];
        }
      }
    }

    return Matrix(mData);
  }

  // ---------------------------------------------------------------------------
  //  Strassen multiplication (public)
  // ---------------------------------------------------------------------------
  Matrix strassen(Matrix other) {
    _validateSquarePowerOfTwo();
    other._validateSquarePowerOfTwo();

    if (rows != other.rows || cols != other.cols) {
      throw StateError(
          'Matrices must be square and of equal size for Strassen multiplication.');
    }

    // Base case – 1×1 matrices are multiplied normally
    if (rows == 1) {
      return this * other;
    }

    // Split both matrices into quarters
    final a = _toQuarters();
    final b = other._toQuarters();

    // Compute the seven products (recursively)
    final p1 = (a[1] - a[3]).strassen(b[2] + b[3]);
    final p2 = (a[0] + a[3]).strassen(b[0] + b[3]);
    final p3 = (a[0] - a[2]).strassen(b[0] + b[1]);
    final p4 = (a[0] + a[1]).strassen(b[3]);
    final p5 = a[0].strassen(b[1] - b[3]);
    final p6 = a[3].strassen(b[2] - b[0]);
    final p7 = (a[2] + a[3]).strassen(b[0]);

    // Combine the products into the four result quadrants
    final List<Matrix> q = List<Matrix>.filled(
        4,
        Matrix(
            List<List<double>>.filled(0, [])), // placeholder – will be overwritten
        growable: false);

    q[0] = p1 + p2 - p4 + p6;
    q[1] = p4 + p5;
    q[2] = p6 + p7;
    q[3] = p2 - p3 + p5 - p7;

    // Re‑assemble the final matrix
    return Matrix._fromQuarters(q);
  }
}

// -----------------------------------------------------------------------------
//  Demo (mirrors the original C++ main)
// -----------------------------------------------------------------------------
void main() {
  final a = Matrix([
    [1.0, 2.0],
    [3.0, 4.0]
  ]);
  final b = Matrix([
    [5.0, 6.0],
    [7.0, 8.0]
  ]);
  final c = Matrix([
    [1.0, 1.0, 1.0, 1.0],
    [2.0, 4.0, 8.0, 16.0],
    [3.0, 9.0, 27.0, 81.0],
    [4.0, 16.0, 64.0, 256.0],
  ]);
  final d = Matrix([
    [4.0, -3.0, 4.0 / 3.0, -1.0 / 4.0],
    [-13.0 / 3.0, 19.0 / 4.0, -7.0 / 3.0, 11.0 / 24.0],
    [3.0 / 2.0, -2.0, 7.0 / 6.0, -1.0 / 4.0],
    [-1.0 / 6.0, 1.0 / 4.0, -1.0 / 6.0, 1.0 / 24.0],
  ]);
  final e = Matrix([
    [1.0, 2.0, 3.0, 4.0],
    [5.0, 6.0, 7.0, 8.0],
    [9.0, 10.0, 11.0, 12.0],
    [13.0, 14.0, 15.0, 16.0],
  ]);
  final f = Matrix([
    [1.0, 0.0, 0.0, 0.0],
    [0.0, 1.0, 0.0, 0.0],
    [0.0, 0.0, 1.0, 0.0],
    [0.0, 0.0, 0.0, 1.0],
  ]);

  print("Using 'normal' matrix multiplication:");
  print('  a * b = ${a * b}');
  print('  c * d = ${ (c * d).toStringWithPrecision(6)}');
  print('  e * f = ${e * f}');

  print('\nUsing \'Strassen\' matrix multiplication:');
  print('  a * b = ${a.strassen(b)}');
  print('  c * d = ${c.strassen(d).toStringWithPrecision(6)}');
  print('  e * f = ${e.strassen(f)}');
}
