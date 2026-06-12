import std/[algorithm, sequtils]

let wordList = ["Rosetta", "Code", "is", "a", "programming", "chrestomathy", "site"]

echo wordList.mapIt((value: it, length: it.len)).sortedByIt(it.length).mapIt(it.value)
