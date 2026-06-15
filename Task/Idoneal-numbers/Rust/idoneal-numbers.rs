fn idoneals(limit: u32) -> impl Iterator<Item = u32> {
    (1 ..= limit).into_iter()
        .filter(|&n| (1 ..= n).into_iter()
            .all(|a| (a + 1 ..= n).into_iter()
                .take_while(|b| a * b + a + b < n)
                .all(|b| (a * b + (b + 1) * (a + b) ..)
                    .step_by((a + b) as usize)
                    .skip_while(|&s| s < n)
                    .next().unwrap() > n
                )
            )
        )
}

fn main() {
    idoneals(2_000).collect::<Vec<u32>>()
        .chunks(15).for_each(|grp|
            println!("{}", grp.iter().map(|n|format!("{:>4}", n))
                .collect::<Vec<String>>()
                .join(" ")
            )
        )
} // © 2026
