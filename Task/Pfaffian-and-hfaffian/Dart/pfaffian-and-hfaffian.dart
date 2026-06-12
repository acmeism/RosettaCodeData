import 'dart:math';

enum Faffian { pfaffian, hfaffian }

class SignedPerm {
  final List<int> permutation;
  final int sign;

  SignedPerm(this.permutation, this.sign);
}

class PfaffianAndHfaffian {
  static void main() {
    List<List<List<int>>> matrices = [
      // Tiny 2 x 2 matrix
      [
        [0, 1],
        [-1, 0]
      ],

      // Small 4 x 4 matrix
      [
        [0, 1, -1, 2],
        [-1, 0, 3, -4],
        [1, -3, 0, 5],
        [-2, 4, -5, 0]
      ],

      // Symmetric 6 x 6 matrix
      [
        [1, 2, 3, 4, 5, 6],
        [2, 7, 8, 9, 10, 11],
        [3, 8, 12, 13, 14, 15],
        [4, 9, 13, 16, 17, 18],
        [5, 10, 14, 17, 19, 20],
        [6, 11, 15, 18, 20, 21]
      ],

      // Larger 10 x 10 matrix
      [
        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
        [-1, 0, 8, 7, 6, 5, 4, 3, 2, 1],
        [-2, -8, 0, 1, 2, 3, 4, 5, 6, 7],
        [-3, -7, -1, 0, 6, 5, 4, 3, 2, 1],
        [-4, -6, -2, -6, 0, 1, 2, 3, 4, 5],
        [-5, -5, -3, -5, -1, 0, 4, 3, 2, 1],
        [-6, -4, -4, -4, -2, -4, 0, 1, 2, 3],
        [-7, -3, -5, -3, -3, -3, -1, 0, 2, 1],
        [-8, -2, -6, -2, -4, -2, -2, -2, 0, 1],
        [-9, -1, -7, -1, -5, -1, -3, -1, -1, 0]
      ]
    ];

    for (var matrix in matrices) {
      printMatrix(matrix);
      for (var faffian in Faffian.values) {
        var result = computeFaffian(matrix, faffian);
        if (result != null) {
          print('${faffian.name}: $result');
        }
      }
      print('');
    }
  }

  static int? computeFaffian(List<List<int>> matrix, Faffian faffian) {
    if (matrix.length % 2 != 0) {
      print('Matrix size must be even for $faffian');
      return null;
    }

    if (!isAntisymmetric(matrix)) {
      print('The $faffian does not support non-antisymmetric matrices');
      return null;
    }

    final int n = matrix.length ~/ 2;
    int sum = 0;
    List<SignedPerm> signedPerms = signedPermutations(2 * n - 1);

    for (var signedPerm in signedPerms) {
      List<int> sigma = signedPerm.permutation;
      final int sign = (faffian == Faffian.pfaffian) ? signedPerm.sign : 1;
      int product = 1;
      for (int i = 0; i < n; i++) {
        product *= matrix[sigma[2 * i]][sigma[2 * i + 1]];
      }
      sum += sign * product;
    }

    final double normalisation = 1.0 / factorial(n) / pow(2, n);
    return (sum * normalisation).round();
  }

  static List<SignedPerm> signedPermutations(int n) {
    List<int> perms = List.generate(n + 1, (i) => i);
    List<SignedPerm> signedPerms = [SignedPerm(List.from(perms), 1)];
    int sign = 1;

    for (int k = 1; k < factorial(n + 1); k++) {
      int i = n - 1;
      int j = n;

      while (perms[i] > perms[i + 1]) {
        i -= 1;
      }
      while (perms[j] < perms[i]) {
        j -= 1;
      }

      swap(perms, i, j);
      sign = -sign;
      i += 1;
      j = n;

      while (i < j) {
        swap(perms, i, j);
        sign = -sign;
        i += 1;
        j -= 1;
      }

      signedPerms.add(SignedPerm(List.from(perms), sign));
    }

    return signedPerms;
  }

  static bool isAntisymmetric(List<List<int>> matrix) {
    for (int i = 0; i < matrix.length; i++) {
      if (matrix[i][i] != 0) {
        return false;
      }
      for (int j = i + 1; j < matrix.length; j++) {
        if (matrix[i][j] != -matrix[j][i]) {
          return false;
        }
      }
    }
    return true;
  }

  static int factorial(int n) {
    int factorial = 1;
    for (int i = 2; i <= n; i++) {
      factorial *= i;
    }
    return factorial;
  }

  static void swap(List<int> list, int i, int j) {
    final int temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }

  static void printMatrix(List<List<int>> matrix) {
    for (var row in matrix) {
      String output = '|';
      for (int i = 0; i < row.length - 1; i++) {
        output += '${row[i].toString().padLeft(2)}, ';
      }
      output += '${row[row.length - 1].toString().padLeft(2)}|';
      print(output);
    }
  }
}

void main() {
  PfaffianAndHfaffian.main();
}
