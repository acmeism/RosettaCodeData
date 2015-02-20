var file, str;
file = file_text_open_read("input.txt");
str = "";
while (!file_text_eof(file))
    {
    str += file_text_read_string(file);
    if (!file_text_eof(file))
        {
        str += "
"; //It is important to note that a linebreak is actually inserted here rather than a character code of some kind
        file_text_readln(file);
        }
    }
file_text_close(file);

file = file_text_open_write("output.txt");
file_text_write_string(file,str);
file_text_close(file);
