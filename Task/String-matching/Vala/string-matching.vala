void main() {
    var text = "一二三四五六七八九十";
    var starts = "一二";
    var ends = "九十";
    var contains = "五六";
    var not_contain = "百";

    stdout.printf(@"text: $text\n\n", );
    stdout.printf(@"starts with $starts: $(text.has_prefix(starts))\n");
    stdout.printf(@"ends with $ends: $(text.has_suffix(ends))\n");
    stdout.printf(@"starts with $starts: $(text.has_suffix(starts))\n");
    stdout.printf(@"contains $contains: $(contains in text)\n");
    stdout.printf(@"contains $not_contain: $(contains in text)\n");
}
