	const bigInt = require('big-integer');
	const nMax = 250;
	const nBranches = 4;
	const rooted = new Array(nMax + 1).fill(bigInt.zero);
	const unrooted = new Array(nMax + 1).fill(bigInt.zero);
	const c = new Array(nBranches);
	rooted[0] = rooted[1] = bigInt.one;
	unrooted[0] = unrooted[1] = bigInt.one;
	function tree(br, n, l, inSum, cnt) {
	    let sum = inSum;
	    for (let b = br + 1; b <= nBranches; b++) {
	        sum += n;
	        if (sum > nMax || (l * 2 >= sum && b >= nBranches))
	            return;
	        let tmp = rooted[n];
	        if (b === br + 1) {
	            c[br] = tmp.multiply(cnt);
	        } else {
	            c[br] = c[br].multiply(tmp.add(bigInt(b - br - 1)));
	            c[br] = c[br].divide(bigInt(b - br));
	        }
	        if (l * 2 < sum)
	            unrooted[sum] = unrooted[sum].add(c[br]);
	        if (b < nBranches)
	            rooted[sum] = rooted[sum].add(c[br]);
	        for (let m = n - 1; m > 0; m--)
	            tree(b, m, l, sum, c[br]);
	    }
	}
	function bicenter(s) {
	    if ((s & 1) === 0) {
	        let tmp = rooted[s / 2];
	        tmp = tmp.add(bigInt.one).multiply(rooted[s / 2]);
	        unrooted[s] = unrooted[s].add(tmp.shiftRight(1));
	    }
	}
	for (let n = 1; n <= nMax; n++) {
	    tree(0, n, n, 1, bigInt.one);
	    bicenter(n);
	    console.log(`${n}: ${unrooted[n].toString()}`);
	}
