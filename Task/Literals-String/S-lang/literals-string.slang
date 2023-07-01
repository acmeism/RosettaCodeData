% String literals
variable c, ch, s, b, r, v;

c = 'A';
ch = '\x{1d7bc}';

printf("Double quotes\n");
s = "this is a single line string with\t\tbackslash substitutions";
() = fputs(s, stdout);
() = fputs("\n", stdout);

s = "this is a single line string without\t\tbackslash substitutions"R;
() = fputs(s, stdout);
() = fputs("\n", stdout);

s = "string with backslash escaped newline \
takes up two lines in source, but no newline is in the string";
() = fputs(s, stdout);
() = fputs("\n", stdout);

printf("\nBack quotes\n");
r = `this is a multi line string with
  backslash substitutions and \t(tabs)\t`Q;
() = fputs(r, stdout);
() = fputs("\n", stdout);

r = `this is a multi line string without
  backslash substitutions and \t(tabs)\t`;
() = fputs(r, stdout);
() = fputs("\n", stdout);

printf("\nvariable substitution\n");
v = "variable substitution with $$c as $c"$;
() = fputs(v, stdout);
() = fputs("\n", stdout);

v = "no variable substitutions, $$c as $c";
() = fputs(v, stdout);
() = fputs("\n", stdout);

printf("\nBString_Type\n");
b = "this is a binary string, NUL \0 \0 bytes allowed"B;
print(b);
% display of b will be stopped at the NUL byte using stdio streams
() = fputs(b, stdout);
() = fputs("\n", stdout);
printf("strlen(b) is %d, bstrlen(b) is %d\n", strlen(b), bstrlen(b));
