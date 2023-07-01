use std::fs;

fn main() {
    let err = "File move error";
    fs::rename("input.txt", "output.txt").ok().expect(err);
    fs::rename("docs", "mydocs").ok().expect(err);
    fs::rename("/input.txt", "/output.txt").ok().expect(err);
    fs::rename("/docs", "/mydocs").ok().expect(err);
}
