const (
extensions = [".zip", ".rar", ".7z", ".gz", ".archive", ".a##", ".tar.bz2"]
filenames = ["MyData.a##", "MyData.tar.gz", "MyData.gzip", "MyData.7z.backup",
                   "MyData...", "MyData", "MyData_v1.0.tar.bz2", "MyData_v1.0.bz2"]
)

fn main() {
	outer:
	for oidx, file in filenames {
		for idx, extension in extensions {
			if file.substr_ni(file.len - extension.len, file.len) == extension {
				println("${filenames[oidx]} -> ${extensions[idx]} -> true")
				continue outer
			}
		}
		println("${filenames[oidx]} -> false")
	}
}
