// © 2025
fn squares() -> impl Iterator <Item = u32> {
    (1..).map(|num| num * num)
}

fn start_squares() -> impl Iterator <Item = u32> {
    (1..).map(|num| squares()
        .skip_while(|&sqr| !select_eq(sqr, num))
        .next().unwrap()
    )
}

fn select_eq(sqr: u32, num: u32) -> bool {
    if sqr > num {select_eq(sqr / 10, num)}
    else {sqr == num}
}

fn main() {
    let start = std::time::Instant::now();
    let limit = 50;
    let list: Vec<u32> = start_squares().take(limit).collect();
    list.chunks(10)
        .for_each(|grp| {
            let str: Vec<String> = grp.iter()
                .map(|&s| format!("{s:5}"))
                .collect();
            println!("{}", str.join(" "))
        });
    let duration = start.elapsed().as_micros();
    println!("time elapsed(µs): {}", duration);
 }
