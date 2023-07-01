puts "Simple incrementer"
puts TAPE=[turing {q0 qf} q0 qf {1 B} B "111" {
    {q0 1 1 right q0}
    {q0 B 1 stay qf}
}]
puts "Three-state busy beaver"
puts TAPE=[turing {a b c halt} a halt {0 1} 0 "" {
    {a 0 1 right b}
    {a 1 1 left c}
    {b 0 1 left a}
    {b 1 1 right b}
    {c 0 1 left b}
    {c 1 1 stay halt}
}]
puts "Sorting stress test"
# We suppress the trace output for this so as to keep the output short
puts TAPE=[turing {A B C D E H} A H {0 1 2 3} 0 "12212212121212" {
    {A 1 1 right A}
    {A 2 3 right B}
    {A 0 0 left E}
    {B 1 1 right B}
    {B 2 2 right B}
    {B 0 0 left C}
    {C 1 2 left D}
    {C 2 2 left C}
    {C 3 2 left E}
    {D 1 1 left D}
    {D 2 2 left D}
    {D 3 1 right A}
    {E 1 1 left E}
    {E 0 0 right H}
} no]
