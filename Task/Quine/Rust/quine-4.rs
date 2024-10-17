fn main() {
    macro_rules! script {() => {"fn main() {{\n\tmacro_rules! script {{() => {{{:?}}}}}\n\tprintln!(script!(), script!());\n}}"}}
    println!(script!(), script!());
}
