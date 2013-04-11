<html><head><title>Maze maker</title>
<style type="text/css">
table { border-collapse: collapse }
td { width: 1em; height: 1em; border: 1px solid }
td.s { border-bottom: none }
td.n { border-top: none }
td.w { border-left: none }
td.e { border-right: none }
td.v { background: skyblue}
</style>
<script type="application/javascript">
Node.prototype.add = function(tag, cnt, txt) {
	for (var i = 0; i < cnt; i++)
		this.appendChild(ce(tag, txt));
}
Node.prototype.ins = function(tag) {
	this.insertBefore(ce(tag), this.firstChild)
}
Node.prototype.kid = function(i) { return this.childNodes[i] }
Node.prototype.cls = function(t) { this.className += ' ' + t }

NodeList.prototype.map = function(g) {
	for (var i = 0; i < this.length; i++) g(this[i]);
}

function ce(tag, txt) {
	var x = document.createElement(tag);
	if (txt !== undefined) x.innerHTML = txt;
	return x
}

function gid(e) { return document.getElementById(e) }
function irand(x) { return Math.floor(Math.random() * x) }

function make_maze() {
	var w = parseInt(gid('rows').value || 8, 10);
	var h = parseInt(gid('cols').value || 8, 10);
	var tbl = gid('maze');
	tbl.innerHTML = '';
	tbl.add('tr', h);
	tbl.childNodes.map(function(x) {
			x.add('th', 1);
			x.add('td', w, '*');
			x.add('th', 1)});
	tbl.ins('tr');
	tbl.add('tr', 1);
	tbl.firstChild.add('th', w + 2);
	tbl.lastChild.add('th', w + 2);
	for (var i = 1; i <= h; i++) {
		for (var j = 1; j <= w; j++) {
			tbl.kid(i).kid(j).neighbors = [
				tbl.kid(i + 1).kid(j),
				tbl.kid(i).kid(j + 1),
				tbl.kid(i).kid(j - 1),
				tbl.kid(i - 1).kid(j)
			];
		}
	}
	walk(tbl.kid(irand(h) + 1).kid(irand(w) + 1));
	gid('solve').style.display='inline';
}

function shuffle(x) {
	for (var i = 3; i > 0; i--) {
		j = irand(i + 1);
		if (j == i) continue;
		var t = x[j]; x[j] = x[i]; x[i] = t;
	}
	return x;
}

var dirs = ['s', 'e', 'w', 'n'];
function walk(c) {
	c.innerHTML = '&nbsp;';
	var idx = shuffle([0, 1, 2, 3]);
	for (var j = 0; j < 4; j++) {
		var i = idx[j];
		var x = c.neighbors[i];
		if (x.textContent != '*') continue;
		c.cls(dirs[i]), x.cls(dirs[3 - i]);
		walk(x);
	}
}

function solve(c, t) {
	if (c === undefined) {
		c = gid('maze').kid(1).kid(1);
		c.cls('v');
	}
	if (t === undefined)
		t = gid('maze')	.lastChild.previousSibling
				.lastChild.previousSibling;

	if (c === t) return 1;
	c.vis = 1;
	for (var i = 0; i < 4; i++) {
		var x = c.neighbors[i];
		if (x.tagName.toLowerCase() == 'th') continue;
		if (x.vis || !c.className.match(dirs[i]) || !solve(x, t))
			continue;

		x.cls('v');
		return 1;
	}
	c.vis = null;
	return 0;
}

</script></head>
<body><form><fieldset>
<label>rows </label><input id='rows' size="3"/>
<label>colums </label><input id='cols' size="3"/>
<a href="javascript:make_maze()">Generate</a>
<a id='solve' style='display:none' href='javascript:solve(); void(0)'>Solve</a>
</fieldset></form><table id='maze'/></body></html>
