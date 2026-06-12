fn is_steady_square(n: u32) -> bool {
    fn iter(n: u32, m: u32) -> u64 {
        if m <= n {iter(n, 10 * m)}
        else {m as u64}
    }
    let nl = n as u64;
    nl * nl % iter(n, 1) == nl
}

fn main() {
    let start = std::time::Instant::now();
    let limit = 10_000_000;
    let list5 = (5..=limit).step_by(10)
                .flat_map(|n|[n, n+1])
                .filter(|&n| is_steady_square(n));
    let list: Vec<u32> = (0..2).into_iter().chain(list5).collect();

    let max = *list.iter().last().unwrap();
    let maxl = max as u64;
    let duration = start.elapsed().as_millis();
    let max_len = max.to_string().len();
    let sqr_len = (maxl*maxl).to_string().len();
    println!("{:>max_len$} {:>sqr_len$}", "num", "square");
    for n in list {
        let nl = n as u64;
        println!("{:max_len$} {:sqr_len$}", n, nl*nl);
    }
    println!("time(ms): {duration}");
 }
