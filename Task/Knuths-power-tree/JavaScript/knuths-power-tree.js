class PowerTree {
    static p = new Map();
    static lvl = [];

    static {
        PowerTree.p.set(1, 0);

        let temp = [1];
        PowerTree.lvl.push(temp);
    }

    static path(n) {
        if (n === 0) return [];
        while (!PowerTree.p.has(n)) {
            let q = [];
            for (let x of PowerTree.lvl[0]) {
                for (let y of PowerTree.path(x)) {
                    if (PowerTree.p.has(x + y)) break;
                    PowerTree.p.set(x + y, x);
                    q.push(x + y);
                }
            }
            PowerTree.lvl[0] = [...q]; // Important: create a new array!  Otherwise, the original array is mutated.
        }
        let temp = PowerTree.path(PowerTree.p.get(n));
        temp.push(n);
        return temp;
    }

    static treePow(x, n) {
        const r = new Map();
        r.set(0, 1n);  // Changed to bigint for accurate integer results
        r.set(1, BigInt(Math.round(x)));  // Convert to BigInt


        if (Number.isInteger(x) && Number.isInteger(n) && n>30){
             r.set(0, 1n);
             r.set(1, BigInt(x));
        } else {
            r.set(0, 1);
             r.set(1, x);
        }


        let p = 0;
        const path_result = PowerTree.path(n);

        for (let i of path_result) {
            let a = r.get(i - p);
            let b = r.get(p);

             if (Number.isInteger(x) && Number.isInteger(n) && n>30){
                r.set(i, a * b);
             } else {

                 if (typeof a === 'bigint' && typeof b === 'bigint'){
                      r.set(i, Number(a) * Number(b));
                 } else if (typeof a === 'bigint'){
                      r.set(i, Number(a) * b);
                 } else if (typeof b === 'bigint'){
                     r.set(i, a * Number(b));
                 } else {
                      r.set(i, a * b);
                 }
             }


            p = i;
        }

        if (Number.isInteger(x) && Number.isInteger(n) && n>30){
           return Number(r.get(n));
        }
        return r.get(n);
    }


    static showPow(x, n, isIntegral) {
        console.log(`${n}: ${PowerTree.path(n)}`);
        let f = isIntegral ? "%.0f" : "%f";
        //console.log(f, x); // Javascript doesn't have printf-style formatting built in

        let formatted_x;
        if (isIntegral) {
            formatted_x = Math.round(x);
        } else {
            formatted_x = x.toFixed(6); // Or whatever precision you need.
        }

        console.log(`${formatted_x} ^ ${n} = ${PowerTree.treePow(x, n)}`);
        console.log("\n");
    }

    static main() {
        for (let n = 0; n <= 17; ++n) {
            PowerTree.showPow(2.0, n, true);
        }
         PowerTree.showPow(1.1, 81, false);
        PowerTree.showPow(3.0, 191, true);
    }
}

PowerTree.main();
