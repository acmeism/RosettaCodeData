string input = "gHHH5YY++///\\"; // \ needs escaping
string last_char;
foreach(input/1, string char) {
    if(last_char && char != last_char)
        write(", ");
    write(char);
    last_char = char;
}
