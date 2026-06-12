import "./pattern" for Pattern
import "./fmt" for Fmt

var p = Pattern.new("/W") // matches any non-alphanumeric character

var extractFileExtension = Fn.new { |path|
    if (path.isEmpty) return ""
    var fileName = path.split("/")[-1]
    if (path == fileName) fileName = path.split("\\")[-1]
    var splits = fileName.split(".")
    if (splits.count == 1) return ""
    var ext = splits[-1]
    return p.isMatch(ext) ? "" : "." + ext
}

var paths = [
    "http://example.com/download.tar.gz",
    "CharacterModel.3DS",
    ".desktop",
    "document",
    "document.txt_backup",
    "/etc/pam.d/login",
    "c:\\programs\\myprogs\\myprog.exe",          // using back-slash as delimiter
    "c:\\programs\\myprogs\\myprog.exe_backup"    // ditto
]
for (path in paths) {
    var ext =  extractFileExtension.call(path)
    Fmt.print("$-37s -> $s", path, ext.isEmpty ? "(empty string)" : ext)
}
