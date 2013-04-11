#define rot13
{
    out = '';
    for (x = 1; x <= string_length(argument0); x += 1) {
        working = ord(string_char_at(argument0, x));
        if ((working > 64) && (working < 91)) {
            working += 13;
            if (working > 90) working -= 26;
        } else if ((working > 96) && (working < 123)) {
            working += 13;
            if (working > 122) working -= 26;
        }
        out = out + chr(working);
    }
    return out;
}
