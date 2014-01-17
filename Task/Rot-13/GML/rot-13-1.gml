#define rot13
var in, out, i, working;
in = argument0;
out = "";
for (i = 1; i <= string_length(in); i += 1)
    {
    working = ord(string_char_at(in, i));
    if ((working > 64) && (working < 91))
        {
        working += 13;
        if (working > 90)
            {
            working -= 26;
            }
        }
    else if ((working > 96) && (working < 123))
        {
        working += 13;
        if (working > 122) working -= 26;
        }
    out += chr(working);
    }
return out;
