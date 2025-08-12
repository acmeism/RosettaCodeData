fn print_vector(list: &Vec<i32>) {
    print!("[");
    for i in 0..list.len() - 1 {
        print!("{}, ", list[i]);
    }
    println!("{}]", list.last().unwrap());
}

fn deconvolution(a: &Vec<i32>, b: &Vec<i32>) -> Vec<i32> {
    let mut result = vec![0; a.len() - b.len() + 1];
    for n in 0..result.len() {
        result[n] = a[n];
        let start = std::cmp::max(n as i64 - b.len() as i64 + 1, 0) as usize;
        for i in start..n {
            result[n] -= result[i] * b[n - i];
        }
        result[n] /= b[0];
    }
    result
}

fn main() {
    let h: Vec<i32> = vec![-8, -9, -3, -1, -6, 7];
    let f: Vec<i32> = vec![-3, -6, -1, 8, -6, 3, -1, -9, -9, 3, -2, 5, 2, -2, -7, -1];
    let g: Vec<i32> = vec![24, 75, 71, -34, 3, 22, -45, 23, 245, 25, 52,
                           25, -67, -96, 96, 31, 55, 36, 29, -43, -7];

    print!("h =                   ");
    print_vector(&h);

    print!("deconvolution(g, f) = ");
    print_vector(&deconvolution(&g, &f));

    print!("f =                   ");
    print_vector(&f);

    print!("deconvolution(g, h) = ");
    print_vector(&deconvolution(&g, &h));
}
