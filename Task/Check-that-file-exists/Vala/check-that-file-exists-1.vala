int main (string[] args) {
    string[] files = {"input.txt", "docs", Path.DIR_SEPARATOR_S + "input.txt", Path.DIR_SEPARATOR_S + "docs"};
    foreach (string f in files) {
        var file = File.new_for_path (f);
        print ("%s exists: %s\n", f, file.query_exists ().to_string ());
    }
    return 0;
}
