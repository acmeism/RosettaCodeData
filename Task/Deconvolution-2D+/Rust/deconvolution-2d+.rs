extern crate num_complex; // 0.4.6

use std::f64::consts::PI;
use num_complex::Complex;
use std::fmt;

struct ReturnValue {
    power_of_two: i32,
    list: Vec<Complex<f64>>,
}

// Custom Display implementation for Complex
// impl fmt::Display for Complex<f64> {
//     fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
//         if self.im >= 0.0 {
//             write!(f, "{}+{}i", self.re, self.im)
//         } else {
//             write!(f, "{}{}i", self.re, self.im)
//         }
//     }
// }

fn print_vector<T: fmt::Display>(list: &[T]) {
    print!("[");
    for (i, item) in list.iter().enumerate() {
        if i < list.len() - 1 {
            print!("{}, ", item);
        } else {
            print!("{}", item);
        }
    }
    print!("]");
}

fn print_2d_vector<T: fmt::Display>(lists: &[Vec<T>]) {
    print!("[");
    for (i, list) in lists.iter().enumerate() {
        print_vector(list);
        if i < lists.len() - 1 {
            print!(", ");
        }
    }
    print!("]");
}

fn print_3d_vector<T: fmt::Display>(lists: &[Vec<Vec<T>>]) {
    print!("[");
    for (i, list) in lists.iter().enumerate() {
        print_2d_vector(list);
        if i < lists.len() - 1 {
            print!(", ");
        }
    }
    println!("]");
}

fn pad_and_complexify(list: &[i32], power_of_two: i32) -> ReturnValue {
    let padded_vector_size = if power_of_two == 0 {
        1 << (f64::ceil(f64::log2(list.len() as f64)) as i32)
    } else {
        power_of_two
    };

    let mut padded_vector = vec![Complex::new(0.0, 0.0); padded_vector_size as usize];
    for i in 0..padded_vector_size {
        padded_vector[i as usize] = if i < list.len() as i32 {
            Complex::new(list[i as usize] as f64, 0.0)
        } else {
            Complex::new(0.0, 0.0)
        };
    }

    ReturnValue {
        power_of_two: padded_vector_size,
        list: padded_vector,
    }
}

fn pack_2d(to_pack: &[i32], to_pack_x: usize, to_pack_y: usize, convolved_y: i32) -> Vec<Vec<i32>> {
    let mut packed = vec![vec![0; to_pack_y]; to_pack_x];
    for i in 0..to_pack_x {
        for j in 0..to_pack_y {
            packed[i][j] = to_pack[i * convolved_y as usize + j] / 4;
        }
    }
    packed
}

fn pack_3d(to_pack: &[i32], to_pack_x: usize, to_pack_y: usize, to_pack_z: usize,
           convolved_y: i32, convolved_z: i32) -> Vec<Vec<Vec<i32>>> {
    let mut packed = vec![vec![vec![0; to_pack_z]; to_pack_y]; to_pack_x];
    for i in 0..to_pack_x {
        for j in 0..to_pack_y {
            for k in 0..to_pack_z {
                packed[i][j][k] = to_pack[(i * convolved_y as usize + j) * convolved_z as usize + k] / 4;
            }
        }
    }
    packed
}

fn unpack_2d(to_unpack: &[Vec<i32>], convolved_y: i32) -> Vec<i32> {
    let mut unpacked = vec![0; to_unpack.len() * convolved_y as usize];
    for i in 0..to_unpack.len() {
        for j in 0..to_unpack[0].len() {
            unpacked[i * convolved_y as usize + j] = to_unpack[i][j];
        }
    }
    unpacked
}

fn unpack_3d(to_unpack: &[Vec<Vec<i32>>], convolved_y: i32, convolved_z: i32) -> Vec<i32> {
    let mut unpacked = vec![0; to_unpack.len() * convolved_y as usize * convolved_z as usize];
    for i in 0..to_unpack.len() {
        for j in 0..to_unpack[0].len() {
            for k in 0..to_unpack[0][0].len() {
                unpacked[(i * convolved_y as usize + j) * convolved_z as usize + k] = to_unpack[i][j][k];
            }
        }
    }
    unpacked
}

fn fft_recursive(deconvolution1d: &mut [Complex<f64>], result: &mut [Complex<f64>],
                 power_of_two: i32, step: i32, start: i32) {
    if step < power_of_two {
        fft_recursive(result, deconvolution1d, power_of_two, 2 * step, start);
        fft_recursive(result, deconvolution1d, power_of_two, 2 * step, start + step);

        for j in (0..power_of_two).step_by(2 * step as usize) {
            let theta = -PI * j as f64 / power_of_two as f64;
            let t = Complex::new(f64::cos(theta), f64::sin(theta)) * result[(j + step + start) as usize];
            deconvolution1d[(j / 2 + start) as usize] = result[(j + start) as usize] + t;
            deconvolution1d[((j + power_of_two) / 2 + start) as usize] = result[(j + start) as usize] - t;
        }
    }
}

fn fft(deconvolution1d: &mut [Complex<f64>], power_of_two: i32) -> Vec<Complex<f64>> {
    let mut result = deconvolution1d.to_vec();
    fft_recursive(deconvolution1d, &mut result, power_of_two, 1, 0);
    result
}

fn deconvolution(convolved: &[i32], convolved_size: i32, remove: &[i32], remove_size: i32,
                 convolved_row_size: i32, remain_size: i32) -> Vec<i32> {
    let mut power_of_two = 0;
    let convoluted_result = pad_and_complexify(convolved, power_of_two);
    let mut convoluted_padded = convoluted_result.list;
    let remove_result = pad_and_complexify(remove, convoluted_result.power_of_two);
    let mut remove_padded = remove_result.list;
    power_of_two = remove_result.power_of_two;

    fft(&mut convoluted_padded, power_of_two);
    fft(&mut remove_padded, power_of_two);

    let mut quotient = vec![Complex::new(0.0, 0.0); power_of_two as usize];
    for i in 0..power_of_two {
        quotient[i as usize] = convoluted_padded[i as usize] / remove_padded[i as usize];
    }

    fft(&mut quotient, power_of_two);
    for i in 0..power_of_two {
        if quotient[i as usize].re.abs() < 0.000_000_000_1 {
            quotient[i as usize] = Complex::new(0.0, 0.0);
        }
    }

    let mut remain_vector = vec![0; remain_size as usize];
    let mut i = 0;
    while i > remove_size - convolved_size - convolved_row_size {
        remain_vector[(-i) as usize] = (quotient[((i + power_of_two) % power_of_two) as usize] / Complex::new(32.0, 0.0)).re.round() as i32;
        i -= 1;
    }

    remain_vector
}

fn deconvolution_1d(convolved: &[i32], remove: &[i32]) -> Vec<i32> {
    deconvolution(
        convolved,
        convolved.len() as i32,
        remove,
        remove.len() as i32,
        1,
        convolved.len() as i32 - remove.len() as i32 + 1
    )
}

fn deconvolution_2d(convolved: &[Vec<i32>], to_remove: &[Vec<i32>]) -> Vec<Vec<i32>> {
    let convolved_1d = unpack_2d(convolved, convolved[0].len() as i32);
    let to_remove_1d = unpack_2d(to_remove, convolved[0].len() as i32);

    let to_remain_1d = deconvolution(
        &convolved_1d,
        (convolved.len() * convolved[0].len()) as i32,
        &to_remove_1d,
        (to_remove.len() * convolved[0].len()) as i32,
        convolved[0].len() as i32,
        ((convolved[0].len() - to_remove[0].len() + 1) * convolved[0].len()) as i32
    );

    pack_2d(
        &to_remain_1d,
        convolved.len() - to_remove.len() + 1,
        convolved[0].len() - to_remove[0].len() + 1,
        convolved[0].len() as i32
    )
}

fn deconvolution_3d(convolved: &[Vec<Vec<i32>>], to_remove: &[Vec<Vec<i32>>]) -> Vec<Vec<Vec<i32>>> {
    let cx = convolved.len();
    let cy = convolved[0].len();
    let cz = convolved[0][0].len();

    let rx = to_remove.len();
    let ry = to_remove[0].len();
    let rz = to_remove[0][0].len();

    let convolved_1d = unpack_3d(convolved, cy as i32, cz as i32);
    let to_remove_1d = unpack_3d(to_remove, cy as i32, cz as i32);

    let to_remain_1d = deconvolution(
        &convolved_1d,
        (cx * cy * cz) as i32,
        &to_remove_1d,
        (rx * cy * cz) as i32,
        (cy * cz) as i32,
        ((cx - rx + 1) * cy * cz) as i32
    );

    pack_3d(
        &to_remain_1d,
        cx - rx + 1,
        cy - ry + 1,
        cz - rz + 1,
        cy as i32,
        cz as i32
    )
}

fn main() {
    let f1 = vec![-3, -6, -1, 8, -6, 3, -1, -9, -9, 3, -2, 5, 2, -2, -7, -1];

    let g1 = vec![
        24, 75, 71, -34, 3, 22, -45, 23, 245, 25, 52, 25, -67, -96, 96, 31, 55, 36, 29, -43, -7
    ];

    let h1 = vec![-8, -9, -3, -1, -6, 7];

    let f2 = vec![
        vec![-5, 2, -2, -6, -7],
        vec![9, 7, -6, 5, -7],
        vec![1, -1, 9, 2, -7],
        vec![5, 9, -9, 2, -5],
        vec![-8, 5, -2, 8, 5],
    ];

    let g2 = vec![
        vec![40, -21, 53, 42, 105, 1, 87, 60, 39, -28],
        vec![-92, -64, 19, -167, -71, -47, 128, -109, 40, -21],
        vec![58, 85, -93, 37, 101, -14, 5, 37, -76, -56],
        vec![-90, -135, 60, -125, 68, 53, 223, 4, -36, -48],
        vec![78, 16, 7, -199, 156, -162, 29, 28, -103, -10],
        vec![-62, -89, 69, -61, 66, 193, -61, 71, -8, -30],
        vec![48, -6, 21, -9, -150, -22, -56, 32, 85, 25],
    ];

    let h2 = vec![
        vec![-8, 1, -7, -2, -9, 4],
        vec![4, 5, -5, 2, 7, -1],
        vec![-6, -3, -3, -6, 9, 5],
    ];

    let f3 = vec![
        vec![vec![-9, 5, -8], vec![3, 5, 1]],
        vec![vec![-1, -7, 2], vec![-5, -6, 6]],
        vec![vec![8, 5, 8], vec![-2, -6, -4]],
    ];

    let g3 = vec![
        vec![
            vec![54, 42, 53, -42, 85, -72],
            vec![45, -170, 94, -36, 48, 73],
            vec![-39, 65, -112, -16, -78, -72],
            vec![6, -11, -6, 62, 49, 8],
        ],
        vec![
            vec![-57, 49, -23, 52, -135, 66],
            vec![-23, 127, -58, -5, -118, 64],
            vec![87, -16, 121, 23, -41, -12],
            vec![-19, 29, 35, -148, -11, 45],
        ],
        vec![
            vec![-55, -147, -146, -31, 55, 60],
            vec![-88, -45, -28, 46, -26, -144],
            vec![-12, -107, -34, 150, 249, 66],
            vec![11, -15, -34, 27, -78, -50],
        ],
        vec![
            vec![56, 67, 108, 4, 2, -48],
            vec![58, 67, 89, 32, 32, -8],
            vec![-42, -31, -103, -30, -23, -8],
            vec![6, 4, -26, -10, 26, 12],
        ],
    ];

    let h3 = vec![
        vec![
            vec![-6, -8, -5, 9],
            vec![-7, 9, -6, -8],
            vec![2, -7, 9, 8],
        ],
        vec![
            vec![7, 4, 4, -6],
            vec![9, 9, 4, -4],
            vec![-3, 7, -2, -3],
        ],
    ];

    let h1_result = deconvolution_1d(&g1, &f1);
    print!("deconvolution1D(g1, f1) = ");
    print_vector(&h1_result);
    println!();
    println!("H1 = h1 ? {}", h1_result == h1);
    println!();

    let f1_result = deconvolution_1d(&g1, &h1);
    print!("deconvolution1D(g1, h1) = ");
    print_vector(&f1_result);
    println!();
    println!("F1 = f1 ? {}", f1_result == f1);
    println!();

    let h2_result = deconvolution_2d(&g2, &f2);
    print!("deconvolution2D(g2, f2) = ");
    print_2d_vector(&h2_result);
    println!();
    println!("H2 = h2 ? {}", h2_result == h2);
    println!();

    let f2_result = deconvolution_2d(&g2, &h2);
    print!("deconvolution2D(g2, h2) = ");
    print_2d_vector(&f2_result);
    println!();
    println!("F2 = f2 ? {}", f2_result == f2);
    println!();

    let h3_result = deconvolution_3d(&g3, &f3);
    print!("deconvolution3D(g3, f3) = ");
    print_3d_vector(&h3_result);
    println!("H3 = h3 ? {}", h3_result == h3);
    println!();

    let f3_result = deconvolution_3d(&g3, &h3);
    print!("deconvolution3D(g3, h3) = ");
    print_3d_vector(&f3_result);
    println!("F3 = f3 ? {}", f3_result == f3);
}
