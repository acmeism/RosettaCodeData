// the iterative version is derived from the javascript one here:
(
f = { |a, b|
	var m = a.size;
	var n = a[0].size;
	var p = b.size;
	var q = b[0].size;
	var rtn = m * p;
	var ctn = n * q;
	var res = { 0.dup(ctn) }.dup(rtn);
	m.do { |i|
		n.do { |j|
			p.do { |k|
				q.do { |l|
					res[p*i+k][q*j+l] = a[i][j] * b[k][l];
				}
			}
		}
	};
	res
};
)

// Like APL/J, SuperCollider has applicative operators, so here is a shorter version.
// the idea is to first replace every element of b with its product with all of a
// and then reshape the matrix appropriately
// note that +++ is lamination: [[1, 2, 3], [4, 5, 6]] +++ [100, 200] returns [ [ 1, 2, 3, 100 ], [ 4, 5, 6, 200 ] ].

(
f = { |a, b|
	a.collect { |x|
		x.collect { |y| b * y }.reduce('+++')
	}.reduce('++')
}
)

// or shorter:
(a *.2 b).collect(_.reduce('+++')).reduce('++')
