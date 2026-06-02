import "std/sort.zc"
import "std/math.zc"

fn fivenum(a: f64*, size: const usize) {
    sort_double(a, size);
    let n5: [f64; 5];
    let n = (f64)size;
    let n4 = Math::floor((n + 3.0) / 2.0) / 2.0;
    let d = [1.0, n4, (n + 1.0) / 2.0, n + 1.0 - n4, n];
    let e = 0;
    for de in d {
        let floor = (usize)Math::floor(de - 1.0);
        let ceil  = (usize)Math::ceil (de - 1.0);
        n5[e++] = 0.5 * (a[floor] + a[ceil]);
    }
    print "[";
    for i in 0..5 {
        print "{n5[i]:0.9g}";
        if i < 4 {
            print ", ";
        } else {
            println "]";
        }
    }
}

fn main() {
    let x1 = [36.0, 40.0, 7.0, 39.0, 41.0, 15.0];
    let x2 = [15.0, 6.0, 42.0, 41.0, 7.0, 36.0, 49.0, 40.0, 39.0, 47.0, 43.0];
    let x3 = [
        0.14082834,  0.09748790,  1.73131507,  0.87636009, -1.95059594,
        0.73438555, -0.03035726,  1.46675970, -0.74621349, -0.72588772,
        0.63905160,  0.61501527, -0.98983780, -1.00447874, -0.62759469,
        0.66206163,  1.04312009, -0.10305385,  0.75775634,  0.32566578
    ];
    let xs: f64*[3] = [x1, x2, x3];
    let sizes = [6, 11, 20];
    for i in 0..3 { fivenum(xs[i], sizes[i]) };
}
