int main (string[] args) {
    string[] files = {"input.txt", "docs", Path.DIR_SEPARATOR_S + "input.txt", Path.DIR_SEPARATOR_S + "docs"};
    foreach (var f in files) {
        var file = File.new_for_path (f);
        var exists = file.query_exists ();
        var name = "";
        if (!exists) {
            print ("%s does not exist\n", f);
        } else {
            var type = file.query_file_type (FileQueryInfoFlags.NOFOLLOW_SYMLINKS);
            if (type == 1) {
                name = "file";
            } else if (type == 2) {
                name = "directory";
            }
            print ("%s %s exists\n", name, f);
        }
    }
    return 0;
}
