<html><head><title>Donuts</title></head>
<body><pre id='x'></pre><script type="application/javascript">
function disp(x) {
	var e = document.createTextNode(x + '\n');
	document.getElementById('x').appendChild(e);
}

function pick(n, got, pos, from, show) {
	var cnt = 0;
	if (got.length == n) {
		if (show) disp(got.join(' '));
		return 1;
	}
	for (var i = pos; i < from.length; i++) {
		got.push(from[i]);
		cnt += pick(n, got, i, from, show);
		got.pop();
	}
	return cnt;
}

disp(pick(2, [], 0, ["iced", "jam", "plain"], true) + " combos");
disp("pick 3 out of 10: " + pick(3, [], 0, "a123456789".split(''), false) + " combos");
</script></body></html>
