// Periodic table

class PeriodicTable {
  constructor() {
    this.aArray = [1, 2, 5, 13, 57, 72, 89, 104];
    this.bArray = [-1, 15, 25, 35, 72, 21, 58, 7];
  }

  rowAndColumn(n) {
    var i = 7;
    while (this.aArray[i] > n)
      i--;
    var m = n + this.bArray[i];
    return [Math.floor(m / 18) + 1, m % 18 + 1];
  }
}

pt = new PeriodicTable();
// Example elements (atomic numbers).
for (var n of [1, 2, 29, 42, 57, 58, 72, 89, 90, 103]) {
  [r, c] = pt.rowAndColumn(n);
  console.log(n.toString().padStart(3, ' ') + " ->" +
              r.toString().padStart(2, ' ') + c.toString().padStart(3, ' '));
}
