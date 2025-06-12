// Vector and matrix types
// In JavaScript, we'll use arrays directly

function printMatrix(matrix, title) {
  console.log(title);
  for (const row of matrix) {
    console.log(row.map(x => x.toString().padStart(10)).join(''));
  }
}

function createIdentityMatrix(n) {
  const result = Array(n).fill().map(() => Array(n).fill(0));
  for (let i = 0; i < n; i++) {
    result[i][i] = 1;
  }
  return result;
}

function inverse(matrix) {
  const n = matrix.length;

  // Check if it's a square matrix
  for (const row of matrix) {
    if (row.length !== n) {
      throw new Error("Not a square matrix");
    }
  }

  // Create identity matrix for the result
  const b = createIdentityMatrix(n);

  // Create a copy of the input matrix
  const a = matrix.map(row => [...row]);

  for (let k = 0; k < n; k++) {
    let iMax = 0;
    let max = -1;

    for (let i = k; i < n; i++) {
      const row = a[i];

      // Compute scale factor s = max abs in row
      let s = -1;
      for (let j = k; j < n; j++) {
        const x = Math.abs(row[j]);
        if (x > s) {
          s = x;
        }
      }

      if (s === 0) {
        throw new Error("Irregular matrix");
      }

      // Scale the abs used to pick the pivot
      const abs = Math.abs(row[k]) / s;
      if (abs > max) {
        iMax = i;
        max = abs;
      }
    }

    // Swap rows if needed
    if (k !== iMax) {
      [a[k], a[iMax]] = [a[iMax], a[k]];
      [b[k], b[iMax]] = [b[iMax], b[k]];
    }

    const akk = a[k][k];

    for (let j = 0; j < n; j++) {
      a[k][j] /= akk;
      b[k][j] /= akk;
    }

    for (let i = 0; i < n; i++) {
      if (i !== k) {
        const aik = a[i][k];
        for (let j = 0; j < n; j++) {
          a[i][j] -= a[k][j] * aik;
          b[i][j] -= b[k][j] * aik;
        }
      }
    }
  }

  return b;
}

function main() {
  const a = [[1, 2, 3], [4, 1, 6], [7, 8, 9]];
  printMatrix(inverse(a), "Inverse of A is:\n");

  const b = [[2, -1, 0], [-1, 2, -1], [0, -1, 2]];
  printMatrix(inverse(b), "Inverse of B is:\n");
}

// Run the main function
main();
