fn average_square_diff(f: f64, preds: f64*, size: usize) -> f64 {
    let sum = 0.0;
    for i in 0..<size {
        sum += (preds[i] - f) * (preds[i] - f);
    }
    return sum / size;
}

fn diversity_theorem(truth: f64, preds: f64*, size: usize) -> (f64, f64, f64) {
    let sum = 0.0;
    for i in 0..<size {
        sum += preds[i];
    }
    let av = sum / size;
    let av_err = average_square_diff(truth, preds, size);
    let crowd_err = (truth - av) * (truth - av);
    let div = average_square_diff(av, preds, size);
    let res = (av_err, crowd_err, div);
    return res;
}

fn main() {
    let truth = 49.0;
    let a1: f64[3] = [48.0, 47.0, 51.0];
    let a2: f64[4] = [48.0, 47.0, 51.0, 42.0];
    let res: (f64, f64, f64)[2];
    res[0] = diversity_theorem(truth, a1, 3);
    res[1] = diversity_theorem(truth, a2, 4);
    for i in 0..res.len {
        let (ae, ce, div) = res[i];
        println "Average-error {ae:6.3f}";
        println "Crowd-error   {ce:6.3f}";
        println "Diversity     {div:6.3f}\n";
    }
}
