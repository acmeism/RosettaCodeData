comp:{(#x)>(#y)}
a:"aaa"
b:"ab"
comp[a;b]
length:{ (" the string " ,x, " has size ", ($#x), " the string " ,y, " has size " , ($#y))}
// if prints a first if a is longer
{$[comp[x;y];length[a;b];length[b;a]]}[a;b]
// extra credit
// just take each length and sort an array as usual
c:("abcd"; "123456789"; "abcdef"; "1234567")
c[<#'c]
