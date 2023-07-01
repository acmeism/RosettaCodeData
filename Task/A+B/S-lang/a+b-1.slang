% A+B from stdin, sans error checking
variable input, a, b;

() = fgets(&input, stdin);
input = strtrim_end(input, "\n");
() = sscanf(input, "%d%d", &a, &b);
print(a + b);
