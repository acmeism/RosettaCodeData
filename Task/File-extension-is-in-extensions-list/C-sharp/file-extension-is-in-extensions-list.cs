List<string> extensions = ["zip", "rar", "7z", "gz", "archive", "A##", "tar.bz2", ];

List<string> tests = [
    "MyData.a##",
    "MyData.tar.Gz",
    "MyData.gzip",
    "MyData.7z.backup",
    "MyData...",
    "MyData",
    "MyData_v1.0.tar.bz2",
    "MyData_v1.0.bz2",
    ];

foreach (var filename in tests)
{
    Console.WriteLine($"{filename,20}  {IsInList(filename, extensions)}");
}

static bool IsInList(string filename, List<string> extensions) =>
    extensions.Any(e => filename.ToLowerInvariant().EndsWith("." + e.ToLowerInvariant()));
