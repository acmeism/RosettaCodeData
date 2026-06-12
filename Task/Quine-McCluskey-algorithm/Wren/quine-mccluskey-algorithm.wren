/*
Copyright (c) 2005 Robert Dick <dickrp@ece.northwestern.edu>.
All rights reserved.

1. This LICENSE AGREEMENT is between Robert Dick ("AUTHOR"), and the
Individual or Organization ("Licensee") accessing and otherwise using this
software in source or binary form and its associated documentation.

2. Subject to the terms and conditions of this License Agreement, AUTHOR
hereby grants Licensee a nonexclusive, royalty-free, world-wide license to
reproduce, analyze, test, perform and/or display publicly, prepare derivative
works, distribute, and otherwise use this software alone or in any derivative
version, provided, however, that AUTHOR's License Agreement and AUTHOR's
notice of copyright, i.e., "Copyright (c) 2005 Robert Dick; All Rights
Reserved" are retained with this software, alone, or in any derivative
version prepared by Licensee.

3. In the event Licensee prepares a derivative work that is based on or
incorporates this software or any part thereof, and wants to make the
derivative work available to others as provided herein, then Licensee hereby
agrees to include in any such work a brief summary of the changes made to
this work.

4. AUTHOR is making this software available to Licensee on an "AS IS" basis.
AUTHOR MAKES NO REPRESENTATIONS OR WARRANTIES, EXPRESS OR IMPLIED.  BY WAY OF
EXAMPLE, BUT NOT LIMITATION, AUTHOR MAKES NO AND DISCLAIMS ANY REPRESENTATION
OR WARRANTY OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE OR THAT
THE USE OF THIS SOFTWARE WILL NOT INFRINGE ANY THIRD PARTY RIGHTS.

5. AUTHOR SHALL NOT BE LIABLE TO LICENSEE OR ANY OTHER USERS OF THIS SOFTWARE
FOR ANY INCIDENTAL, SPECIAL, OR CONSEQUENTIAL DAMAGES OR LOSS AS A RESULT OF
MODIFYING, DISTRIBUTING, OR OTHERWISE USING THIS SOFTWARE, OR ANY DERIVATIVE
THEREOF, EVEN IF ADVISED OF THE POSSIBILITY THEREOF.

6. This License Agreement will automatically terminate upon a material breach
of its terms and conditions.

7. Nothing in this License Agreement shall be deemed to create any
relationship of agency, partnership, or joint venture between AUTHOR and
Licensee.  This License Agreement does not grant permission to use AUTHOR
trademarks or trade name in a trademark sense to endorse or promote products
or services of Licensee, or any third party.

8. By copying, installing or otherwise using this software, Licensee agrees
to be bound by the terms and conditions of this License Agreement.
*/

import "./math" for Math, Nums
import "./set" for Set

// Convert from an integer to a binary string.
var b2s = Fn.new { |i, vars|
	var s = ""
    var t = ["0", "1"]
	for (k in 0...vars) {
		s = t[i & 1] + s
		i = i >> 1
    }
	return s
}

// Return the sum of on bits in s.
var bitCount = Fn.new { |s| s.count { |b| b == "1" } }

// Return cube merge. 'X' is don't-care. 'null' if merge impossible.
var merge = Fn.new { |i, j|
	var s = ""
	var difCnt = 0
    var lower = Math.min(i.count, j.count)
    for (k in 0...lower) {
        var a = i[k]
        var b = j[k]
		if ((a == "X" || b == "X") && a != b) {
			return null
        } else if (a != b) {
			difCnt = difCnt + 1
			s = s + "X"
		} else {
			s = s + a
        }
		if (difCnt > 1) return null
	}
	return s
}

// Compute primes for the given set of cubes and variable count.
var computePrimes = Fn.new { |cubes, vars|
    var sigma = []
    for (v in 0..vars) {
        var t1 = Set.new()
        for (i in cubes) if (bitCount.call(i) == v) t1.add(i)
        sigma.add(t1)
    }

	var primes = Set.new()
	while (sigma.count > 0) {
		var nsigma = []
		var redundant = Set.new()
        for (i in 0...sigma.count-1) {
            var c1 = sigma[i]
            var c2 = sigma[i+1]
			var nc = Set.new()
			for (a in c1) {
				for (b in c2) {
					var m = merge.call(a, b)
					if (m) {
						nc.add(m)
                        var t2 = Set.new()
                        t2.add(a)
                        t2.add(b)
                        redundant = redundant.union(t2)
                    }
                }
            }
			nsigma.add(nc)
        }
        var t3 = Set.new()
        for (cubes in sigma) {
            for (c in cubes) {
                t3.add(c)
            }
        }
        t3 = t3.except(redundant)
        primes = primes.union(t3)
        sigma = nsigma
    }
    return primes
}

// Return the primes selected by the cube selection integer.
var activePrimes = Fn.new { |cubesel, primes|
    var res = []
    var s = b2s.call(cubesel, primes.count)
    for (i in 0...primes.count) {
        if (s[i] == "1") res.add(primes[i])
    }
    return res
}

// Returns a bool: Does the prime cover the minterm?
var isCover = Fn.new { |prime, one|
    var lower = Math.min(prime.count, one.count)
    for (i in 0...lower) {
        var p = prime[i]
        var o = one[i]
        if (p != "X" && p != o) return false
    }
    return true
}

// Returns a bool: Does the set of primes cover all minterms?
var isFullCover = Fn.new { |allPrimes, ones|
    for (o in ones) {
        var res = []
        for (p in allPrimes) {
            res.add(isCover.call(p, o))
        }
        if (!res.contains(true)) return false
    }
    return true
}

// Return the minimal cardinality subset of primes covering all ones.
var unateCover = Fn.new { |primes, ones|
	primes = primes.toList
    var min = [Num.infinity, Num.infinity]
    for (cubesel in 0...(1 << primes.count)) {
        if (isFullCover.call(activePrimes.call(cubesel, primes), ones)) {
            var t = [bitCount.call(b2s.call(cubesel, primes.count)), cubesel]
            if (t[0] < min[0]) min = t
        }
    }
    var cs = min[1]
    return activePrimes.call(cs, primes)
}

/*	Compute minimal two-level sum-of-products form.
	Arguments are:
		ones:   list of integer minterms
		zeros:  list of integer maxterms
		dc:     list of integers specifying don't-care terms

	For proper operation, either (or both) the 'ones' and 'zeros'
	parameters must be specified.  If one of these parameters is not
	specified, it will be computed from the combination of the other
	parameter and the optional 'dc' parameter.

	The fiber will be aborted if any terms are specified
	in more than one argument, or if all three arguments are given
	and not all terms are specified. */
var qm  = Fn.new { |ones, zeros, dc|
    var m1 = Nums.max(ones.count > 0 ? ones : zeros.count > 0 ? zeros : dc)
    var m2 = Nums.max(zeros.count > 0 ? zeros : dc.count > 0 ? dc : ones)
    var m3 = Nums.max(dc.count > 0 ? dc : ones.count > 0 ? ones : zeros)
    var elts = Nums.max([m1, m2, m3]) + 1
	var numvars = elts.log2.ceil
	elts = 1 << numvars
    var all = Set.new()
    for (i in 0...elts) all.add(b2s.call(i, numvars))
    ones  = Set.new(ones.map  { |o| b2s.call(o, numvars) })
    zeros = Set.new(zeros.map { |z| b2s.call(z, numvars) })
    dc    = Set.new(dc.map    { |d| b2s.call(d, numvars) })
	ones  = ones.count > 0 ? ones : all.except(zeros).except(dc)
	zeros = zeros.count > 0 ? zeros : all.except(ones).except(dc)
	dc    = dc.count > 0 ? dc : all.except(ones).except(zeros)

    var l = dc.union(zeros).union(ones).count
	if (dc.count + zeros.count + ones.count != l || l != elts) {
        Fiber.abort("Something went wrong.")
    }
	var primes = computePrimes.call(ones.union(dc), numvars)
	return unateCover.call(primes, ones)
}

System.print(qm.call([1, 2, 5], [], [0, 7]))
