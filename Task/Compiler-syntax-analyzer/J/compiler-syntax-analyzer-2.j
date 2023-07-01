primes=: {{)n
/*
 Simple prime number generator
 */
count = 1;
n = 1;
limit = 100;
while (n < limit) {
    k=3;
    p=1;
    n=n+2;
    while ((k*k<=n) && (p)) {
        p=n/k*k!=n;
        k=k+2;
    }
    if (p) {
        print(n, " is prime\n");
        count = count + 1;
    }
}
print("Total primes found: ", count, "\n");
}}

   syntax lex primes
Sequence
Sequence
Sequence
Sequence
Sequence
;
Assign
Identifier count
Integer 1
Assign
Identifier n
Integer 1
Assign
Identifier limit
Integer 100
While
Less
Identifier n
Identifier limit
Sequence
Sequence
Sequence
Sequence
Sequence
;
Assign
Identifier k
Integer 3
Assign
Identifier p
Integer 1
Assign
Identifier n
Add
Identifier n
Integer 2
While
And
LessEqual
Multiply
Identifier k
Identifier k
Identifier n
Identifier p
Sequence
Sequence
;
Assign
Identifier p
NotEqual
Divide
Identifier n
Multiply
Identifier k
Identifier k
Identifier n
Assign
Identifier k
Add
Identifier k
Integer 2
If
Identifier p
If
Sequence
Sequence
;
Sequence
Sequence
;
Prti
Identifier n
;
Prts
String " is prime\n"
;
Assign
Identifier count
Add
Identifier count
Integer 1
;
Sequence
Sequence
Sequence
;
Prts
String "Total primes found: "
;
Prti
Identifier count
;
Prts
String "\n"
;
