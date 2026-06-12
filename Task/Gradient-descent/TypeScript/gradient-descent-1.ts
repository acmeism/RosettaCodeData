// Using the steepest-descent method to search
// for minimum values of a multi-variable function
export const steepestDescent = (x: number[], alpha: number, tolerance: number) => {

    let n: number = x.length; // size of input array
    let h: number = 0.0000006; //Tolerance factor
    let g0: number = g(x); //Initial estimate of result

    //Calculate initial gradient
    let fi: number[] = [n];

    //Calculate initial norm
    fi = GradG(x, h);
    // console.log("fi:"+fi);

    //Calculate initial norm
    let DelG: number = 0.0;

    for (let i: number = 0; i < n; ++i) {
        DelG += fi[i] * fi[i];
    }
    DelG = Math.sqrt(DelG);
    let b: number = alpha / DelG;

    //Iterate until value is <= tolerance limit
    while (DelG > tolerance) {
        //Calculate next value
        for (let i = 0; i < n; ++i) {
            x[i] -= b * fi[i];
        }
        h /= 2;

        //Calculate next gradient
        fi = GradG(x, h);
        //Calculate next norm
        DelG = 0;
        for (let i: number = 0; i < n; ++i) {
            DelG += fi[i] * fi[i];
        }

        DelG = Math.sqrt(DelG);
        b = alpha / DelG;

        //Calculate next value
        let g1: number = g(x);

        //Adjust parameter
        if (g1 > g0) alpha /= 2;
        else g0 = g1;
    }
}

// Provides a rough calculation of gradient g(x).
export const GradG = (x: number[], h: number) => {

    let n: number = x.length;
    let z: number[] = [n];
    let y: number[] = x;
    let g0: number = g(x);

    // console.log("y:" + y);

    for (let i = 0; i < n; ++i) {
        y[i] += h;
        z[i] = (g(y) - g0) / h;
    }
    // console.log("z:"+z);
    return z;
}

// Method to provide function g(x).
export const g = (x: number[]) => {
    return (x[0] - 1) * (x[0] - 1)
        * Math.exp(-x[1] * x[1]) + x[1] * (x[1] + 2)
        * Math.exp(-2 * x[0] * x[0]);
}

export const gradientDescentMain = () => {
    let tolerance: number = 0.0000006;
    let alpha: number = 0.1;
    let x: number[] = [2];

    //Initial guesses
    x[0] = 0.1;
    //of location of minimums
    x[1] = -1;
    steepestDescent(x, alpha, tolerance);

    console.log("Testing steepest descent method");
    console.log("The minimum is at x[0] = " + x[0]
        + ", x[1] = " + x[1]);
    // console.log("");
}

gradientDescentMain();

