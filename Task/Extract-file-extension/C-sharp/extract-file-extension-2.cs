public static string FindExtension(string filename) => Regex.Match(filename, @"\.[A-Za-z0-9]+$").Value;
