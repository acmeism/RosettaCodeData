package main

func init() {
    testSet = []testCase{
        {
`# This rules file is extracted from Wikipedia:
# http://en.wikipedia.org/wiki/Markov_Algorithm
A -> apple
B -> bag
S -> shop
T -> the
the shop -> my brother
a never used -> .terminating rule`,
            "I bought a B of As from T S.",
            "I bought a bag of apples from my brother."},
        {
`# Slightly modified from the rules on Wikipedia
A -> apple
B -> bag
...
