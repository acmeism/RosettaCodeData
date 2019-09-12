# nim implementation of the (very fast) Go example
# http://rosettacode.org/wiki/Permutations#Go
# implementing a recursive https://en.wikipedia.org/wiki/Steinhaus–Johnson–Trotter_algorithm

proc perm( s: openArray[int], emit: proc(emit:openArray[int]) ) =
    var s = @s
    if s.len == 0:
        emit(s)
        return

    var rc : proc(np: int)
    rc = proc(np: int) =

        if np == 1:
            emit(s)
            return

        var
            np1 = np - 1
            pp = s.len - np1

        rc(np1) # recurs prior swaps

        for i in countDown(pp, 1):
            swap s[i], s[i-1]
            rc(np1) # recurs swap

        let w = s[0]
        s[0..<pp] = s[1..pp]
        s[pp] = w

    rc(s.len)

var se = @[0, 1, 2, 3] #, 4, 5, 6, 7, 8, 9, 10]

perm(se, proc(seq: openArray[int])=
    echo seq
    )
