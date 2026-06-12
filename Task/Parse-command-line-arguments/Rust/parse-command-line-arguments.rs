use structopt::StructOpt;

#[derive(StructOpt)]
struct Opt {
    #[structopt(short)]
    b: bool,
    #[structopt(short, required = false, default_value = "")]
    s: String,
    #[structopt(short, required = false, default_value = "0")]
    n: i32,
}

fn main() {
    let opt = Opt::from_args();
    println!("b: {}", opt.b);
    println!("s: {}", opt.s);
    println!("n: {}", opt.n);
}
