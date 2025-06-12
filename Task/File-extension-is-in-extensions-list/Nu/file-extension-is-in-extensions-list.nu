let exts = ["zip" "rar" "7z" "gz" "archive" "A##" "tar.bz2"]
let filenames = [
    "MyData.a##"
    "MyData.tar.Gz"
    "MyData.gzip"
    "MyData.7z.backup"
    "MyData..."
    "MyData"
    "MyData_v1.0.tar.bz2"
    "MyData_v1.0.bz2"
]

$exts | wrap "extensions"

$filenames | each { |filename|
    let check = ($exts | any { |ext|
        ($filename | str downcase) | str ends-with ("." + ($ext | str downcase))
    })
    $"($filename | fill -w 20 -c ' ') ($check)"
} | print
