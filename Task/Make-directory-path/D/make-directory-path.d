import std.stdio;

void main() {
    makeDir("parent/test");
}

/// Manual implementation of what mkdirRecurse in std.file does.
void makeDir(string path) out {
    import std.exception : enforce;
    import std.file : exists;
    enforce(path.exists, "Failed to create the requested directory.");
} body {
    import std.array : array;
    import std.file;
    import std.path : pathSplitter, chainPath;

    auto workdir = "";
    foreach (dir; path.pathSplitter) {
        workdir = chainPath(workdir, dir).array;
        if (workdir.exists) {
            if (!workdir.isDir) {
                import std.conv : text;
                throw new FileException(text("The file ", workdir, " in the path ", path, " is not a directory."));
            }
        } else {
            workdir.mkdir();
        }
    }
}
