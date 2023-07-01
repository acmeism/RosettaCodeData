String.prototype.parseSexpr = function() {
	var t = this.match(/\s*("[^"]*"|\(|\)|"|[^\s()"]+)/g)
	for (var o, c=0, i=t.length-1; i>=0; i--) {
		var n, ti = t[i].trim()
		if (ti == '"') return
		else if (ti == '(') t[i]='[', c+=1
		else if (ti == ')') t[i]=']', c-=1
		else if ((n=+ti) == ti) t[i]=n
		else t[i] = '\'' + ti.replace('\'', '\\\'') + '\''
		if (i>0 && ti!=']' && t[i-1].trim()!='(' ) t.splice(i,0, ',')
		if (!c) if (!o) o=true; else return
	}
	return c ? undefined : eval(t.join(''))
}

Array.prototype.toString = function() {
	var s=''; for (var i=0, e=this.length; i<e; i++) s+=(s?' ':'')+this[i]
	return '('+s+')'
}

Array.prototype.toPretty = function(s) {
	if (!s) s = ''
	var r = s + '(<br>'
	var s2 = s + Array(6).join('&nbsp;')
	for (var i=0, e=this.length; i<e; i+=1) {
		var ai = this[i]
		r += ai.constructor != Array ? s2+ai+'<br>' : ai.toPretty(s2)
	}
	return r + s + ')<br>'
}

var str = '((data "quoted data" 123 4.5)\n (data (!@# (4.5) "(more" "data)")))'
document.write('text:<br>', str.replace(/\n/g,'<br>').replace(/ /g,'&nbsp;'), '<br><br>')
var sexpr = str.parseSexpr()
if (sexpr === undefined)
	document.write('Invalid s-expr!', '<br>')
else
	document.write('s-expr:<br>', sexpr, '<br><br>', sexpr.constructor != Array ? '' : 'pretty print:<br>' + sexpr.toPretty())
