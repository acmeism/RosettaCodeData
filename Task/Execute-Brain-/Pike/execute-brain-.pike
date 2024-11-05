string prog = "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.";

void main() {
    array tape = allocate(30000);
    int p;
    int l = strlen(prog);
    for (int i = 0; i < l; i++) {
        switch (prog[i]) {
        case '>':
            p++;
            break;
        case '<':
            p--;
            break;
        case '+':
            tape[p]++;
            break;
        case '-':
            tape[p]--;
            break;
        case '.':
            write(sprintf("%c", tape[p])); // ascii only
            break;
        case ',':
            tape[p] = Stdio.stdin.getchar();
            break;
        case '[':
            if (!tape[p])
                for (int nest = 1; nest;)
                    prog[--i] == ']' ? nest-- : prog[i] == '[' ? nest++ : 0;
                        break;
        case ']':
            if (tape[p])
                for (int nest = 1; nest;)
                    prog[--i] == '[' ? nest-- : prog[i] == ']' ? nest++ : 0;
                        break;
        }
    }
}
