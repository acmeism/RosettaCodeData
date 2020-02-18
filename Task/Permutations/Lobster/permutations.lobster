// Lobster implementation of the (very fast) Go example
// http://rosettacode.org/wiki/Permutations#Go
// implementing the plain changes (bell ringers) algorithm, using a recursive function
// https://en.wikipedia.org/wiki/Steinhaus–Johnson–Trotter_algorithm

def permr(s, f):
    if s.length == 0:
        f(s)
        return
    def rc(np: int):
        if np == 1:
            f(s)
            return
        let np1 = np - 1
        let pp = s.length - np1
        rc(np1) // recurs prior swaps
        var i = pp
        while i > 0:
            // swap s[i], s[i-1]
            let t = s[i]
            s[i] = s[i-1]
            s[i-1] = t
            rc(np1) // recurs swap
            i -= 1
        let w = s[0]
        for(pp): s[_] = s[_+1]
        s[pp] = w
    rc(s.length)

// Heap's recursive method https://en.wikipedia.org/wiki/Heap%27s_algorithm

def permh(s, f):
    def rc(k: int):
        if k <= 1:
            f(s)
        else:
            // Generate permutations with kth unaltered
            // Initially k == length(s)
            rc(k-1)
            // Generate permutations for kth swapped with each k-1 initial
            for(k-1) i:
                // Swap choice dependent on parity of k (even or odd)
                 // zero-indexed, the kth is at k-1
                if (k & 1) == 0:
                    let t = s[i]
                    s[i] = s[k-1]
                    s[k-1] = t
                else:
                    let t = s[0]
                    s[0] = s[k-1]
                    s[k-1] = t
                rc(k-1)
    rc(s.length)

// iterative Boothroyd method

import std

def permi(xs, f):
    var d = 1
    let c = map(xs.length): 0
    f(xs)
    while true:
        while d > 1:
            d -= 1
            c[d] = 0
        while c[d] >= d:
            d += 1
            if d >= xs.length:
                return
        let i = if (d & 1) == 1: c[d] else: 0
        let t = xs[i]
        xs[i] = xs[d]
        xs[d] = t
        f(xs)
        c[d] = c[d] + 1

// next lexicographical permutation
// to get all permutations the initial input `a` must be in sorted order
// returns false when input `a` is in reverse sorted order

def next_lex_perm(a):
    def swap(i, j):
        let t = a[i]
        a[i] = a[j]
        a[j] = t
    let n = a.length
    /* 1. Find the largest index k such that a[k] < a[k + 1]. If no such
          index exists, the permutation is the last permutation. */
    var k = n - 1
    while k > 0 and a[k-1] >= a[k]: k--
    if k == 0: return false
    k -= 1
    /* 2. Find the largest index l such that a[k] < a[l]. Since k + 1 is
       such an index, l is well defined */
    var l = n - 1
    while a[l] <= a[k]: l--
    /* 3. Swap a[k] with a[l] */
    swap(k, l)
    /* 4. Reverse the sequence from a[k + 1] to the end */
    k += 1
    l = n - 1
    while l > k:
        swap(k, l)
        l -= 1
        k += 1
    return true

var se = [0, 1, 2, 3] //, 4, 5, 6, 7, 8, 9, 10]

print "Iterative lexicographical permuter"

print se
while next_lex_perm(se): print se

print "Recursive plain changes iterator"

se = [0, 1, 2, 3]

permr(se): print(_)

print "Recursive Heap\'s iterator"

se = [0, 1, 2, 3]

permh(se): print(_)

print "Iterative Boothroyd iterator"

se = [0, 1, 2, 3]

permi(se): print(_)
