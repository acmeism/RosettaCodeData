import "./math" for Int
import "./fmt" for Fmt

var c = Int.primeSieve(5505, false)
var triples = []
System.print("Prime triplets: p, p + 2, p + 6 where p < 5,500:")
var i = 3
while (i < 5500) {
    if (!c[i] && !c[i+2] && !c[i+6]) triples.add([i, i+2, i+6])
    i = i + 2
}
for (triple in triples) Fmt.print("$,6d", triple)
System.print("\nFound %(triples.count) such prime triplets.")
