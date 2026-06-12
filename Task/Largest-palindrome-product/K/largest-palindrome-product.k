max:{x[> x][0]} // maximum of a vector
palindrome: {($x) ~ |($x)} // checks if palindrome $x casts x to string,|x reverses x,~ matches
// only check from 900 to 999, makes no sense to check lower numbers
// since their products can only be smaller
"n=2"
// n=2
ans: ,//{(90_!100)*x}'(90_!100) // multiply all numbers and flatten to vector
max (?ans [&palindrome' ans]) // check for palindrome and take maximum
// n=3
"n=3"
ans: ,//{(900_!1000)*x}'(900_!1000)
max (?ans [&palindrome' ans])
// n=4
"n=4"
ans: ,//{(9000_!10000)*x}'(9000_!10000)
max (?ans [&palindrome' ans])
// n=5
"n=5"
ans: ,//{(90000_!100000)*x}'(90000_!100000)
max (?ans [&palindrome' ans])
// n=6
"n=6"
ans: ,//{(900000_!1000000)*x}'(900000_!1000000)
max (?ans [&palindrome' ans])
