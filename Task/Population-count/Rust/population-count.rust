fn main() {
    let mut num = 1u64;
    let mut vec = Vec::new();
    for _ in 0..30 {
        vec.push(num.count_ones());
        num *= 3;
    }
    println!("pop count of 3^0, 3^1 ... 3^29:\n{:?}",vec);
    let mut even = Vec::new();
    let mut odd  = Vec::new();
    num = 1;
    while even.len() < 30 || odd.len() < 30 {
        match 0 == num.count_ones()%2 {
            true if even.len() < 30 => even.push(num),
            false if odd.len() < 30 => odd.push(num),
            _                       => {}
        }
        num += 1;
    }
    println!("\nFirst 30 even pop count:\n{:?}",even);
    println!("\nFirst 30 odd pop count:\n{:?}",odd);
}
