// nbody.js
const fs = require('fs');

class Vector3D {
  constructor(x = 0, y = 0, z = 0) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  plus(rhs) {
    return new Vector3D(this.x + rhs.x, this.y + rhs.y, this.z + rhs.z);
  }

  minus(rhs) {
    return new Vector3D(this.x - rhs.x, this.y - rhs.y, this.z - rhs.z);
  }

  times(scalar) {
    return new Vector3D(this.x * scalar, this.y * scalar, this.z * scalar);
  }

  mod() {
    return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
  }
}

class NBody {
  constructor(fileName) {
    const text = fs.readFileSync(fileName, 'utf-8').trim();
    const lines = text.split(/\r?\n/);

    // parse first header line: gc, bodies, timeSteps
    const [gcStr, bodiesStr, timeStepsStr] = lines[0].split(/\s+/);
    this.gc = parseFloat(gcStr);
    this.bodies = parseInt(bodiesStr, 10);
    this.timeSteps = parseInt(timeStepsStr, 10);

    // allocate arrays
    this.masses = new Array(this.bodies);
    this.positions = new Array(this.bodies);
    this.velocities = new Array(this.bodies);
    this.accelerations = new Array(this.bodies);

    // read per‐body data: mass, position, velocity
    for (let i = 0; i < this.bodies; i++) {
      this.masses[i] = parseFloat(lines[1 + 3 * i]);
      this.positions[i] = this._parseVec(lines[2 + 3 * i]);
      this.velocities[i] = this._parseVec(lines[3 + 3 * i]);
      this.accelerations[i] = new Vector3D(0, 0, 0);
    }

    // echo input
    console.log(`Contents of ${fileName}`);
    for (const line of lines) {
      console.log(line);
    }
    console.log();
    console.log(
      'Body   :      x          y          z    |     vx         vy         vz'
    );
  }

  _parseVec(line) {
    const [xs, ys, zs] = line.trim().split(/\s+/);
    return new Vector3D(parseFloat(xs), parseFloat(ys), parseFloat(zs));
  }

  resolveCollisions() {
    for (let i = 0; i < this.bodies; i++) {
      for (let j = i + 1; j < this.bodies; j++) {
        const p1 = this.positions[i], p2 = this.positions[j];
        if (p1.x === p2.x && p1.y === p2.y && p1.z === p2.z) {
          // swap velocities
          [this.velocities[i], this.velocities[j]] = [
            this.velocities[j],
            this.velocities[i],
          ];
        }
      }
    }
  }

  computeAccelerations() {
    for (let i = 0; i < this.bodies; i++) {
      let acc = new Vector3D(0, 0, 0);
      for (let j = 0; j < this.bodies; j++) {
        if (i === j) continue;
        const diff = this.positions[j].minus(this.positions[i]);
        const dist3 = Math.pow(diff.mod(), 3);
        const factor = (this.gc * this.masses[j]) / dist3;
        acc = acc.plus(diff.times(factor));
      }
      this.accelerations[i] = acc;
    }
  }

  computeVelocities() {
    for (let i = 0; i < this.bodies; i++) {
      this.velocities[i] = this.velocities[i].plus(
        this.accelerations[i]
      );
    }
  }

  computePositions() {
    for (let i = 0; i < this.bodies; i++) {
      // x = x + v + 0.5 * a
      this.positions[i] = this.positions[i]
        .plus(this.velocities[i])
        .plus(this.accelerations[i].times(0.5));
    }
  }

  simulate() {
    this.computeAccelerations();
    this.computePositions();
    this.computeVelocities();
    this.resolveCollisions();
  }

  printResults() {
    const fmt = (num) => {
      // similar to "% 8.6f"
      const s = num.toFixed(6);
      return (num >= 0 ? ' ' : '') + s.padStart(8, ' ');
    };
    for (let i = 0; i < this.bodies; i++) {
      const p = this.positions[i];
      const v = this.velocities[i];
      console.log(
        `Body ${i + 1} :${fmt(p.x)} ${fmt(p.y)} ${fmt(p.z)} |${fmt(
          v.x
        )} ${fmt(v.y)} ${fmt(v.z)}`
      );
    }
  }
}

// entry point
function main() {
  const fileName = process.argv[2] || 'nbody.txt';
  let nb;
  try {
    nb = new NBody(fileName);
  } catch (e) {
    console.error(`Error reading "${fileName}":`, e.message);
    process.exit(1);
  }

  for (let cycle = 1; cycle <= nb.timeSteps; cycle++) {
    console.log(`\nCycle ${cycle}`);
    nb.simulate();
    nb.printResults();
  }
}

main();
