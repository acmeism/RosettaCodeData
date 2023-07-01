class Fen {

    public createFen() {
        let grid: string[][];

        grid = [];

        for (let r = 0; r < 8; r++) {
            grid[r] = [];
            for (let c = 0; c < 8; c++) {
                grid[r][c] = "0";
            }
        }

        this.placeKings(grid);
        this.placePieces(grid, "PPPPPPPP", true);
        this.placePieces(grid, "pppppppp", true);
        this.placePieces(grid, "RNBQBNR", false);
        this.placePieces(grid, "rnbqbnr", false);
        return this.toFen(grid);
    }

    private placeKings(grid: string[][]): void {
        let r1, c1, r2, c2: number;
        while (true) {
            r1 = Math.floor(Math.random() * 8);
            c1 = Math.floor(Math.random() * 8);
            r2 = Math.floor(Math.random() * 8);
            c2 = Math.floor(Math.random() * 8);
            if (r1 != r2 && Math.abs(r1 - r2) > 1 && Math.abs(c1 - c2) > 1) {
                break;
            }
        }
        grid[r1][c1] = "K";
        grid[r2][c2] = "k";
    }

    private placePieces(grid: string[][], pieces: string, isPawn: boolean): void {
        let numToPlace: number = Math.floor(Math.random() * pieces.length);
        for (let n = 0; n < numToPlace; n++) {
            let r, c: number;
            do {
                r = Math.floor(Math.random() * 8);
                c = Math.floor(Math.random() * 8);
            } while (grid[r][c] != "0" || (isPawn && (r == 7 || r == 0)));

            grid[r][c] = pieces.charAt(n);
        }
    }

    private toFen(grid: string[][]): string {
        let result: string = "";
        let countEmpty: number = 0;
        for (let r = 0; r < 8; r++) {
            for (let c = 0; c < 8; c++) {
                let char: string = grid[r][c];
                if (char == "0") {
                    countEmpty++;
                } else {
                    if (countEmpty > 0) {
                        result += countEmpty;
                        countEmpty = 0;
                    }
                    result += char;
                }
            }
            if (countEmpty > 0) {
                result += countEmpty;
                countEmpty = 0;
            }
            result += "/";
        }
        return result += " w - - 0 1";
    }

}

let fen: Fen = new Fen();
console.log(fen.createFen());
