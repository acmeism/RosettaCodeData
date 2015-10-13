//makes outputting a table possible in environments
//that don't support console.table()
function console_table(xs) {
    function pad(n,s) {
        var res = s;
        for (var i = s.length; i < n; i++)
            res += " ";
        return res;
    }

    if (xs.length === 0)
        console.log("No data");
    else {
        var widths = [];
        var cells = [];
        for (var i = 0; i <= xs.length; i++)
            cells.push([]);

        for (var s in xs[0]) {
            var len = s.length;
            cells[0].push(s);

            for (var i = 0; i < xs.length; i++) {
                var ss = "" + xs[i][s];
                len = Math.max(len, ss.length);
                cells[i+1].push(ss);
            }
            widths.push(len);
        }
        var s = "";
        for (var x = 0; x < cells.length; x++) {
            for (var y = 0; y < widths.length; y++)
                s += "|" + pad(widths[y], cells[x][y]);
            s += "|\n";
        }
        console.log(s);
    }
}

//returns the entropy of a string as a number
function entropy(s) {
     //create an object containing each individual char
	//and the amount of iterations per char
    function prob(s) {
        var h = Object.create(null);
        s.split('').forEach(function(c) {
           h[c] && h[c]++ || (h[c] = 1);
        });
        return h;
    }

    s = s.toString(); //just in case
    var e = 0, l = s.length, h = prob(s);

    for (var i in h ) {
        var p = h[i]/l;
        e -= p * Math.log(p) / Math.log(2);
    }
    return e;
}

//creates Fibonacci Word to n as described on Rosetta Code
//see rosettacode.org/wiki/Fibonacci_word
function fibWord(n) {
    var wOne = "1", wTwo = "0", wNth = [wOne, wTwo], w = "", o = [];

    for (var i = 0; i < n; i++) {
        if (i === 0 || i === 1) {
            w = wNth[i];
        } else {
            w = wNth[i - 1] + wNth[i - 2];
            wNth.push(w);
        }
        var l = w.length;
        var e = entropy(w);

        if (l <= 21) {
        	o.push({
            	N: i + 1,
            	Length: l,
            	Entropy: e,
            	Word: w
        	});
        } else {
        	o.push({
            	N: i + 1,
            	Length: l,
            	Entropy: e,
            	Word: "..."
        	});
        }
    }

    try {
    	console.table(o);
    } catch (err) {
    	console_table(o);
    }
}

fibWord(37);
