const BARS: &'static str = "▁▂▃▄▅▆▇█";

fn print_sparkline(s: &str){
    let v = BARS.chars().collect::<Vec<char>>();
    let line: String = s.replace(",", " ").split(" ")
                            .filter(|x| !x.is_empty())
                            .map(|x| v[x.parse::<f64>().unwrap().ceil() as usize - 1])
                            .collect();
    println!("{:?}", line);
}

fn main(){
    let s1 = "1 2 3 4 5 6 7 8 7 6 5 4 3 2 1";
    print_sparkline(s1);
    let s2 = "1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5";
    print_sparkline(s2);
}
