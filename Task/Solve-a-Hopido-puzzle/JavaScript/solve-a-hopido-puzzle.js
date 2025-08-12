class Node {
  constructor() {
    this.val = 0;
    this.neighbors = 0;
  }
}

class NSolver {
  constructor() {
    this.dx = new Array(8);
    this.dy = new Array(8);
    this.wid = 0;
    this.hei = 0;
    this.max = 0;
    this.arr = null;

    this.dx[0] = -2; this.dy[0] = -2; this.dx[1] = -2; this.dy[1] = 2;
    this.dx[2] = 2; this.dy[2] = -2; this.dx[3] = 2; this.dy[3] = 2;
    this.dx[4] = -3; this.dy[4] = 0; this.dx[5] = 3; this.dy[5] = 0;
    this.dx[6] = 0; this.dy[6] = -3; this.dx[7] = 0; this.dy[7] = 3;
  }

  solve(puzz, maxWid) {
    if (puzz.length < 1) return;

    this.wid = maxWid;
    this.hei = Math.floor(puzz.length / this.wid);
    const len = this.wid * this.hei;
    let c = 0;
    this.max = len;

    this.arr = new Array(len);
    for (let i = 0; i < len; i++) {
      this.arr[i] = new Node();
    }

    for (let i = 0; i < puzz.length; i++) {
      if (puzz[i] === "*") {
        this.max--;
        this.arr[c++].val = -1;
        continue;
      }
      // Handle both "." and number cases properly
      this.arr[c].val = puzz[i] === "." ? 0 : parseInt(puzz[i]);
      c++;
    }

    this.solveIt();

    c = 0;
    for (let i = 0; i < puzz.length; i++) {
      if (puzz[i] === ".") {
        puzz[i] = this.arr[c].val.toString();
      }
      c++;
    }

    return puzz;
  }

  search(x, y, w) {
    if (w > this.max) return true;

    const n = this.arr[x + y * this.wid];
    n.neighbors = this.getNeighbors(x, y);

    for (let d = 0; d < 8; d++) {
      if (n.neighbors & (1 << d)) {
        const a = x + this.dx[d];
        const b = y + this.dy[d];
        if (this.arr[a + b * this.wid].val === 0) {
          this.arr[a + b * this.wid].val = w;
          if (this.search(a, b, w + 1)) return true;
          this.arr[a + b * this.wid].val = 0;
        }
      }
    }
    return false;
  }

  getNeighbors(x, y) {
    let c = 0;
    for (let xx = 0; xx < 8; xx++) {
      const a = x + this.dx[xx];
      const b = y + this.dy[xx];
      if (a < 0 || b < 0 || a >= this.wid || b >= this.hei) continue;
      if (this.arr[a + b * this.wid].val > -1) c |= (1 << xx);
    }
    return c;
  }

  solveIt() {
    const result = this.findStart();
    if (result.z === 99999) {
      console.log("\nCan't find start point!\n");
      return;
    }
    this.search(result.x, result.y, result.z + 1);
  }

  findStart() {
    for (let b = 0; b < this.hei; b++) {
      for (let a = 0; a < this.wid; a++) {
        if (this.arr[a + this.wid * b].val === 0) {
          const x = a;
          const y = b;
          const z = 1;
          this.arr[a + this.wid * b].val = z;
          return { x, y, z };
        }
      }
    }
    return { x: 0, y: 0, z: 99999 };
  }
}

function main() {
  const wid = 7;
  const p = "* . . * . . * . . . . . . . . . . . . . . * . . . . . * * * . . . * * * * * . * * *";
  const puzz = p.split(" ");

  const solver = new NSolver();
  const result = solver.solve(puzz, wid);

  let c = 0;
  let output = "";

  for (let i = 0; i < result.length; i++) {
    if (result[i] !== "*" && result[i] !== ".") {
      const num = parseInt(result[i]);
      if (!isNaN(num) && num < 10) output += "0";
      output += result[i] + " ";
    } else {
      output += "   ";
    }

    if (++c >= wid) {
      output += "\n";
      c = 0;
    }
  }

  console.log(output);
}

main();
