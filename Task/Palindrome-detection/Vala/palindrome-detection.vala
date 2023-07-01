bool is_palindrome (string str) {
    var tmp = str.casefold ().replace (" ", "");
    return tmp == tmp.reverse ();
}

int main (string[] args) {
    print (is_palindrome (args[1]).to_string () + "\n");
    return 0;
}
