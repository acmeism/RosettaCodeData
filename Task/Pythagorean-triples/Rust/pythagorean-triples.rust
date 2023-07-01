use std::thread;

fn f1 (a : u64, b : u64, c : u64, d : u64) -> u64 {
    let mut primitive_count = 0;
    for triangle in [[a - 2*b + 2*c, 2*a - b + 2*c, 2*a - 2*b + 3*c],
                     [a + 2*b + 2*c, 2*a + b + 2*c, 2*a + 2*b + 3*c],
                     [2*b + 2*c - a, b + 2*c - 2*a, 2*b + 3*c - 2*a]] .iter() {
        let l  = triangle[0] + triangle[1] + triangle[2];
        if l > d { continue; }
        primitive_count +=  1 + f1(triangle[0], triangle[1], triangle[2], d);
    }
    primitive_count
}

fn f2 (a : u64, b : u64, c : u64, d : u64) -> u64 {
    let mut triplet_count = 0;
    for triangle in [[a - 2*b + 2*c, 2*a - b + 2*c, 2*a - 2*b + 3*c],
                     [a + 2*b + 2*c, 2*a + b + 2*c, 2*a + 2*b + 3*c],
                     [2*b + 2*c - a, b + 2*c - 2*a, 2*b + 3*c - 2*a]] .iter() {
        let l  = triangle[0] + triangle[1] + triangle[2];
        if l > d { continue; }
        triplet_count +=  (d/l) + f2(triangle[0], triangle[1], triangle[2], d);
    }
    triplet_count
}

fn main () {
    let new_th_1 = thread::Builder::new().stack_size(32 * 1024 * 1024).spawn (move || {
        let mut i = 100;
        while i <= 100_000_000_000 {
            println!(" Primitive triples below {} : {}", i, f1(3, 4, 5, i) + 1);
            i *= 10;
        }
    }).unwrap();

    let new_th_2 =thread::Builder::new().stack_size(32 * 1024 * 1024).spawn (move || {
        let mut i = 100;
        while i <= 100_000_000_000 {
            println!(" Triples below {} : {}", i, f2(3, 4, 5, i) + i/12);
            i *= 10;
        }
    }).unwrap();

    new_th_1.join().unwrap();
    new_th_2.join().unwrap();
}
