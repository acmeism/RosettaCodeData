class LatinSquaresInReducedForm {
    constructor() {
        // No initialization needed
    }

    static main() {
        console.log("PART 1: 10,000 latin Squares of order 4 in reduced form:\n");
        const original4 = [[1, 2, 3, 4], [2, 1, 4, 3], [3, 4, 1, 2], [4, 3, 2, 1]];
        let frequencies = new Map();
        let cube = this.createCube(original4, 4);

        for (let i = 1; i <= 10000; i++) {
            this.shuffleCube(cube);
            let matrix = this.toMatrix(cube);
            this.reduce(matrix);
            this.oneBased(matrix);
            const key = JSON.stringify(matrix);
            frequencies.set(key, (frequencies.get(key) || 0) + 1);
        }

        for (let [key, value] of frequencies.entries()) {
            console.log(`${key} occurs ${value} times`);
        }

        console.log("\nPART 2: 10,000 latin squares of order 5 in reduced form:");
        const original5 = [
            [1, 2, 3, 4, 5],
            [2, 3, 4, 5, 1],
            [3, 4, 5, 1, 2],
            [4, 5, 1, 2, 3],
            [5, 1, 2, 3, 4]
        ];
        frequencies.clear();
        cube = this.createCube(original5, 5);

        for (let i = 1; i <= 10000; i++) {
            this.shuffleCube(cube);
            let matrix = this.toMatrix(cube);
            this.reduce(matrix);
            const key = JSON.stringify(matrix);
            frequencies.set(key, (frequencies.get(key) || 0) + 1);
        }

        let count = 0;
        let output = "";
        for (let frequency of frequencies.values()) {
            count++;
            const prefix = count > 1 ? ", " : "";
            const newline = count % 8 === 1 ? "\n" : "";
            output += `${prefix}${newline}${count.toString().padStart(2)}(${frequency.toString().padStart(3)})`;
        }
        console.log(output);

        console.log("\n\nPART 3: 750 latin squares of order 42, showing the last one:\n");
        let matrix42 = null;
        cube = this.createCube(null, 42);
        for (let i = 1; i <= 750; i++) {
            this.shuffleCube(cube);
            if (i === 750) {
                matrix42 = this.toMatrix(cube);
                this.oneBased(matrix42);
            }
        }
        matrix42.forEach(row => console.log(JSON.stringify(row)));

        console.log("\nPART 4: 1,000 latin squares of order 256:\n");
        const startTime = Date.now();
        cube = this.createCube(null, 256);
        for (let i = 1; i <= 1000; i++) {
            this.shuffleCube(cube);
        }
        const finishTime = Date.now();
        console.log(`Generated in ${finishTime - startTime} milliseconds`);
    }

    static reduce(matrix) {
        // Reduce columns
        for (let j = 0; j < matrix.length - 1; j++) {
            if (matrix[0][j] !== j) {
                for (let k = j + 1; k < matrix.length; k++) {
                    if (matrix[0][k] === j) {
                        for (let i = 0; i < matrix.length; i++) {
                            const temp = matrix[i][j];
                            matrix[i][j] = matrix[i][k];
                            matrix[i][k] = temp;
                        }
                        break;
                    }
                }
            }
        }

        // Reduce rows
        for (let i = 1; i < matrix.length - 1; i++) {
            if (matrix[i][0] !== i) {
                for (let k = i + 1; k < matrix.length; k++) {
                    if (matrix[k][0] === i) {
                        for (let j = 0; j < matrix.length; j++) {
                            const temp = matrix[i][j];
                            matrix[i][j] = matrix[k][j];
                            matrix[k][j] = temp;
                        }
                        break;
                    }
                }
            }
        }
    }

    static toMatrix(cube) {
        const matrix = Array(cube.length).fill().map(() => Array(cube.length).fill(0));
        for (let i = 0; i < cube.length; i++) {
            for (let j = 0; j < cube.length; j++) {
                for (let k = 0; k < cube.length; k++) {
                    if (cube[i][j][k] !== 0) {
                        matrix[i][j] = k;
                        break;
                    }
                }
            }
        }
        return matrix;
    }

    static shuffleCube(cube) {
        let proper = true;

        let rx, ry, rz;
        do {
            rx = Math.floor(Math.random() * cube.length);
            ry = Math.floor(Math.random() * cube.length);
            rz = Math.floor(Math.random() * cube.length);
        } while (cube[rx][ry][rz] !== 0);

        while (true) {
            let ox = 0, oy = 0, oz = 0;

            while (cube[ox][ry][rz] !== 1) {
                ox++;
            }
            while (cube[rx][oy][rz] !== 1) {
                oy++;
            }
            while (cube[rx][ry][oz] !== 1) {
                oz++;
            }

            if (!proper) {
                if (Math.floor(Math.random() * 2) === 0) {
                    ox++;
                    while (cube[ox][ry][rz] !== 1) {
                        ox++;
                    }
                }
                if (Math.floor(Math.random() * 2) === 0) {
                    oy++;
                    while (cube[rx][oy][rz] !== 1) {
                        oy++;
                    }
                }
                if (Math.floor(Math.random() * 2) === 0) {
                    oz++;
                    while (cube[rx][ry][oz] !== 1) {
                        oz++;
                    }
                }
            }

            cube[rx][ry][rz]++;
            cube[rx][oy][oz]++;
            cube[ox][ry][oz]++;
            cube[ox][oy][rz]++;

            cube[rx][ry][oz]--;
            cube[rx][oy][rz]--;
            cube[ox][ry][rz]--;
            cube[ox][oy][oz]--;

            if (cube[ox][oy][oz] < 0) {
                rx = ox;
                ry = oy;
                rz = oz;
                proper = false;
            } else {
                break;
            }
        }
    }

    static createCube(matrix, size) {
        const cube = Array(size).fill().map(() =>
            Array(size).fill().map(() => Array(size).fill(0))
        );

        for (let i = 0; i < size; i++) {
            for (let j = 0; j < size; j++) {
                const k = matrix === null ? (i + j) % size : matrix[i][j] - 1;
                cube[i][j][k] = 1;
            }
        }
        return cube;
    }

    static oneBased(matrix) {
        for (let i = 0; i < matrix.length; i++) {
            for (let j = 0; j < matrix.length; j++) {
                matrix[i][j]++;
            }
        }
    }
}

// Run the main function
LatinSquaresInReducedForm.main();
