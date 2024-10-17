fn main() {
    let exts = ["zip", "rar", "7z", "gz", "archive", "A##", "tar.bz2"];
    let filenames = [
        "MyData.a##",
        "MyData.tar.Gz",
        "MyData.gzip",
        "MyData.7z.backup",
        "MyData...",
        "MyData",
        "MyData_v1.0.tar.bz2",
        "MyData_v1.0.bz2",
    ];

    println!("extenstions: {:?}\n", exts);

    for filename in filenames.iter() {
        let check = exts.iter().any(|ext| {
            filename
                .to_lowercase()
                .ends_with(&format!(".{}", ext.to_lowercase()))
        });
        println!("{:20} {}", filename, check);
    }
}
