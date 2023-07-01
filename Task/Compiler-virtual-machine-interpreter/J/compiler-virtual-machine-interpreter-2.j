count=:{{)n
count = 1;
while (count < 10) {
    print("count is: ", count, "\n");
    count = count + 1;
}
}}

   run_vm gen syntax lex count
count is: 1
count is: 2
count is: 3
count is: 4
count is: 5
count is: 6
count is: 7
count is: 8
count is: 9
