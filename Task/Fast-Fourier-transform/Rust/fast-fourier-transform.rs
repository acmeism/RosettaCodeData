extern crate num;
use num::complex::Complex;
use std::f64::consts::PI;

const I: Complex<f64> = Complex { re: 0.0, im: 1.0 };

pub fn fft(input: &[Complex<f64>]) -> Vec<Complex<f64>> {
    fn fft_inner(
        buf_a: &mut [Complex<f64>],
        buf_b: &mut [Complex<f64>],
        n: usize,    // total length of the input array
        step: usize, // precalculated values for t
    ) {
        if step >= n {
            return;
        }

        fft_inner(buf_b, buf_a, n, step * 2);
        fft_inner(&mut buf_b[step..], &mut buf_a[step..], n, step * 2);
        // create a slice for each half of buf_a:
        let (left, right) = buf_a.split_at_mut(n / 2);

        for i in (0..n).step_by(step * 2) {
            let t = (-I * PI * (i as f64) / (n as f64)).exp() * buf_b[i + step];
            left[i / 2] = buf_b[i] + t;
            right[i / 2] = buf_b[i] - t;
        }
    }

    // round n (length) up to a power of 2:
    let n_orig = input.len();
    let n = n_orig.next_power_of_two();
    // copy the input into a buffer:
    let mut buf_a = input.to_vec();
    // right pad with zeros to a power of two:
    buf_a.append(&mut vec![Complex { re: 0.0, im: 0.0 }; n - n_orig]);
    // alternate between buf_a and buf_b to avoid allocating a new vector each time:
    let mut buf_b = buf_a.clone();
    fft_inner(&mut buf_a, &mut buf_b, n, 1);
    buf_a
}

fn show(label: &str, buf: &[Complex<f64>]) {
    println!("{}", label);
    let string = buf
        .into_iter()
        .map(|x| format!("{:.4}{:+.4}i", x.re, x.im))
        .collect::<Vec<_>>()
        .join(", ");
    println!("{}", string);
}

fn main() {
    let input: Vec<_> = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]
        .into_iter()
        .map(|x| Complex::from(x))
        .collect();
    show("input:", &input);
    let output = fft(&input);
    show("output:", &output);
}
