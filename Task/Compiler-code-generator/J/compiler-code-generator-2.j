count=:{{)n
count = 1;
while (count < 10) {
    print("count is: ", count, "\n");
    count = count + 1;
}
}}

   gen syntax lex count
Datasize: 1 Strings: 2
"count is: "
"\n"
    0 push  1
    5 store [0]
   10 fetch [0]
   15 push  10
   20 lt
   21 jz    (43) 65
   26 push  0
   31 prts
   32 fetch [0]
   37 prti
   38 push  1
   43 prts
   44 fetch [0]
   49 push  1
   54 add
   55 store [0]
   60 jmp    (-51) 10
   65 halt
