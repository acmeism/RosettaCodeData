% A+B from stdin, basic validity testing
variable input, a, b, rc;

() = fgets(&input, stdin);
input = strtrim_end(input, "\n");
rc = sscanf(input, "%d%d", &a, &b);
if ((rc == 2) && (a >= -1000) && (a <= 1000) && (b >= -1000) && (b <= 1000)) {
   print(a + b);
} else {
   message("input invalid or out of range (-1000,1000): $input"$);
}
