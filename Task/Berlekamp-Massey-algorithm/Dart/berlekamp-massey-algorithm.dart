void main() {
  List<int> source = [0, 1, 1, 2, 3, 5, 8, 13, 21];
  BerlekampMassey bm = BerlekampMassey(source, 100);
  List<int> bmCoeffs = bm.computeCoefficients();
  print("Berlekamp-Massey coefficients: $bmCoeffs (lowest to highest degree)");
  print("The connection polynomial is ${bm.polynomial(bmCoeffs)} "
      "having degree ${bmCoeffs.length - 1}\n");

  print("Terms indexed 35 to 40 from the Fibonacci sequence modulo 100:");
  // Result can be checked on www.oeis.net, A000045
  for (int n in [35, 36, 37, 38, 39, 40]) {
    print("${bm.computeTerm(bmCoeffs, n)} ");
  }
}

class BerlekampMassey {
  final List<int> source;
  final int modulus;

  BerlekampMassey(List<int> aSource, this.modulus)
      : source = List<int>.from(aSource);

  List<int> computeCoefficients() {
    List<int> result = <int>[];
    List<int> previousResult = <int>[];
    int failIndex = -1;

    for (int i = 0; i < source.length; i++) {
      int delta = source[i];
      for (int j = 1; j <= result.length; j++) {
        delta -= result[j - 1] * source[i - j];
      }

      if (delta == 0) {
        continue;
      }

      if (failIndex == -1) {
        result = List<int>.filled(i + 1, 0);
        failIndex = i;
      } else {
        List<int> previousResultCopy = <int>[];
        previousResultCopy.add(1);
        for (int term in previousResult) {
          previousResultCopy.add(-term);
        }

        int termFailIndexPlusOne = 0;
        for (int j = 1; j <= previousResultCopy.length; j++) {
          termFailIndexPlusOne += previousResultCopy[j - 1] * source[failIndex + 1 - j];
        }

        final int coeff = delta ~/ termFailIndexPlusOne;
        for (int k = 0; k < previousResultCopy.length; k++) {
          previousResultCopy[k] = previousResultCopy[k] * coeff;
        }

        for (int k = 0; k < i - failIndex - 1; k++) {
          previousResultCopy.insert(0, 0);
        }

        List<int> resultCopy = List<int>.from(result);
        while (result.length < previousResultCopy.length) {
          result.add(0);
        }

        for (int j = 0; j < previousResultCopy.length; j++) {
          result[j] = result[j] + previousResultCopy[j];
        }

        if (i - resultCopy.length > failIndex - previousResult.length) {
          previousResult = List<int>.from(resultCopy);
          failIndex = i;
        }
      }
    }
    return result;
  }

  int computeTerm(List<int> bmCoeffs, int index) {
    if (bmCoeffs.isEmpty) {
      return 0;
    }

    if (index < source.length) {
      return (source[index] + modulus) % modulus;
    }

    List<int> coeffs = <int>[];
    coeffs.add(modulus - 1);
    coeffs.addAll(bmCoeffs);

    final int bmCoeffsSize = bmCoeffs.length;
    List<int> f = List<int>.filled(bmCoeffsSize, 0);
    List<int> g = List<int>.filled(bmCoeffsSize, 0);

    f[0] = 1;
    if (bmCoeffsSize == 1) {
      g[0] = coeffs[1];
    } else {
      g[1] = 1;
    }

    int power = index - 1;
    while (power > 0) {
      if ((power & 1) == 1) {
        f = polynomialMultiply(f, g, bmCoeffsSize, coeffs);
      }
      g = polynomialMultiply(g, g, bmCoeffsSize, coeffs);
      power >>= 1;
    }

    int result = 0;
    for (int i = 0; i < bmCoeffsSize; i++) {
      if (i + 1 < source.length) {
        result = (result + source[i + 1] * f[i]) % modulus;
      }
    }
    return (result + modulus) % modulus;
  }

  String polynomial(List<int> bmCoeffs) {
    final int degree = bmCoeffs.length - 1;
    if (degree == 0) {
      return bmCoeffs.first.toString();
    }

    StringBuffer text = StringBuffer();
    for (int i = degree; i >= 0; i--) {
      final int coeff = bmCoeffs[i];
      if (coeff == 0) {
        continue;
      }

      String sign = (coeff < 0 && i == degree)
          ? "-"
          : (coeff < 0)
              ? " - "
              : (i < degree)
                  ? " + "
                  : "";
      text.write(sign);

      final int coeffAbs = coeff.abs();
      if (coeffAbs > 1) {
        text.write(coeffAbs);
      }

      String term = (i > 1)
          ? "x^$i"
          : (i == 1)
              ? "x"
              : (coeffAbs == 1)
                  ? "1"
                  : "";
      text.write(term);
    }
    return text.toString();
  }

  List<int> polynomialMultiply(List<int> a, List<int> b, int degree, List<int> coeffs) {
    List<int> result = List<int>.filled(2 * degree, 0);

    for (int i = 0; i < degree; i++) {
      if (a[i] == 0) {
        continue;
      }
      for (int j = 0; j < degree; j++) {
        result[i + j] = (result[i + j] + a[i] * b[j]) % modulus;
      }
    }

    for (int i = 2 * degree - 1; i > degree - 1; i--) {
      if (result[i] == 0) {
        continue;
      }
      final int term = result[i];
      result[i] = 0;
      for (int j = 0; j <= degree; j++) {
        final int index = i - j;
        if (index >= 0) {
          result[index] = (result[index] + term * coeffs[j]) % modulus;
        }
      }
    }
    return result.sublist(0, degree);
  }
}
