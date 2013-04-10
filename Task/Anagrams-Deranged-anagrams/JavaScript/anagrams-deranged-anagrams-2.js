<html><head><title>Intoxication</title></head>
<body><pre id='x'></pre>
<script type="application/javascript">

function show(t) {
	var l = document.createTextNode(t + '\n');
	document.getElementById('x').appendChild(l);
}

// get words; be ware of cross-site restrictions on XMLHttpRequest
var words = null;
var req = new XMLHttpRequest();
req.open('GET', 'file:///tmp/unixdict.txt', false);
req.send(null);
words = req.responseText.split('\n');

var idx = {};
for (var i = 0; i < words.length; i++) {
	var t = words[i].split('').sort().join('');
	if (idx[t]) idx[t].push(words[i]);
	else	    idx[t] = [words[i]];
}

var best = '';
var best_pair;
for (var i in idx) {
	if (i.length <= best.length) continue;
	if (idx[i].length == 1) continue;

	var a = idx[i], got = null;
	for (var j = 0, l1 = a[j]; j < a.length && !got; j++) {
		for (var k = j + 1, l2 = a[k]; k < a.length && !got; k++)
			for (var m = 0; m < l1.length || !(got = [l2]); m++)
				if (l1[m] == l2[m]) break;
		if (got) got.push(l1);
	}

	if (got) {
		best_pair = got;
		best = got[0];
	}
}

show(best_pair);
</script></body></html>
