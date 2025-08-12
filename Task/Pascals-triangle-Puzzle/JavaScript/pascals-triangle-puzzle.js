class Matrix {
  constructor(...lists) {
    if (lists.length === 1 && Array.isArray(lists[0][0])) {
      this.matrix = lists[0];
    } else {
      this.matrix = lists;
    }
  }

  toString() {
    return JSON.stringify(this.matrix);
  }

  determinant() {
    if (this.matrix.length === 1) {
      return this.get(0, 0);
    }
    if (this.matrix.length === 2) {
      return this.get(0, 0) * this.get(1, 1) - this.get(0, 1) * this.get(1, 0);
    }
    let sum = 0;
    let sign = 1;
    for (let i = 0; i < this.matrix.length; i++) {
      sum += sign * this.get(0, i) * this.coFactor(0, i).determinant();
      sign *= -1;
    }
    return sum;
  }

  coFactor(row, col) {
    const mat = [];
    for (let i = 0; i < this.matrix.length; i++) {
      if (i === row) {
        continue;
      }
      const list = [];
      for (let j = 0; j < this.matrix.length; j++) {
        if (j === col) {
          continue;
        }
        list.push(this.get(i, j));
      }
      mat.push(list);
    }
    return new Matrix(mat);
  }

  replaceColumn(b, column) {
    const mat = [];
    for (let row = 0; row < this.matrix.length; row++) {
      const list = [];
      for (let col = 0; col < this.matrix.length; col++) {
        let value = this.get(row, col);
        if (col === column) {
          value = b[row];
        }
        list.push(value);
      }
      mat.push(list);
    }
    return new Matrix(mat);
  }

  get(row, col) {
    return this.matrix[row][col];
  }
}

function cramersRule(matrix, b) {
  const denominator = matrix.determinant();
  const result = [];
  for (let i = 0; i < b.length; i++) {
    result.push(matrix.replaceColumn(b, i).determinant() / denominator);
  }
  return result;
}

function main() {
  const mat = new Matrix(
    [1, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0],
    [0, 1, 0, 0, 0, 0, 0, 0, 0, -1, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, -1, 1, -1],
    [0, 0, 1, 0, 0, 0, 0, 0, 0, -1, 0],
    [0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -1],
    [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 1, 1, 0, -1, 0, 0, 0, 0, 0, 0],
    [0, 0, 1, 1, 0, -1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, -1, 0, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 1, 0, -1, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0]
  );

  const b = [11, 11, 0, 4, 4, 40, 0, 0, 40, 0, 151];
  const solution = cramersRule(mat, b);

  console.log("Solution =", solution);
  console.log(`X = ${solution[8].toFixed(2)}`);
  console.log(`Y = ${solution[9].toFixed(2)}`);
  console.log(`Z = ${solution[10].toFixed(2)}`);
}

main();
