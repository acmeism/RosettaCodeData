class BWT {
    static STX = "\u0002";
    static ETX = "\u0003";

    static bwt(s) {
        if (s.includes(BWT.STX) || s.includes(BWT.ETX)) {
            throw new Error("String cannot contain STX or ETX");
        }

        const ss = BWT.STX + s + BWT.ETX;
        const table = [];
        for (let i = 0; i < ss.length; i++) {
            const before = ss.substring(i);
            const after = ss.substring(0, i);
            table.push(before + after);
        }
        table.sort();

        let sb = "";
        for (const str of table) {
            sb += str.charAt(str.length - 1);
        }
        return sb;
    }

    static ibwt(r) {
        const len = r.length;
        const table = [];
        for (let i = 0; i < len; ++i) {
            table.push("");
        }
        for (let j = 0; j < len; ++j) {
            for (let i = 0; i < len; ++i) {
                table[i] = r.charAt(i) + table[i];
            }
            table.sort();
        }
        for (const row of table) {
            if (row.endsWith(BWT.ETX)) {
                return row.substring(1, len - 1);
            }
        }
        return "";
    }

    static makePrintable(s) {
        // substitute ^ for STX and | for ETX to print results
        return s.replace(BWT.STX, "^").replace(BWT.ETX, "|");
    }

    static main() {
        const tests = [
            "banana",
            "appellee",
            "dogwood",
            "TO BE OR NOT TO BE OR WANT TO BE OR NOT?",
            "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES",
            "\u0002ABC\u0003"
        ];
        for (const test of tests) {
            console.log(BWT.makePrintable(test));
            process.stdout.write(" --> ");
            let t = "";
            try {
                t = BWT.bwt(test);
                console.log(BWT.makePrintable(t));
            } catch (e) {
                console.log("ERROR: " + e.message);
            }
            const r = BWT.ibwt(t);
            console.log(` --> ${r}\n`);
        }
    }
}

BWT.main();
