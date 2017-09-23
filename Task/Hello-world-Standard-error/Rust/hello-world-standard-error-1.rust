fn main() {
    use ::std::io::Write;
    let (stderr, errmsg) = (&mut ::std::io::stderr(), "Error writing to stderr");
    writeln!(stderr, "Bye, world!").expect(errmsg);

    let (goodbye, world) = ("Goodbye", "world");
    writeln!(stderr, "{}, {}!", goodbye, world).expect(errmsg);
}
