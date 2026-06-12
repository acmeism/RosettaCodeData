use v6;
use IETF::RFC_Grammar::URI;

say q:to/EOF/.match(/ <IETF::RFC_Grammar::URI::absolute-URI> /, :g).list.join("\n");
    this URI contains an illegal character, parentheses and a misplaced full stop:
    http://en.wikipedia.org/wiki/Erich_Kästner_(camera_designer). (which is handled by http://mediawiki.org/).
    and another one just to confuse the parser: http://en.wikipedia.org/wiki/-)
    ")" is handled the wrong way by the mediawiki parser.
    ftp://domain.name/path(balanced_brackets)/foo.html
    ftp://domain.name/path(balanced_brackets)/ending.in.dot.
    ftp://domain.name/path(unbalanced_brackets/ending.in.dot.
    leading junk ftp://domain.name/path/embedded?punct/uation.
    leading junk ftp://domain.name/dangling_close_paren)
    EOF

say $/[*-1];
say "We matched $/[*-1], which is a $/[*-1].^name() at position $/[*-1].from() to $/[*-1].to()"
