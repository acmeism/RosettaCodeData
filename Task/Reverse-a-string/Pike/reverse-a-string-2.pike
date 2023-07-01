#charset utf8
void main()
{
    string s = "ßÜÖÄüöää ἀρχῇ";
    write("%s\n", string_to_utf8( reverse(s) ));
}
