import "./pattern" for Pattern

var text = """
this URI contains an illegal character, parentheses and a misplaced full stop:
http://en.wikipedia.org/wiki/Erich_Kästner_(camera_designer). (which is handled by http://mediawiki.org/).
and another one just to confuse the parser: http://en.wikipedia.org/wiki/-)
")" is handled the wrong way by the mediawiki parser.
ftp://domain.name/path(balanced_brackets)/foo.html
ftp://domain.name/path(balanced_brackets)/ending.in.dot.
ftp://domain.name/path(unbalanced_brackets/ending.in.dot.
leading junk ftp://domain.name/path/embedded?punct/uation.
leading junk ftp://domain.name/dangling_close_paren)
if you have other interesting URIs for testing, please add them here:
http://www.example.org/foo.html#includes_fragment
http://www.example.org/foo.html#enthält_Unicode-Fragment
"""

var i = Pattern.lower + Pattern.digit + "-+."
var j = Pattern.alpha + "_-.@:"
var k = j + "~\%!$&'()*+,;=?/#"
var e = "/l+0/i:////+1/j//+1/k"
var p = Pattern.new(e, Pattern.within, i, j, k)
var matches = p.findAll(text)
System.print("URI's found:\n")
for (m in matches) System.print(m.text)
k = k + "ä"
p = Pattern.new(e, Pattern.within, i, j, k)
System.print("\nIRI's found:\n")
matches = p.findAll(text)
for (m in matches) System.print(m.text)
