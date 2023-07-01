static void println(string str) {
    stdout.printf("%s\r\n", str);
}

static unichar encrypt_char(unichar ch, int code) {
    if (!ch.isalpha()) return ch;

    unichar offset = ch.isupper() ? 'A' : 'a';
    return (unichar)((ch + code - offset) % 26 + offset);
}

static string encrypt(string input, int code) {
    var builder = new StringBuilder();

    unichar c;
    for (int i = 0; input.get_next_char(ref i, out c);) {
        builder.append_unichar(encrypt_char(c, code));
    }

    return builder.str;
}

static string decrypt(string input, int code) {
    return encrypt(input, 26 - code);
}

const string test_case = "The quick brown fox jumped over the lazy dog";

void main() {
    println(test_case);
    println(encrypt(test_case, -1));
    println(decrypt(encrypt(test_case, -1), -1));
}
