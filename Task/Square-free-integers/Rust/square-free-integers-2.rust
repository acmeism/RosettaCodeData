fn square_free(x: usize) -> bool {
    fn iter(x: usize, start: usize, prev: usize) -> bool {
        let limit = (x as f64).sqrt().ceil() as usize;
        match (start..=limit).skip_while(|i| x % i > 0).next() {
            Some(v) => if v == prev {false}
                       else {iter(x / v, v, v)},
            None => x != prev
        }
    }
    iter(x, 2, 0)
}

fn main() {
    for (up, to, nl_limit) in vec!((1, 145, 20), (1000000000000, 1000000000145, 6)) {
        let free_nums = (up..=to).into_iter().filter(|&sf| square_free(sf));
        println!("square_free numbers between {} and {}:", up, to);
        for (index, free_num) in free_nums.enumerate() {
            let spnl = if (index + 1) % nl_limit > 0 {' '} else {'\n'};
            print!("{:3}{}", free_num, spnl)
        }
        println!("\n");
    }

    for limit in (2..7).map(|e| 10usize.pow(e)) {
        let start = std::time::Instant::now();
        let number = (1..=limit).into_iter().filter(|&sf| square_free(sf)).count();
        let duration = start.elapsed().as_millis();
        println!("Number of square-free numbers between 1 and {:7}: {:6} [time(ms) {:5}]",
                    limit, number, duration)
    }
}
