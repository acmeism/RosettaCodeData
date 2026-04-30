class Grid {
    constructor(size, probability) {
        this.CLUSTERED = -1;
        this.GRID_CHARACTERS = ".ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
        this.grid = [];
        this._clusterCount = 0;
        this.createGrid(size, probability);
        this.countClusters();
    }

    get clusterCount() {
        return this._clusterCount;
    }

    clusterDensity() {
        return this._clusterCount / (this.grid.length * this.grid.length);
    }

    display() {
        for (let row = 0; row < this.grid.length; row++) {
            let line = "";
            for (let col = 0; col < this.grid.length; col++) {
                const value = this.grid[row][col];
                const ch = value < this.GRID_CHARACTERS.length ? this.GRID_CHARACTERS.charAt(value) : '?';
                line += " " + ch;
            }
            console.log(line);
        }
    }

    countClusters() {
        this._clusterCount = 0;
        for (let row = 0; row < this.grid.length; row++) {
            for (let col = 0; col < this.grid.length; col++) {
                if (this.grid[row][col] === this.CLUSTERED) {
                    this._clusterCount += 1;
                    this.identifyCluster(row, col, this._clusterCount);
                }
            }
        }
    }

    identifyCluster(row, col, count) {
        this.grid[row][col] = count;
        if (row < this.grid.length - 1 && this.grid[row + 1][col] === this.CLUSTERED) {
            this.identifyCluster(row + 1, col, count);
        }
        if (col < this.grid[0].length - 1 && this.grid[row][col + 1] === this.CLUSTERED) {
            this.identifyCluster(row, col + 1, count);
        }
        if (col > 0 && this.grid[row][col - 1] === this.CLUSTERED) {
            this.identifyCluster(row, col - 1, count);
        }
        if (row > 0 && this.grid[row - 1][col] === this.CLUSTERED) {
            this.identifyCluster(row - 1, col, count);
        }
    }

    createGrid(gridSize, probability) {
        this.grid = Array(gridSize).fill().map(() => Array(gridSize).fill(0));
        for (let row = 0; row < gridSize; row++) {
            for (let col = 0; col < gridSize; col++) {
                if (Math.random() < probability) {
                    this.grid[row][col] = this.CLUSTERED;
                }
            }
        }
    }
}

function main() {
    const size = 15;
    const probability = 0.5;
    const testCount = 5;

    const grid = new Grid(size, probability);
    console.log(`This ${size} by ${size} grid contains ${grid.clusterCount} clusters:`);
    grid.display();

    console.log(`\n p = 0.5, iterations = ${testCount}`);
    const gridSizes = [10, 100, 1000, 10000];
    for (const gridSize of gridSizes) {
        let sumDensity = 0.0;
        for (let test = 0; test < testCount; test++) {
            const g = new Grid(gridSize, probability);
            sumDensity += g.clusterDensity();
        }
        const result = sumDensity / testCount;
        console.log(` n = ${gridSize}, simulation K = ${result.toFixed(6)}`);
    }
}

main();
