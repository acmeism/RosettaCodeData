fn main() {
    print!("{}", include_str!(concat!(env!("CARGO_MANIFEST_DIR"), "/", file!())));
}
