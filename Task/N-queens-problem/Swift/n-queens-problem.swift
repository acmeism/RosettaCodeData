	let maxn = 31

	func nq(n: Int) -> Int {
	    var cols = Array(repeating: 0, count: maxn)
	    var diagl = Array(repeating: 0, count: maxn)
	    var diagr = Array(repeating: 0, count: maxn)
	    var posibs = Array(repeating: 0, count: maxn)
	    var num = 0
	    for q0 in 0...n-3 {
		for q1 in q0+2...n-1 {
		    let bit0: Int = 1<<q0
		    let bit1: Int = 1<<q1
		    var d: Int = 0
		    cols[0] = bit0 | bit1 | (-1<<n)
		    diagl[0] = (bit0<<1|bit1)<<1
		    diagr[0] = (bit0>>1|bit1)>>1

		    var posib: Int = ~(cols[0] | diagl[0] | diagr[0])

		    while (d >= 0) {
			while(posib != 0) {
			    let bit: Int = posib & -posib
			    let ncols: Int = cols[d] | bit
			    let ndiagl: Int = (diagl[d] | bit) << 1;
			    let ndiagr: Int = (diagr[d] | bit) >> 1;
			    let nposib: Int = ~(ncols | ndiagl | ndiagr);
			    posib^=bit
			    num += (ncols == -1 ? 1 : 0)
			    if (nposib != 0){
				if(posib != 0) {
				    posibs[d] = posib
				    d += 1
				}
				cols[d] = ncols
				diagl[d] = ndiagl
				diagr[d] = ndiagr
				posib = nposib
			    }
			}
			d -= 1
			posib = d<0 ? n : posibs[d]

		    }
		}

	    }
	    return num*2
	}
	if(CommandLine.arguments.count == 2) {

	    let board_size: Int = Int(CommandLine.arguments[1])!
	    print ("Number of solutions for board size \(board_size) is: \(nq(n:board_size))")

	} else {
	    print("Usage: 8q <n>")
	}
