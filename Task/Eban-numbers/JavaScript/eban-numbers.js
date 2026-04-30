	const intervals = [
	    { start: 2, end: 1000, print: true },
	    { start: 1000, end: 4000, print: true },
	    { start: 2, end: 10000, print: false },
	    { start: 2, end: 100000, print: false },
	    { start: 2, end: 1000000, print: false },
	    { start: 2, end: 10000000, print: false },
	    { start: 2, end: 100000000, print: false },
	    { start: 2, end: 1000000000, print: false },
	];
	for (const intv of intervals) {
	    if (intv.start === 2) {
	        console.log(`eban numbers up to and including ${intv.end}:`);
	    } else {
	        console.log(`eban numbers bwteen ${intv.start} and ${intv.end} (inclusive):`);
	    }
	    let count = 0;
	    for (let i = intv.start; i <= intv.end; i += 2) {
	        let b = Math.floor(i / 1000000000);
	        let r = i % 1000000000;
	        let m = Math.floor(r / 1000000);
	        r = i % 1000000;
	        let t = Math.floor(r / 1000);
	        r %= 1000;
	        if (m >= 30 && m <= 66) m %= 10;
	        if (t >= 30 && t <= 66) t %= 10;
	        if (r >= 30 && r <= 66) r %= 10;
	        if (b === 0 || b === 2 || b === 4 || b === 6) {
	            if (m === 0 || m === 2 || m === 4 || m === 6) {
	                if (t === 0 || t === 2 || t === 4 || t === 6) {
	                    if (r === 0 || r === 2 || r === 4 || r === 6) {
	                        if (intv.print) process.stdout.write(i + ' ');
	                        count++;
	                    }
	                }
	            }
	        }
	    }
	    if (intv.print) {
	        console.log();
	    }
	    console.log(`count = ${count}\n`);
	}
