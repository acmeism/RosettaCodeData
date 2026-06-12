public static string FindExtension(string filename) {
    int indexOfDot = filename.Length;
    for (int i = filename.Length - 1; i >= 0; i--) {
        char c = filename[i];
        if (c == '.') {
            indexOfDot = i;
            break;
        }
        if (c >= '0' && c <= '9') continue;
        if (c >= 'A' && c <= 'Z') continue;
        if (c >= 'a' && c <= 'z') continue;
        break;
    }
    //The dot must be followed by at least one other character,
    //so if the last character is a dot, return the empty string
    return indexOfDot + 1 == filename.Length ? "" : filename.Substring(indexOfDot);
}
