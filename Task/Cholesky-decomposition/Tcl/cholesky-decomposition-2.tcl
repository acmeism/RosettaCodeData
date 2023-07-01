set test1 {
    {25 15 -5}
    {15 18  0}
    {-5  0 11}
}
puts [cholesky $test1]
set test2 {
    {18 22  54  42}
    {22 70  86  62}
    {54 86 174 134}
    {42 62 134 106}
}
puts [cholesky $test2]
