const x = "const x = |const y = x[0..9]&34.chr&x&34.chr&10.chr&x[11..100]&10.chr&x[102..115]&10.chr&x[117 .. -1]|static: echo y|echo y"
const y = x[0..9]&34.chr&x&34.chr&10.chr&x[11..100]&10.chr&x[102..115]&10.chr&x[117 .. -1]
static: echo y
echo y
