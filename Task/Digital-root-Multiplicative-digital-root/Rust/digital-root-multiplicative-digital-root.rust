// Multiplicative digital root
fn mdroot(n: u32) -> (u32, u32) {
    let mut count = 0;
    let mut mdr = n;
    while mdr > 9 {
        let mut m = mdr;
        let mut digits_mul = 1;
        while m > 0 {
            digits_mul *= m % 10;
            m /= 10;
        }
        mdr = digits_mul;
        count += 1;
    }
    return (count, mdr);
}

fn main() {
    println!("Number: (MP, MDR)\n======  =========");
    for n in [123321, 7739, 893, 899998] {
        println!("{:6}: {:?}", n, mdroot(n));
    }
    let mut table = vec![vec![0_u32; 0]; 10];
    let mut n = 0;
    while table.iter().map(|row| row.len()).min().unwrap() < 5 {
        let (_, mdr) = mdroot(n);
        table[mdr as usize].push(n);
        n += 1;
    }
    println!("\nMDR     First 5 with matching MDR\n===     =========================");
    table.sort();
    for a in table {
        println!("{:2}: {:5}{:6}{:6}{:6}{:6}", a[0], a[0], a[1], a[2], a[3], a[4]);
    }
}
