function csv_to_table(s) {
	function ce(t) { return document.createElement(t); }
	function ap(t) { document.body.appendChild(t); }
	var t = ce('table'), f = 0; //1;
	s.split('\n').map(function(l) {
		var r = ce(f ? 'tr': 'thead');
		l.split(',').map(function (w) {
			var c = ce(f ? 'td' : 'th');
			c.textContent = w;
			r.appendChild(c);
		});
		t.appendChild(r);
		f = 1; //0;
	});
	//return t.innerHTML;
        return t.outerHTML;
}
/*
but also with this changes is very dependent by javascript engine and/or browser version (in: IE>=9, chrome )
*/
